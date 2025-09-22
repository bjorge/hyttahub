// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/site_blocs/site_submit_bloc.dart';
import 'package:hyttahub/site_widgets/site_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';

class RenameSiteScreen extends StatefulWidget {
  const RenameSiteScreen({
    super.key,
    required this.event,
    required this.siteId,
  });

  final String event;
  final String siteId;

  @override
  State<RenameSiteScreen> createState() => _RenameSiteScreenState();
}

class _RenameSiteScreenState extends State<RenameSiteScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final submitEvent = SubmitSiteEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    return BlocProvider(
      create: (_) => SiteSubmitBloc(widget.siteId, submitEvent),
      child: Form(
        key: _formKey,
        child: BlocConsumer<SiteSubmitBloc, BaseSubmitState<SubmitSiteEvent>>(
          builder: (context, submitState) {
            return Scaffold(
              appBar: AppBar(
                title: Text(HyttaHubLocalizations.of(context)!.renameSiteTitle),
                actions: [SiteSubmitIconButton(formKey: _formKey)],
              ),
              body: _buildBody(context, submitState),
            );
          },
          listener:
              (BuildContext context, BaseSubmitState<SubmitSiteEvent> state) {
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
    BaseSubmitState<SubmitSiteEvent> submitState,
  ) {
    return CommonSubmitFormLayout<SubmitSiteEvent>(
      submitState: submitState,
      children: [
        RenameSiteInputWidget(
          formKey: _formKey,
          labelText: HyttaHubLocalizations.of(context)!.newSiteNameLabel,
        ),
      ],
    );
  }
}

class RenameSiteInputWidget
    extends
        BaseTextFormField<
          SiteSubmitBloc,
          SiteEventSubmission,
          SubmitSiteEvent
        > {
  const RenameSiteInputWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: siteEventSubmissionFactory);

  @override
  String? validator(BuildContext context, String value) {
    if (value.isEmpty) {
      return HyttaHubLocalizations.of(context)!.siteNameEmptyError;
    }
    return null;
  }

  @override
  String getValueFromPayload(SubmitSiteEvent payload) {
    return payload.event.updateSiteName.name;
  }

  @override
  SubmitSiteEvent updatePayload(
    SubmitSiteEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.event.updateSiteName.name = newValue;
    return updatedPayload;
  }
}
