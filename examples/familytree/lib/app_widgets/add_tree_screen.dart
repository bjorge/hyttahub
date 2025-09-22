// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:familytree/app_blocs/app_submit_bloc.dart';
import 'package:familytree/app_widgets/app_submit_button.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:familytree/l10n/intl_localizations.dart';
import 'package:familytree/proto/app_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';

class AddTreeScreen extends StatefulWidget {
  const AddTreeScreen({super.key, required this.event, required this.siteId});

  final String event;
  final String siteId;

  @override
  State<AddTreeScreen> createState() => _AddTreeScreenState();
}

class _AddTreeScreenState extends State<AddTreeScreen> {
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
                title: Text(AppLocalizations.of(context)!.app_createTreeTitle),
                actions: [AppSubmitIconButton(formKey: _formKey)],
              ),
              body: CommonSubmitFormLayout<SubmitAppEvent>(
                submitState: submitState,
                children: [
                  AlbumNameInputWidget(
                    formKey: _formKey,
                    labelText: AppLocalizations.of(context)!.app_treeNameLabel,
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

class AlbumNameInputWidget
    extends
        BaseTextFormField<AppSubmitBloc, AppEventSubmission, SubmitAppEvent> {
  const AlbumNameInputWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: appEventSubmissionFactory);

  @override
  String? validator(BuildContext context, String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.app_treeNameEmptyError;
    }
    return null;
  }

  @override
  String getValueFromPayload(SubmitAppEvent payload) {
    return payload.appEvent.addTree.name;
  }

  @override
  SubmitAppEvent updatePayload(
    SubmitAppEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.appEvent = originalPayload.appEvent.deepCopy();
    updatedPayload.appEvent.addTree.name = newValue;
    return updatedPayload;
  }
}
