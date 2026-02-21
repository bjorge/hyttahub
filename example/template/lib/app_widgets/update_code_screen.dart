import 'dart:convert';
import 'package:protobuf/protobuf.dart';
import 'package:template/app_widgets/app_submit_button.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:template/app_blocs/app_replay_bloc.dart';


class UpdateCodeScreen extends StatefulWidget {
  const UpdateCodeScreen({
    super.key,
    required this.event,
    required this.siteId,
  });

  final String event;
  final String siteId;

  @override
  State<UpdateCodeScreen> createState() => _UpdateCodeScreenState();
}

class _UpdateCodeScreenState extends State<UpdateCodeScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final submitEvent = SubmitAppEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    if (!submitEvent.appEvent.hasUpdateCode()) {
      submitEvent.appEvent.updateCode = AppEvent_UpdateCode();
    }

    return BlocProvider<AppSubmitBloc>(
      create: (_) => AppSubmitBloc(widget.siteId, submitEvent),
      child: Form(
        key: _formKey,
        child: BlocConsumer<AppSubmitBloc, BaseSubmitState<SubmitAppEvent>>(
          builder: (context, submitState) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Update Code"),
                actions: [AppSubmitIconButton(formKey: _formKey)],
              ),
              body: CommonSubmitFormLayout<SubmitAppEvent>(
                submitState: submitState,
                children: [
                  CodeFormFieldWidget(
                    formKey: _formKey,
                    labelText: "Code Value",
                  ),
                ],
              ),
            );
          },
          listener: (context, state) {
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

class CodeFormFieldWidget
    extends
        BaseCodeFormField<AppSubmitBloc, AppEventSubmission, SubmitAppEvent> {
  const CodeFormFieldWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: appEventSubmissionFactory);

  @override
  String getValueFromPayload(SubmitAppEvent payload) {
    return payload.appEvent.updateCode.value;
  }

  @override
  SubmitAppEvent updatePayload(
    SubmitAppEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.appEvent.updateCode.value = newValue;
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, String value) => null;
}
