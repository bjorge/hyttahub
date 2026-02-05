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

class UpdateTextScreen extends StatefulWidget {
  const UpdateTextScreen({
    super.key,
    required this.event,
    required this.siteId,
  });

  final String event;
  final String siteId;

  @override
  State<UpdateTextScreen> createState() => _UpdateTextScreenState();
}

class _UpdateTextScreenState extends State<UpdateTextScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final submitEvent = SubmitAppEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    if (!submitEvent.appEvent.hasUpdateText()) {
      submitEvent.appEvent.updateText = AppEvent_UpdateText();
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<AppReplayBloc>(
          create: (_) => AppReplayBloc(widget.siteId)..add(CommonReplayBlocEvent(listen: true)),
        ),
        BlocProvider<AppSubmitBloc>(
          create: (_) => AppSubmitBloc(widget.siteId, submitEvent),
        ),
      ],
      child: Form(
        key: _formKey,
        child: BlocConsumer<AppSubmitBloc, BaseSubmitState<SubmitAppEvent>>(
          builder: (context, submitState) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Update Text"),
                actions: [AppSubmitIconButton(formKey: _formKey)],
              ),
              body: CommonSubmitFormLayout<SubmitAppEvent>(
                submitState: submitState,
                children: [
                  TextFormFieldWidget(
                    formKey: _formKey,
                    labelText: "Text Value",
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

class TextFormFieldWidget
    extends
        BaseTextFormField<AppSubmitBloc, AppEventSubmission, SubmitAppEvent> {
  const TextFormFieldWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: appEventSubmissionFactory);

  @override
  String? validator(BuildContext context, String value) => null;

  @override
  String getValueFromPayload(SubmitAppEvent payload) {
    return payload.appEvent.updateText.value;
  }

  @override
  SubmitAppEvent updatePayload(
    SubmitAppEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.appEvent.updateText.value = newValue;
    return updatedPayload;
  }
}
