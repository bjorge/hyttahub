// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:familytree/app_blocs/app_submit_bloc.dart';
import 'package:familytree/app_widgets/app_submit_button.dart';
import 'package:familytree/l10n/intl_localizations.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:familytree/proto/app_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';
import 'package:hyttahub/common_widgets/common_form.dart';

class UpdateTreeScreen extends StatefulWidget {
  const UpdateTreeScreen({
    super.key,
    required this.event,
    required this.siteId,
    required this.treeId,
  });

  final String event;
  final String siteId;
  final int treeId;

  @override
  State<UpdateTreeScreen> createState() => _UpdateTreeScreenState();
}

class _UpdateTreeScreenState extends State<UpdateTreeScreen> {
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
            final l10n = AppLocalizations.of(context)!;
            return Scaffold(
              appBar: AppBar(
                title: Text(l10n.app_renameTreeTitle),
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
    final l10n = AppLocalizations.of(context)!;
    return CommonSubmitFormLayout<SubmitAppEvent>(
      submitState: submitState,
      children: [
        RenameTreeInputWidget(
          formKey: _formKey,
          labelText: l10n.app_newTreeNameLabel,
        ),
      ],
    );
  }
}

class RenameTreeInputWidget
    extends
        BaseTextFormField<AppSubmitBloc, AppEventSubmission, SubmitAppEvent> {
  const RenameTreeInputWidget({
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
    return payload.appEvent.updateTree.name;
  }

  @override
  SubmitAppEvent updatePayload(
    SubmitAppEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.appEvent.updateTree.name = newValue;
    return updatedPayload;
  }
}
