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

class LeaveSiteScreen extends StatefulWidget {
  const LeaveSiteScreen({super.key, required this.event});

  final String event;

  @override
  State<LeaveSiteScreen> createState() => _LeaveSiteScreenState();
}

class _LeaveSiteScreenState extends State<LeaveSiteScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userEmail = context.read<AuthBloc>().state.email;

    final submitEvent = SubmitAccountEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    return BlocProvider(
      create: (_) => AccountSubmitBloc(userEmail, submitEvent)
        ..isFormValid = false
        ..payloadChanged = true,
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
                      HyttaHubLocalizations.of(context)!.removeSiteTitle,
                    ),
                    actions: [AccountSubmitIconButton(formKey: _formKey)],
                  ),
                  body: CommonSubmitFormLayout<SubmitAccountEvent>(
                    submitState: submitState,
                    children: [
                      RemoveSiteCheckboxWidget(
                        formKey: _formKey,
                        labelText: HyttaHubLocalizations.of(
                          context,
                        )!.leaveSiteConfirmation,
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

class RemoveSiteCheckboxWidget
    extends
        BaseConfirmationCheckbox<
          AccountSubmitBloc,
          AccountEventSubmission,
          SubmitAccountEvent
        > {
  const RemoveSiteCheckboxWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: accountEventSubmissionFactory);
}
