import 'dart:convert';
import 'package:protobuf/protobuf.dart';
import 'package:template/app_blocs/app_submit_bloc.dart';
import 'package:template/app_widgets/app_submit_button.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:template/proto/app_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/common_widgets/common_form.dart';

class UpdateCheckboxScreen extends StatefulWidget {
  const UpdateCheckboxScreen({
    super.key,
    required this.event,
    required this.siteId,
  });

  final String event;
  final String siteId;

  @override
  State<UpdateCheckboxScreen> createState() => _UpdateCheckboxScreenState();
}

class _UpdateCheckboxScreenState extends State<UpdateCheckboxScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final submitEvent = SubmitAppEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    if (!submitEvent.appEvent.hasUpdateCheckbox()) {
      submitEvent.appEvent.updateCheckbox = AppEvent_UpdateCheckbox();
    }

    return BlocProvider(
      create: (_) => AppSubmitBloc(widget.siteId, submitEvent),
      child: Form(
        key: _formKey,
        child: BlocConsumer<AppSubmitBloc, BaseSubmitState<SubmitAppEvent>>(
          builder: (context, submitState) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Update Checkbox"),
                actions: [AppSubmitIconButton(formKey: _formKey)],
              ),
              body: CommonSubmitFormLayout<SubmitAppEvent>(
                submitState: submitState,
                children: [
                  CheckboxFormFieldWidget(
                    formKey: _formKey,
                    labelText: "Checkbox Value",
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

class CheckboxFormFieldWidget
    extends
        BaseCheckboxFormField<
          AppSubmitBloc,
          AppEventSubmission,
          SubmitAppEvent
        > {
  const CheckboxFormFieldWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: appEventSubmissionFactory);

  @override
  bool getValueFromPayload(SubmitAppEvent payload) {
    return payload.appEvent.updateCheckbox.value;
  }

  @override
  SubmitAppEvent updatePayload(SubmitAppEvent originalPayload, bool newValue) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.appEvent.updateCheckbox.value = newValue;
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, bool value) => null;
}
