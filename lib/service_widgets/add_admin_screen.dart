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
import 'package:flutter/material.dart';
import 'package:hyttahub/utilities/bloom_filter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/service_widgets/service_submit_button.dart';
import 'package:protobuf/protobuf.dart';

class AddServiceAdminScreen extends StatefulWidget {
  const AddServiceAdminScreen({super.key, required this.event});

  final String event;

  @override
  State<AddServiceAdminScreen> createState() => _AddServiceAdminScreenState();
}

class _AddServiceAdminScreenState extends State<AddServiceAdminScreen> {
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
                          HyttaHubLocalizations.of(context)!.addAdminTitle,
                        ),
                        actions: [ServiceSubmitIconButton(formKey: _formKey)],
                      ),
                      body: CommonSubmitFormLayout<SubmitServiceEvent>(
                        submitState: submitState,
                        children: [
                          AdminAliasInputWidget(
                            formKey: _formKey,
                            serviceState: serviceState,
                            labelText: HyttaHubLocalizations.of(
                              context,
                            )!.aliasLabel,
                          ),
                          AdminEmailInputWidget(
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

class AdminAliasInputWidget
    extends
        BaseTextFormField<
          ServiceSubmitBloc,
          ServiceEventSubmission,
          SubmitServiceEvent
        > {
  const AdminAliasInputWidget({
    super.key,
    required super.formKey,
    required this.serviceState,
    required super.labelText,
  }) : super(eventFactory: serviceEventSubmissionFactory);

  final ServiceReplayBlocState serviceState;

  @override
  String? validator(BuildContext context, String value) {
    if (value.trim().isEmpty) {
      return HyttaHubLocalizations.of(context)!.nicknameEmptyError;
    }
    if (serviceState.serviceAdmins.values.any(
      (admin) => admin.alias.toLowerCase() == value.trim().toLowerCase(),
    )) {
      return HyttaHubLocalizations.of(context)!.adminAliasExistsError;
    }
    return null;
  }

  @override
  String getValueFromPayload(SubmitServiceEvent payload) {
    return payload.event.addServiceAdmin.alias;
  }

  @override
  SubmitServiceEvent updatePayload(
    SubmitServiceEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.event.addServiceAdmin.alias = newValue;
    return updatedPayload;
  }
}

class AdminEmailInputWidget
    extends
        BaseTextFormField<
          ServiceSubmitBloc,
          ServiceEventSubmission,
          SubmitServiceEvent
        > {
  const AdminEmailInputWidget({
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
    updatedPayload.addServiceAdminEmail = newValue;

    // update the bloom with the single email
    if (updatedPayload.addServiceAdminEmail.isEmpty) {
      updatedPayload.event.addServiceAdmin.filter = serviceState.filter;
    } else {
      final bloom = BloomFilterProcessor(
        size: serviceState.filter.size,
        hashCount: serviceState.filter.hashCount,
        bitArray: Uint8List.fromList(serviceState.filter.bitArray),
      )..add(updatedPayload.addServiceAdminEmail);

      updatedPayload.event.addServiceAdmin.filter = BloomFilter()
        ..size = bloom.size
        ..hashCount = bloom.hashCount
        ..bitArray = bloom.bitArray;
    }
    return updatedPayload;
  }
}
