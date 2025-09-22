// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/common_blocs/allowed_emails_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:hyttahub/site_blocs/site_submit_bloc.dart';
import 'package:hyttahub/site_widgets/site_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';

class UpdateMemberScreen extends StatefulWidget {
  const UpdateMemberScreen({
    super.key,
    required this.event,
    required this.siteId,
    required this.originalEmail,
  });

  final String event;
  final String siteId;
  final String originalEmail;

  @override
  State<UpdateMemberScreen> createState() => _UpdateMemberScreenState();
}

class _UpdateMemberScreenState extends State<UpdateMemberScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final submitEvent = SubmitSiteEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<AllowedEmailsBloc>(
          create: (_) =>
              AllowedEmailsBloc(firebaseSiteUsersPath(widget.siteId))..add(
                AllowedEmailsBlocEvent(
                  fetchNow: AllowedEmailsBlocEvent_FetchedAllowedEmails(),
                ),
              ),
        ),
        BlocProvider<SiteSubmitBloc>(
          create: (_) => SiteSubmitBloc(widget.siteId, submitEvent),
        ),
        BlocProvider<SiteReplayBloc>(
          create: (_) =>
              SiteReplayBloc(widget.siteId)
                ..add(CommonReplayBlocEvent(listen: true)),
        ),
      ],
      child: Form(
        key: _formKey,
        child: BlocBuilder<AllowedEmailsBloc, AllowedEmailsBlocState>(
          key: Key('AllowedEmailsBloc-update-member-${widget.siteId}'),
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

            return BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
              builder: (context, siteState) {
                if (!siteState.hasState() ||
                    siteState.state == CommonReplayStateEnum.fetchingConfig) {
                  return const Center(child: CircularProgressIndicator());
                }
                return BlocConsumer<
                  SiteSubmitBloc,
                  BaseSubmitState<SubmitSiteEvent>
                >(
                  builder: (context, submitState) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(
                          HyttaHubLocalizations.of(context)!.updateMemberTitle,
                        ),
                        actions: [SiteSubmitIconButton(formKey: _formKey)],
                      ),
                      body: CommonSubmitFormLayout<SubmitSiteEvent>(
                        submitState: submitState,
                        children: [
                          UpdateMemberNameInputWidget(
                            formKey: _formKey,
                            members: siteState.members.values.toList(),
                            originalName:
                                submitEvent.event.updateMember.memberName,
                            labelText: HyttaHubLocalizations.of(
                              context,
                            )!.memberNameLabel,
                          ),
                          UpdateAdminCheckboxWidget(
                            formKey: _formKey,
                            labelText: HyttaHubLocalizations.of(
                              context,
                            )!.administratorLabel,
                          ),
                          UpdateMemberEmailInputWidget(
                            formKey: _formKey,
                            allowedEmails: allowedEmailsState.emails,
                            originalEmail: widget.originalEmail,
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
                        BaseSubmitState<SubmitSiteEvent> state,
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

class UpdateMemberNameInputWidget
    extends
        BaseTextFormField<
          SiteSubmitBloc,
          SiteEventSubmission,
          SubmitSiteEvent
        > {
  const UpdateMemberNameInputWidget({
    super.key,
    required super.formKey,
    required this.members,
    required this.originalName,
    required super.labelText,
  }) : super(eventFactory: siteEventSubmissionFactory);

  final List<SiteReplayBlocState_Member> members;
  final String originalName;

  @override
  String? validator(BuildContext context, String value) {
    if (value.trim().isEmpty) {
      return HyttaHubLocalizations.of(context)!.memberNameEmptyError;
    }
    if (value.trim().toLowerCase() != originalName.toLowerCase() &&
        members.any(
          (member) => member.name.toLowerCase() == value.trim().toLowerCase(),
        )) {
      return HyttaHubLocalizations.of(context)!.memberNameExistsError;
    }
    return null;
  }

  @override
  String getValueFromPayload(SubmitSiteEvent payload) {
    return payload.event.updateMember.memberName;
  }

  @override
  SubmitSiteEvent updatePayload(
    SubmitSiteEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.event.updateMember.memberName = newValue.trim();
    return updatedPayload;
  }
}

class UpdateMemberEmailInputWidget
    extends
        BaseTextFormField<
          SiteSubmitBloc,
          SiteEventSubmission,
          SubmitSiteEvent
        > {
  const UpdateMemberEmailInputWidget({
    super.key,
    required super.formKey,
    required this.allowedEmails,
    required this.originalEmail,
    required super.labelText,
  }) : super(eventFactory: siteEventSubmissionFactory);

  final Map<String, AllowedEmailsBlocState_UserInfo> allowedEmails;
  final String originalEmail;

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
  String getValueFromPayload(SubmitSiteEvent payload) {
    return payload.updateMemberNewEmail;
  }

  @override
  SubmitSiteEvent updatePayload(
    SubmitSiteEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.updateMemberNewEmail = newValue;
    return updatedPayload;
  }
}

class UpdateAdminCheckboxWidget
    extends
        BaseCheckboxFormField<
          SiteSubmitBloc,
          SiteEventSubmission,
          SubmitSiteEvent
        > {
  const UpdateAdminCheckboxWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: siteEventSubmissionFactory);

  @override
  bool getValueFromPayload(SubmitSiteEvent payload) {
    return payload.event.updateMember.admin;
  }

  @override
  SubmitSiteEvent updatePayload(
    SubmitSiteEvent originalPayload,
    bool newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.event.updateMember.admin = newValue;
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, bool value) {
    return null; // checked or not checked is valid
  }
}
