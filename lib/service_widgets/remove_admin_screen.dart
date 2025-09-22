// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/service_events.pb.dart';
import 'package:hyttahub/service_blocs/service_submit_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/service_widgets/service_submit_button.dart';

class RemoveServiceAdminScreen extends StatefulWidget {
  const RemoveServiceAdminScreen({super.key, required this.event});

  final String event;

  @override
  State<RemoveServiceAdminScreen> createState() =>
      _RemoveServiceAdminScreenState();
}

class _RemoveServiceAdminScreenState extends State<RemoveServiceAdminScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final submitEvent = SubmitServiceEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    return BlocProvider(
      create: (_) => ServiceSubmitBloc(submitEvent)
        ..isFormValid = false
        ..payloadChanged = true,
      child: Form(
        key: _formKey,
        child:
            BlocConsumer<
              ServiceSubmitBloc,
              BaseSubmitState<SubmitServiceEvent>
            >(
              builder: (context, submitState) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      HyttaHubLocalizations.of(context)!.removeAdminTitle,
                    ),
                    actions: [ServiceSubmitIconButton(formKey: _formKey)],
                  ),
                  body: CommonSubmitFormLayout<SubmitServiceEvent>(
                    submitState: submitState,
                    children: [
                      RemoveAdminCheckboxWidget(
                        formKey: _formKey,
                        labelText: HyttaHubLocalizations.of(
                          context,
                        )!.removeAdminConfirmation,
                      ),
                    ],
                  ),
                );
              },
              listener:
                  (
                    BuildContext context,
                    BaseSubmitState<SubmitServiceEvent> state,
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

class RemoveAdminCheckboxWidget
    extends
        BaseConfirmationCheckbox<
          ServiceSubmitBloc,
          ServiceEventSubmission,
          SubmitServiceEvent
        > {
  const RemoveAdminCheckboxWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: serviceEventSubmissionFactory);
}
