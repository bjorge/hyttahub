import 'dart:convert';

import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:template/app_blocs/app_replay_bloc.dart';
import 'package:template/app_widgets/app_submit_button.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:template/l10n/app_localizations.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DeletePhotoScreen extends StatefulWidget {
  const DeletePhotoScreen({
    super.key,
    required this.event,
    required this.siteId,
  });

  final String event;
  final String siteId;

  @override
  State<DeletePhotoScreen> createState() => _DeletePhotoScreenState();
}

class _DeletePhotoScreenState extends State<DeletePhotoScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final submitEvent = SubmitAppEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    return BlocProvider(
      create:
          (_) =>
              AppSubmitBloc(widget.siteId, submitEvent)
                ..isFormValid = false
                ..payloadChanged = true,
      child: Form(
        key: _formKey,
        child: BlocConsumer<AppSubmitBloc, BaseSubmitState<SubmitAppEvent>>(
          builder: (context, submitState) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                title: Text(
                  AppLocalizations.of(context)!.app_deletePhotoTitle,
                ),
                actions: [AppSubmitIconButton(formKey: _formKey)],
              ),
              body: CommonSubmitFormLayout<SubmitAppEvent>(
                submitState: submitState,
                children: [
                  DeletePhotoCheckboxWidget(
                    formKey: _formKey,
                    labelText:
                        AppLocalizations.of(
                          context,
                        )!.app_deletePhotoConfirmation,
                  ),
                ],
              ),
            );
          },
          listener: (
            BuildContext context,
            BaseSubmitState<SubmitAppEvent> state,
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

class DeletePhotoCheckboxWidget
    extends
        BaseConfirmationCheckbox<
          AppSubmitBloc,
          AppEventSubmission,
          SubmitAppEvent
        > {
  const DeletePhotoCheckboxWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: appEventSubmissionFactory);
}
