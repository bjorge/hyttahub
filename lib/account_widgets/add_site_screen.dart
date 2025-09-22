// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/account_blocs/account_submit_bloc.dart';
import 'package:hyttahub/account_widgets/account_submit_button.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/proto/account_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';

class AddSiteScreen extends StatefulWidget {
  const AddSiteScreen({super.key, required this.event});

  final String event;

  @override
  State<AddSiteScreen> createState() => _AddSiteScreenState();
}

class _AddSiteScreenState extends State<AddSiteScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userEmail = context.read<AuthBloc>().state.email;

    final submitEvent = SubmitAccountEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    return BlocProvider(
      create: (_) => AccountSubmitBloc(userEmail, submitEvent),
      child: Form(
        key: _formKey,
        child:
            BlocConsumer<
              AccountSubmitBloc,
              BaseSubmitState<SubmitAccountEvent>
            >(
              builder: (context, submitState) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      HyttaHubLocalizations.of(context)!.createSiteTitle,
                    ),
                    actions: [AccountSubmitIconButton(formKey: _formKey)],
                  ),
                  body: CommonSubmitFormLayout<SubmitAccountEvent>(
                    submitState: submitState,
                    children: [
                      SiteNameInputWidget(
                        formKey: _formKey,
                        labelText: HyttaHubLocalizations.of(
                          context,
                        )!.siteNameLabel,
                      ),
                      SiteUserNameInputWidget(
                        formKey: _formKey,
                        labelText: HyttaHubLocalizations.of(
                          context,
                        )!.userNameLabel,
                      ),
                    ],
                  ),
                );
              },
              listener:
                  (
                    BuildContext context,
                    BaseSubmitState<SubmitAccountEvent> state,
                  ) {
                    if (state.submissionState.state ==
                        CommonSubmitBlocState_State.success) {
                      Navigator.pop(context);
                    }
                  },
            ),
      ),
    );
  }
}

class SiteNameInputWidget
    extends
        BaseTextFormField<
          AccountSubmitBloc,
          AccountEventSubmission,
          SubmitAccountEvent
        > {
  const SiteNameInputWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: accountEventSubmissionFactory);

  @override
  String? validator(BuildContext context, String value) {
    if (value.isEmpty) {
      return HyttaHubLocalizations.of(context)!.siteNameEmptyError;
    }
    return null;
  }

  @override
  String getValueFromPayload(SubmitAccountEvent payload) {
    return payload.createSiteName;
  }

  @override
  SubmitAccountEvent updatePayload(
    SubmitAccountEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.createSiteName = newValue;
    return updatedPayload;
  }
}

class SiteUserNameInputWidget
    extends
        BaseTextFormField<
          AccountSubmitBloc,
          AccountEventSubmission,
          SubmitAccountEvent
        > {
  const SiteUserNameInputWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: accountEventSubmissionFactory);

  @override
  String? validator(BuildContext context, String value) {
    if (value.isEmpty) {
      return HyttaHubLocalizations.of(context)!.userNameEmptyError;
    }
    return null;
  }

  @override
  String getValueFromPayload(SubmitAccountEvent payload) {
    return payload.createSiteUserName;
  }

  @override
  SubmitAccountEvent updatePayload(
    SubmitAccountEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.createSiteUserName = newValue;
    return updatedPayload;
  }
}
