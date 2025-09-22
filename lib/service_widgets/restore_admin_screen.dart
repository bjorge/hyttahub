// Copyright (c) 2025 bjorge

import 'dart:convert';
import 'dart:typed_data';

import 'package:hyttahub/common_blocs/allowed_emails_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';
import 'package:hyttahub/proto/bloom_filter.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/service_events.pb.dart';
import 'package:hyttahub/proto/service_replay_bloc.pb.dart';
import 'package:hyttahub/service_blocs/service_replay_bloc.dart';
import 'package:hyttahub/service_blocs/service_submit_bloc.dart';
import 'package:hyttahub/service_widgets/service_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/utilities/bloom_filter.dart';
import 'package:protobuf/protobuf.dart';

class RestoreServiceAdminScreen extends StatefulWidget {
  const RestoreServiceAdminScreen({super.key, required this.event});

  final String event;

  @override
  State<RestoreServiceAdminScreen> createState() =>
      _RestoreServiceAdminScreenState();
}

class _RestoreServiceAdminScreenState extends State<RestoreServiceAdminScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final submitEvent = SubmitServiceEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<AllowedEmailsBloc>(
          create: (_) =>
              AllowedEmailsBloc(
                firebaseServiceServiceAdminsPath(firebaseServiceCollectionName),
              )..add(
                AllowedEmailsBlocEvent(
                  fetchNow: AllowedEmailsBlocEvent_FetchedAllowedEmails(),
                ),
              ),
        ),
        BlocProvider<ServiceSubmitBloc>(
          create: (_) => ServiceSubmitBloc(submitEvent),
        ),
        BlocProvider<ServiceReplayBloc>(
          create: (_) =>
              ServiceReplayBloc()..add(CommonReplayBlocEvent(listen: true)),
        ),
      ],
      child: Form(
        key: _formKey,
        child: BlocBuilder<AllowedEmailsBloc, AllowedEmailsBlocState>(
          builder: (context, allowedEmailsState) {
            if (!allowedEmailsState.hasState() ||
                allowedEmailsState.state ==
                    AllowedEmailsBlocState_State.fetching) {
              return const Center(child: CircularProgressIndicator());
            }
            if (allowedEmailsState.state ==
                AllowedEmailsBlocState_State.error) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(HyttaHubLocalizations.of(context)!.errorTitle),
                ),
                body: Text(HyttaHubLocalizations.of(context)!.unexpectedError),
              );
            }
            if (allowedEmailsState.state ==
                AllowedEmailsBlocState_State.permissionDenied) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(HyttaHubLocalizations.of(context)!.errorTitle),
                ),
                body: Center(
                  child: Text(
                    HyttaHubLocalizations.of(context)!.permissionDenied,
                  ),
                ),
              );
            }

            return BlocBuilder<ServiceReplayBloc, ServiceReplayBlocState>(
              builder: (context, serviceState) {
                if (!serviceState.hasState() ||
                    serviceState.state ==
                        CommonReplayStateEnum.fetchingConfig) {
                  return const Center(child: CircularProgressIndicator());
                }
                return BlocConsumer<
                  ServiceSubmitBloc,
                  BaseSubmitState<SubmitServiceEvent>
                >(
                  builder: (context, submitState) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(
                          HyttaHubLocalizations.of(context)!.restoreAdminTitle,
                        ),
                        actions: [ServiceSubmitIconButton(formKey: _formKey)],
                      ),
                      body: CommonSubmitFormLayout<SubmitServiceEvent>(
                        submitState: submitState,
                        children: [
                          RestoreAdminAliasInputWidget(
                            formKey: _formKey,
                            admins: serviceState.serviceAdmins.values.toList(),
                            labelText: HyttaHubLocalizations.of(
                              context,
                            )!.aliasLabel,
                          ),
                          RestoreAdminEmailInputWidget(
                            formKey: _formKey,
                            allowedEmails: allowedEmailsState.emails,
                            serviceState: serviceState,
                            labelText: HyttaHubLocalizations.of(
                              context,
                            )!.loginEmailLabel,
                          ),
                        ],
                      ),
                    );
                  },
                  listener:
                      (
                        BuildContext context,
                        BaseSubmitState<SubmitServiceEvent> state,
                      ) {
                        if (state.submissionState.state ==
                            CommonSubmitBlocState_State.success) {
                          Navigator.pop(context);
                        }
                      },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class RestoreAdminAliasInputWidget
    extends
        BaseTextFormField<
          ServiceSubmitBloc,
          ServiceEventSubmission,
          SubmitServiceEvent
        > {
  const RestoreAdminAliasInputWidget({
    super.key,
    required super.formKey,
    required this.admins,
    required super.labelText,
  }) : super(eventFactory: serviceEventSubmissionFactory);

  final List<ServiceAdmin> admins;

  @override
  String? validator(BuildContext context, String value) {
    if (value.trim().isEmpty) {
      return HyttaHubLocalizations.of(context)!.nicknameEmptyError;
    }
    if (admins.any(
      (admin) => admin.alias.toLowerCase() == value.trim().toLowerCase(),
    )) {
      return HyttaHubLocalizations.of(context)!.adminAliasExistsError;
    }
    return null;
  }

  @override
  String getValueFromPayload(SubmitServiceEvent payload) {
    return payload.event.restoreServiceAdmin.alias;
  }

  @override
  SubmitServiceEvent updatePayload(
    SubmitServiceEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.event.restoreServiceAdmin.alias = newValue;
    return updatedPayload;
  }
}

class RestoreAdminEmailInputWidget
    extends
        BaseTextFormField<
          ServiceSubmitBloc,
          ServiceEventSubmission,
          SubmitServiceEvent
        > {
  const RestoreAdminEmailInputWidget({
    super.key,
    required super.formKey,
    required this.allowedEmails,
    required this.serviceState,
    required super.labelText,
  }) : super(eventFactory: serviceEventSubmissionFactory);

  final Map<String, AllowedEmailsBlocState_UserInfo> allowedEmails;
  final ServiceReplayBlocState serviceState;

  @override
  String? validator(BuildContext context, String value) {
    final localizations = HyttaHubLocalizations.of(context)!;

    final generalEmailError = emailValidator(value, context);
    if (generalEmailError != null) {
      return generalEmailError;
    }

    if (allowedEmails.keys.any(
      (email) => email.toLowerCase() == value.trim().toLowerCase(),
    )) {
      return localizations.emailExistsError;
    }
    return null;
  }

  @override
  String getValueFromPayload(SubmitServiceEvent payload) {
    return payload.addServiceAdminEmail;
  }

  @override
  SubmitServiceEvent updatePayload(
    SubmitServiceEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.addServiceAdminEmail = newValue.trim().toLowerCase();

    if (updatedPayload.addServiceAdminEmail.isEmpty) {
      updatedPayload.event.restoreServiceAdmin.filter = serviceState.filter;
    } else {
      final bloom = BloomFilterProcessor(
        size: serviceState.filter.size,
        hashCount: serviceState.filter.hashCount,
        bitArray: Uint8List.fromList(serviceState.filter.bitArray),
      )..add(updatedPayload.addServiceAdminEmail);

      updatedPayload.event.restoreServiceAdmin.filter = BloomFilter()
        ..size = bloom.size
        ..hashCount = bloom.hashCount
        ..bitArray = bloom.bitArray;
    }
    return updatedPayload;
  }
}
