// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/account_widgets/auth_submit_button.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/auth_bloc/auth_submit_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/auth_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class RemoveAccountScreen extends StatefulWidget {
  const RemoveAccountScreen({super.key, required this.event});

  final String event;

  @override
  State<RemoveAccountScreen> createState() => _RemoveAccountScreenState();
}

class _RemoveAccountScreenState extends State<RemoveAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final initialSubmitEvent = AuthBlocEvent.fromBuffer(
      base64Url.decode(widget.event),
    );
    final email = GetIt.instance<AuthBloc>().state.email;

    return BlocProvider<AuthSubmitBloc>(
      create: (_) => AuthSubmitBloc(email, initialSubmitEvent)
        ..payloadChanged = true
        ..isFormValid = false, // Toggled by the confirmation checkbox
      child: BlocConsumer<AuthSubmitBloc, BaseSubmitState<AuthBlocEvent>>(
        listener: (context, state) {
          if (state.submissionState.state ==
              CommonSubmitBlocState_State.success) {
            // Pop this screen, then the account screen to go back to login.
            // The AuthBloc will handle the actual logout and state change.
            context.pop();
            context.pop();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                HyttaHubLocalizations.of(context)!.removeAccountTitle,
              ),
              actions: [AuthSubmitIconButton(formKey: _formKey)],
            ),
            body: Form(
              key: _formKey,
              child: CommonSubmitFormLayout<AuthBlocEvent>(
                submitState: state,
                children: [
                  RemoveAccountConfirmationCheckbox(
                    formKey: _formKey,
                    labelText: HyttaHubLocalizations.of(
                      context,
                    )!.removeAccountConfirmation,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class RemoveAccountConfirmationCheckbox
    extends
        BaseConfirmationCheckbox<
          AuthSubmitBloc,
          AuthEventSubmission,
          AuthBlocEvent
        > {
  const RemoveAccountConfirmationCheckbox({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: authEventSubmissionFactory);
}
