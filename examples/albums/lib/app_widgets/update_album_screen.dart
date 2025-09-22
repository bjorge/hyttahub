// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:albums/l10n/app_localizations.dart';
import 'package:albums/app_blocs/app_submit_bloc.dart';
import 'package:albums/app_widgets/app_submit_button.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:albums/proto/app_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';
import 'package:hyttahub/common_widgets/common_form.dart';

class UpdateAlbumScreen extends StatefulWidget {
  const UpdateAlbumScreen({
    super.key,
    required this.event,
    required this.siteId,
    required this.albumId,
  });

  final String event;
  final String siteId;
  final int albumId;

  @override
  State<UpdateAlbumScreen> createState() => _UpdateAlbumScreenState();
}

class _UpdateAlbumScreenState extends State<UpdateAlbumScreen> {
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
                title: Text(AppLocalizations.of(context)!.app_renameAlbumTitle),
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
        UpdateAlbumInputWidget(
          formKey: _formKey,
          labelText: AppLocalizations.of(context)!.app_newAlbumNameLabel,
        ),
      ],
    );
  }
}

class UpdateAlbumInputWidget
    extends
        BaseTextFormField<
          AppSubmitBloc,
          AppEventSubmission,
          SubmitAppEvent
        > {
  const UpdateAlbumInputWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: appEventSubmissionFactory);

  @override
  String? validator(BuildContext context, String value) {
    if (value.isEmpty) return AppLocalizations.of(context)!.app_albumNameEmptyError;
    return null;
  }

  @override
  String getValueFromPayload(SubmitAppEvent payload) {
    return payload.appEvent.updateAlbum.name;
  }

  @override
  SubmitAppEvent updatePayload(
    SubmitAppEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.appEvent.updateAlbum.name = newValue;
    return updatedPayload;
  }
}
