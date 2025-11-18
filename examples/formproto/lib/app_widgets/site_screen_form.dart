// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:formproto/app_blocs/app_submit_bloc.dart';
import 'package:formproto/app_widgets/app_submit_button.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:formproto/proto/app_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';
import 'package:hyttahub/common_widgets/common_form.dart';

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
    final submitEvent = SubmitAppEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    return BlocProvider(
      create: (_) => AppSubmitBloc(widget.siteId, submitEvent),

      child: Form(
        key: _formKey,
        child: BlocConsumer<AppSubmitBloc, BaseSubmitState<SubmitAppEvent>>(
          builder: (context, submitState) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Update Text Value"),
                actions: [AppSubmitIconButton(formKey: _formKey)],
              ),
              body: _buildBody(context, submitState),
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

  Widget _buildBody(
    BuildContext context,
    BaseSubmitState<SubmitAppEvent> submitState,
  ) {
    return CommonSubmitFormLayout<SubmitAppEvent>(
      submitState: submitState,
      children: [
        TextValueInputWidget(formKey: _formKey, labelText: "Text Value"),
      ],
    );
  }
}

class TextValueInputWidget
    extends
        BaseTextFormField<AppSubmitBloc, AppEventSubmission, SubmitAppEvent> {
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
    return payload.appEvent.updateText.text;
  }

  @override
  SubmitAppEvent updatePayload(
    SubmitAppEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.appEvent.updateText.text = newValue;
    return updatedPayload;
  }
}
