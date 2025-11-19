// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formjson/app_blocs/app_submit_bloc.dart';
import 'package:formjson/app_widgets/app_submit_button.dart';
import 'package:formjson/models/app_events.dart';
import 'package:hyttahub/common_blocs/base_submit_dart_bloc.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';

class SiteScreenForm extends StatefulWidget {
  const SiteScreenForm({super.key, required this.event, required this.siteId});

  final String event;
  final String siteId;

  @override
  State<SiteScreenForm> createState() => _SiteScreenFormState();
}

class _SiteScreenFormState extends State<SiteScreenForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final submitEvent = SubmitAppEvent.fromJson(
      jsonDecode(
        utf8.decode(
          base64Url.decode(widget.event),
        ),
      ),
    );

    return BlocProvider(
      create: (_) => AppSubmitBloc(widget.siteId, submitEvent),
      child: Form(
        key: _formKey,
        child:
            BlocConsumer<AppSubmitBloc, BaseSubmitDartState<SubmitAppEvent>>(
          builder: (context, submitState) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Update Text Value"),
                actions: [AppSubmitIconButton(formKey: _formKey)],
              ),
              body: _buildBody(context, submitState),
            );
          },
          listener: (
            BuildContext context,
            BaseSubmitDartState<SubmitAppEvent> state,
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

  Widget _buildBody(
    BuildContext context,
    BaseSubmitDartState<SubmitAppEvent> submitState,
  ) {
    return CommonSubmitFormLayout<SubmitAppEvent>(
      submitState: submitState,
      children: [
        TextValueInputWidget(formKey: _formKey, labelText: "Text Value"),
      ],
    );
  }
}

class TextValueInputWidget extends BaseTextFormField<AppSubmitBloc,
    AppEventSubmission, SubmitAppEvent> {
  const TextValueInputWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: appEventSubmissionFactory);

  @override
  String? validator(BuildContext context, String value) {
    return null;
  }

  @override
  String getValueFromPayload(SubmitAppEvent payload) {
    return payload.appEvent?.when(
          updateText: (text) => text ?? '',
        ) ??
        '';
  }

  @override
  SubmitAppEvent updatePayload(
    SubmitAppEvent originalPayload,
    String newValue,
  ) {
    return originalPayload.copyWith(
      appEvent: AppEvent.updateText(text: newValue),
    );
  }
}
