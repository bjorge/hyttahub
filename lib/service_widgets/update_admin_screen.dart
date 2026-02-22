// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/common_blocs/allowed_emails_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';
import 'package:hyttahub/proto/bloom_filter.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/service_events.pb.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/service_blocs/service_replay_bloc.dart';
import 'package:hyttahub/service_blocs/service_submit_bloc.dart';
import 'package:hyttahub/service_widgets/service_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/utilities/bloom_filter.dart';


class UpdateServiceAdminScreen extends StatefulWidget {
  const UpdateServiceAdminScreen({
    super.key,
    required this.event,
    required this.originalEmail,
  });

  final String event;
  final String originalEmail;

  @override
  State<UpdateServiceAdminScreen> createState() =>
      _UpdateServiceAdminScreenState();
}

class _UpdateServiceAdminScreenState extends State<UpdateServiceAdminScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final submitEvent = SubmitServiceEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<ServiceSubmitBloc>(
          create: (_) => ServiceSubmitBloc(submitEvent),
        ),
      ],
      child: Form(
        key: _formKey,
        child: BlocBuilder<ServiceReplayBloc, ServiceReplayBlocState>(
          builder: (context, serviceState) {
            final allowedEmailsState =
                context.watch<ServiceAllowedEmailsBloc>().state;
            final currentUserEmail = context.read<AuthBloc>().state.email;
            final isCurrentUser = currentUserEmail == widget.originalEmail;
            final isOnlyAdmin = serviceState.serviceAdmins.length == 1;
            final emailFieldEnabled = !(isCurrentUser && isOnlyAdmin);

            return BlocConsumer<
              ServiceSubmitBloc,
              BaseSubmitState<SubmitServiceEvent>
            >(
              builder: (context, submitState) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      HyttaHubLocalizations.of(context)!.updateAdminTitle,
                    ),
                    actions: [ServiceSubmitIconButton(formKey: _formKey)],
                  ),
                  body: CommonSubmitFormLayout<SubmitServiceEvent>(
                    submitState: submitState,
                    children: [
                      UpdateAdminAliasInputWidget(
                        formKey: _formKey,
                        admins: serviceState.serviceAdmins.values.toList(),
                        originalAlias:
                            submitEvent.event.updateServiceAdmin.alias,
                        labelText: HyttaHubLocalizations.of(
                          context,
                        )!.aliasLabel,
                      ),
                      if (emailFieldEnabled)
                        UpdateAdminEmailInputWidget(
                          formKey: _formKey,
                          allowedEmails: allowedEmailsState.emails,
                          originalEmail: widget.originalEmail,
                          serviceState: serviceState,
                          labelText: HyttaHubLocalizations.of(
                            context,
                          )!.loginEmailLabel,
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            initialValue: widget.originalEmail,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: HyttaHubLocalizations.of(
                                context,
                              )!.loginEmailLabel,
                              helperText: HyttaHubLocalizations.of(
                                context,
                              )!.cannotChangeEmailWhenOnlyAdminError,
                            ),
                          ),
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
        ),
      ),
    );
  }
}

class UpdateAdminAliasInputWidget
    extends
        BaseTextFormField<
          ServiceSubmitBloc,
          ServiceEventSubmission,
          SubmitServiceEvent
        > {
  const UpdateAdminAliasInputWidget({
    super.key,
    required super.formKey,
    required this.admins,
    required this.originalAlias,
    required super.labelText,
  }) : super(eventFactory: serviceEventSubmissionFactory);

  final List<ServiceAdmin> admins;
  final String originalAlias;

  @override
  String? validator(BuildContext context, String value) {
    if (value.trim().isEmpty) {
      return HyttaHubLocalizations.of(context)!.nicknameEmptyError;
    }
    if (value.trim().toLowerCase() != originalAlias.toLowerCase() &&
        admins.any(
          (admin) => admin.alias.toLowerCase() == value.trim().toLowerCase(),
        )) {
      return HyttaHubLocalizations.of(context)!.adminAliasExistsError;
    }
    return null;
  }

  @override
  String getValueFromPayload(SubmitServiceEvent payload) {
    return payload.event.updateServiceAdmin.alias;
  }

  @override
  SubmitServiceEvent updatePayload(
    SubmitServiceEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.event.updateServiceAdmin.alias = newValue.trim();
    return updatedPayload;
  }
}

class UpdateAdminEmailInputWidget
    extends
        BaseTextFormField<
          ServiceSubmitBloc,
          ServiceEventSubmission,
          SubmitServiceEvent
        > {
  const UpdateAdminEmailInputWidget({
    super.key,
    required super.formKey,
    required this.allowedEmails,
    required this.originalEmail,
    required this.serviceState,
    required super.labelText,
  }) : super(eventFactory: serviceEventSubmissionFactory);

  final Map<String, AllowedEmailsBlocState_UserInfo> allowedEmails;
  final String originalEmail;
  final ServiceReplayBlocState serviceState;

  @override
  String? validator(BuildContext context, String value) {
    final localizations = HyttaHubLocalizations.of(context)!;

    final generalEmailError = emailValidator(value, context);
    if (generalEmailError != null) {
      return generalEmailError;
    }

    if (value.trim().toLowerCase() != originalEmail.toLowerCase() &&
        allowedEmails.keys.any(
          (email) => email.toLowerCase() == value.trim().toLowerCase(),
        )) {
      return localizations.emailExistsError;
    }
    return null;
  }

  @override
  String getValueFromPayload(SubmitServiceEvent payload) {
    return payload.updateServiceAdminNewEmail;
  }

  @override
  SubmitServiceEvent updatePayload(
    SubmitServiceEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.updateServiceAdminNewEmail = newValue;

    if (originalEmail == updatedPayload.updateServiceAdminNewEmail) {
      updatedPayload.event.updateServiceAdmin.filter = serviceState.filter;
    } else {
      final emails = allowedEmails.keys.toList();
      emails.remove(originalEmail);
      emails.add(updatedPayload.updateServiceAdminNewEmail);
      final bloom = BloomFilterProcessor(
        size: serviceState.filter.size,
        hashCount: serviceState.filter.hashCount,
      )..addAll(emails);

      updatedPayload.event.updateServiceAdmin.filter = BloomFilter()
        ..size = bloom.size
        ..hashCount = bloom.hashCount
        ..bitArray = bloom.bitArray;
    }

    return updatedPayload;
  }
}
