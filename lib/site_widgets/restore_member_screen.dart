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

class RestoreMemberScreen extends StatefulWidget {
  const RestoreMemberScreen({
    super.key,
    required this.event,
    required this.siteId,
  });

  final String event;
  final String siteId;

  @override
  State<RestoreMemberScreen> createState() => _RestoreMemberScreenState();
}

class _RestoreMemberScreenState extends State<RestoreMemberScreen> {
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
          key: Key('AllowedEmailsBloc-restore-member-${widget.siteId}'),
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
                          HyttaHubLocalizations.of(context)!.restoreMemberTitle,
                        ),
                        actions: [SiteSubmitIconButton(formKey: _formKey)],
                      ),
                      body: CommonSubmitFormLayout<SubmitSiteEvent>(
                        submitState: submitState,
                        children: [
                          RestoreMemberNameInputWidget(
                            formKey: _formKey,
                            members: siteState.members.values.toList(),
                            labelText: HyttaHubLocalizations.of(
                              context,
                            )!.memberNameLabel,
                          ),
                          RestoreAdminCheckboxWidget(
                            formKey: _formKey,
                            labelText: HyttaHubLocalizations.of(
                              context,
                            )!.administratorLabel,
                          ),
                          RestoreMemberEmailInputWidget(
                            formKey: _formKey,
                            allowedEmails: allowedEmailsState.emails,
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

class RestoreMemberNameInputWidget
    extends
        BaseTextFormField<
          SiteSubmitBloc,
          SiteEventSubmission,
          SubmitSiteEvent
        > {
  const RestoreMemberNameInputWidget({
    super.key,
    required super.formKey,
    required this.members,
    required super.labelText,
  }) : super(eventFactory: siteEventSubmissionFactory);

  final List<SiteReplayBlocState_Member> members;

  @override
  String? validator(BuildContext context, String value) {
    if (value.trim().isEmpty) {
      return HyttaHubLocalizations.of(context)!.memberNameEmptyError;
    }
    if (members.any(
      (member) => member.name.toLowerCase() == value.trim().toLowerCase(),
    )) {
      return HyttaHubLocalizations.of(context)!.memberNameExistsError;
    }
    return null;
  }

  @override
  String getValueFromPayload(SubmitSiteEvent payload) {
    return payload.event.restoreMember.memberName;
  }

  @override
  SubmitSiteEvent updatePayload(
    SubmitSiteEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.event.restoreMember.memberName = newValue;
    return updatedPayload;
  }
}

class RestoreMemberEmailInputWidget
    extends
        BaseTextFormField<
          SiteSubmitBloc,
          SiteEventSubmission,
          SubmitSiteEvent
        > {
  const RestoreMemberEmailInputWidget({
    super.key,
    required super.formKey,
    required this.allowedEmails,
    required super.labelText,
  }) : super(eventFactory: siteEventSubmissionFactory);

  final Map<String, AllowedEmailsBlocState_UserInfo> allowedEmails;

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
  String getValueFromPayload(SubmitSiteEvent payload) {
    return payload.addMemberEmail;
  }

  @override
  SubmitSiteEvent updatePayload(
    SubmitSiteEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.addMemberEmail = newValue;
    return updatedPayload;
  }
}

class RestoreAdminCheckboxWidget
    extends
        BaseCheckboxFormField<
          SiteSubmitBloc,
          SiteEventSubmission,
          SubmitSiteEvent
        > {
  const RestoreAdminCheckboxWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: siteEventSubmissionFactory);

  @override
  bool getValueFromPayload(SubmitSiteEvent payload) {
    return payload.event.restoreMember.admin;
  }

  @override
  SubmitSiteEvent updatePayload(
    SubmitSiteEvent originalPayload,
    bool newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.event.restoreMember.admin = newValue;
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, bool value) {
    return null; // checked or not checked is valid
  }
}
