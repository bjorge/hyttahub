// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/account_blocs/account_submit_bloc.dart';
import 'package:hyttahub/account_widgets/account_submit_button.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/proto/account_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';

class JoinSiteScreen extends StatefulWidget {
  const JoinSiteScreen({super.key, required this.event});

  final String event;

  @override
  State<JoinSiteScreen> createState() => _JoinSiteScreenState();
}

class _JoinSiteScreenState extends State<JoinSiteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeFormFieldKey =
      GlobalKey<
        BaseCodeFormFieldState<
          AccountSubmitBloc,
          AccountEventSubmission,
          SubmitAccountEvent
        >
      >();

  @override
  Widget build(BuildContext context) {
    final userEmail = context.read<AuthBloc>().state.email;

    final submitEvent = SubmitAccountEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    return BlocProvider(
      create: (_) => AccountSubmitBloc(userEmail, submitEvent),
      child: Form(
        key: _formKey,
        child:
            BlocConsumer<
              AccountSubmitBloc,
              BaseSubmitState<SubmitAccountEvent>
            >(
              builder: (context, submitState) {
                final readOnly =
                    !(submitState.submissionState.state ==
                            CommonSubmitBlocState_State.ready ||
                        submitState.submissionState.state ==
                            CommonSubmitBlocState_State.canSubmit);
                final code = submitState.payload!.event.joinSite;

                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      HyttaHubLocalizations.of(context)!.joinSiteTitle,
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.content_paste),
                        tooltip: HyttaHubLocalizations.of(
                          context,
                        )!.pasteCodeTooltip,
                        onPressed: readOnly
                            ? null
                            : () async {
                                final data = await Clipboard.getData(
                                  Clipboard.kTextPlain,
                                );
                                if (data?.text != null) {
                                  _codeFormFieldKey.currentState?.paste(
                                    data!.text!,
                                  );
                                }
                              },
                      ),
                      IconButton(
                        icon: const Icon(Icons.backspace_outlined),
                        tooltip: HyttaHubLocalizations.of(
                          context,
                        )!.backspaceTooltip,
                        onPressed: readOnly || code.isEmpty
                            ? null
                            : () => _codeFormFieldKey.currentState?.backspace(),
                      ),
                      AccountSubmitIconButton(formKey: _formKey),
                    ],
                  ),
                  body: CommonSubmitFormLayout<SubmitAccountEvent>(
                    submitState: submitState,
                    children: [
                      JoinSiteCodeInputWidget(
                        key: _codeFormFieldKey,
                        formKey: _formKey,
                        labelText: HyttaHubLocalizations.of(
                          context,
                        )!.joinSiteCodeLabel,
                      ),
                    ],
                  ),
                );
              },
              listener:
                  (
                    BuildContext context,
                    BaseSubmitState<SubmitAccountEvent> state,
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

class JoinSiteCodeInputWidget
    extends
        BaseCodeFormField<
          AccountSubmitBloc,
          AccountEventSubmission,
          SubmitAccountEvent
        > {
  const JoinSiteCodeInputWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: accountEventSubmissionFactory);

  @override
  String getValueFromPayload(SubmitAccountEvent payload) {
    return payload.event.joinSite;
  }

  @override
  SubmitAccountEvent updatePayload(
    SubmitAccountEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.event.joinSite = newValue;
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, String value) {
    if (value.isEmpty) {
      return HyttaHubLocalizations.of(context)!.siteCodeEmptyError;
    }
    if (value.length != 8) {
      return HyttaHubLocalizations.of(context)!.siteCodeLengthError;
    }
    return null;
  }
}
