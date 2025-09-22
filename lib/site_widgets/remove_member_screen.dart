// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/site_blocs/site_submit_bloc.dart';
import 'package:hyttahub/site_widgets/site_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemoveMemberScreen extends StatefulWidget {
  const RemoveMemberScreen({
    super.key,
    required this.event,
    required this.siteId,
  });

  final String event;
  final String siteId;

  @override
  State<RemoveMemberScreen> createState() => _RemoveMemberScreenState();
}

class _RemoveMemberScreenState extends State<RemoveMemberScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final submitEvent = SubmitSiteEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    return BlocProvider(
      create: (_) => SiteSubmitBloc(widget.siteId, submitEvent)
        ..isFormValid = false
        ..payloadChanged = true,
      child: Form(
        key: _formKey,
        child: BlocConsumer<SiteSubmitBloc, BaseSubmitState<SubmitSiteEvent>>(
          builder: (context, submitState) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  HyttaHubLocalizations.of(context)!.removeMemberTitle,
                ),
                actions: [SiteSubmitIconButton(formKey: _formKey)],
              ),
              body: CommonSubmitFormLayout<SubmitSiteEvent>(
                submitState: submitState,
                children: [
                  RemoveMemberCheckboxWidget(
                    formKey: _formKey,
                    labelText: HyttaHubLocalizations.of(
                      context,
                    )!.removeMemberConfirmation,
                  ),
                ],
              ),
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
}

class RemoveMemberCheckboxWidget
    extends
        BaseConfirmationCheckbox<
          SiteSubmitBloc,
          SiteEventSubmission,
          SubmitSiteEvent
        > {
  const RemoveMemberCheckboxWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: siteEventSubmissionFactory);
}
