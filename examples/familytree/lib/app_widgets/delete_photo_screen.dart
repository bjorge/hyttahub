// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:familytree/l10n/intl_localizations.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:familytree/app_blocs/app_submit_bloc.dart';
import 'package:familytree/app_widgets/app_submit_button.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:familytree/proto/app_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DeletePhotoScreen extends StatefulWidget {
  const DeletePhotoScreen({
    super.key,
    required this.siteId,
    required this.event,
  });

  final String siteId;
  final String event;

  @override
  State<DeletePhotoScreen> createState() => _DeletePhotoScreenState();
}

class _DeletePhotoScreenState extends State<DeletePhotoScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final initialSubmitEvent = SubmitAppEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    return BlocProvider<AppSubmitBloc>(
      create:
          (_) =>
              AppSubmitBloc(widget.siteId, initialSubmitEvent)
                ..payloadChanged = true
                ..isFormValid = false, // toggled by the confirmation checkbox
      child: BlocConsumer<AppSubmitBloc, BaseSubmitState<SubmitAppEvent>>(
        listener: (context, state) {
          if (state.submissionState.state ==
              CommonSubmitBlocState_State.success) {
            context.pop();
            context.pop();
          }
        },
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.app_deletePhotoTitle),
              actions: [AppSubmitIconButton(formKey: _formKey)],
            ),
            body: Form(
              key: _formKey,
              child: CommonSubmitFormLayout<SubmitAppEvent>(
                submitState: state,
                children: [
                  DeletePhotoConfirmationCheckbox(
                    formKey: _formKey,
                    labelText: l10n.app_deletePhotoConfirmation,
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

class DeletePhotoConfirmationCheckbox
    extends
        BaseConfirmationCheckbox<
          AppSubmitBloc,
          AppEventSubmission,
          SubmitAppEvent
        > {
  const DeletePhotoConfirmationCheckbox({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: appEventSubmissionFactory);
}
