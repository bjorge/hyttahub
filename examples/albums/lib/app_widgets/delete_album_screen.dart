// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:albums/app_blocs/app_submit_bloc.dart';
import 'package:albums/app_widgets/app_submit_button.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:albums/l10n/app_localizations.dart';
import 'package:albums/proto/app_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DeleteAlbumScreen extends StatefulWidget {
  const DeleteAlbumScreen({
    super.key,
    required this.siteId,
    required this.event,
  });

  final String siteId;
  final String event;

  @override
  State<DeleteAlbumScreen> createState() => _DeleteAlbumScreenState();
}

class _DeleteAlbumScreenState extends State<DeleteAlbumScreen> {
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
            context.pop(); // Pop twice to get back to site screen
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.app_deleteAlbumTitle),
              actions: [AppSubmitIconButton(formKey: _formKey)],
            ),
            body: Form(
              key: _formKey,
              child: CommonSubmitFormLayout<SubmitAppEvent>(
                submitState: state,
                children: [
                  DeleteAlbumConfirmationCheckbox(
                    formKey: _formKey,
                    labelText:
                        AppLocalizations.of(context)!.app_deleteAlbumConfirmation,
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

class DeleteAlbumConfirmationCheckbox
    extends
        BaseConfirmationCheckbox<
          AppSubmitBloc,
          AppEventSubmission,
          SubmitAppEvent
        > {
  const DeleteAlbumConfirmationCheckbox({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: appEventSubmissionFactory);
}
