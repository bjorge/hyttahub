// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/proto/bloom_filter.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/service_events.pb.dart';
import 'package:hyttahub/service_blocs/service_submit_bloc.dart';
import 'package:hyttahub/service_widgets/service_submit_button.dart';
import 'package:hyttahub/utilities/bloom_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';

class ServiceSettingsForm extends StatefulWidget {
  const ServiceSettingsForm({super.key, required this.event});

  final String event;

  @override
  State<ServiceSettingsForm> createState() => _ServiceSettingsFormState();
}

class _ServiceSettingsFormState extends State<ServiceSettingsForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final submitEvent = SubmitServiceEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    return BlocProvider(
      create: (_) => ServiceSubmitBloc(submitEvent),
      child: Form(
        key: _formKey,
        child:
            BlocConsumer<
              ServiceSubmitBloc,
              BaseSubmitState<SubmitServiceEvent>
            >(
              builder: (context, submitState) {
                final localizations = HyttaHubLocalizations.of(context)!;
                return Scaffold(
                  appBar: AppBar(
                    title: Text(localizations.serviceSettingsTitle),

                    actions: [ServiceSubmitIconButton(formKey: _formKey)],
                  ),
                  body: CommonSubmitFormLayout<SubmitServiceEvent>(
                    submitState: submitState,
                    children: [
                      // Center(child: Text(localizations.serviceSettingsTitle)),
                      if (submitEvent.event.hasServiceStatus())
                        ServiceUnavailableFormField(
                          formKey: _formKey,
                          labelText: localizations.serviceUnavailableLabel,
                        ),
                      if (submitEvent.event.hasMinVersion())
                        MinVersionFormField(
                          formKey: _formKey,
                          labelText: localizations.minVersionLabel,
                        ),
                      if (submitEvent.hasBetaUsers())
                        BetaUsersFormField(
                          formKey: _formKey,
                          labelText: localizations.betaUserEmailsLabel,
                        ),
                      if (submitEvent.event.hasTerms())
                        TermsWidget(
                          formKey: _formKey,
                          labelText: localizations.termsOfServiceContentLabel,
                        ),
                      if (submitEvent.event.hasPrivacy())
                        PrivacyWidget(
                          formKey: _formKey,
                          labelText: localizations.privacyPolicyContentLabel,
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

class TermsWidget
    extends
        BaseTextFormField<
          ServiceSubmitBloc,
          ServiceEventSubmission,
          SubmitServiceEvent
        > {
  const TermsWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: ServiceEventSubmission.new, maxLines: null);

  @override
  String getValueFromPayload(SubmitServiceEvent payload) {
    return payload.event.terms.content;
  }

  @override
  SubmitServiceEvent updatePayload(
    SubmitServiceEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.event.terms.content = newValue;
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, String value) {
    final localizations = HyttaHubLocalizations.of(context)!;
    if (value.isEmpty) {
      return localizations.termsOfServiceContentEmptyError;
    }
    if (value.length < 10) {
      return localizations.contentTooShortError;
    }
    return null;
  }
}

class PrivacyWidget
    extends
        BaseTextFormField<
          ServiceSubmitBloc,
          ServiceEventSubmission,
          SubmitServiceEvent
        > {
  const PrivacyWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: ServiceEventSubmission.new, maxLines: null);

  @override
  String getValueFromPayload(SubmitServiceEvent payload) {
    return payload.event.privacy.content;
  }

  @override
  SubmitServiceEvent updatePayload(
    SubmitServiceEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.event.privacy.content = newValue;
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, String value) {
    final localizations = HyttaHubLocalizations.of(context)!;
    if (value.isEmpty) {
      return localizations.privacyPolicyContentEmptyError;
    }
    if (value.length < 10) {
      return localizations.contentTooShortError;
    }
    return null;
  }
}

class ServiceUnavailableFormField
    extends
        BaseCheckboxFormField<
          ServiceSubmitBloc,
          ServiceEventSubmission,
          SubmitServiceEvent
        > {
  const ServiceUnavailableFormField({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: ServiceEventSubmission.new);

  @override
  bool getValueFromPayload(SubmitServiceEvent payload) {
    return payload.event.serviceStatus.unavailable;
  }

  @override
  SubmitServiceEvent updatePayload(
    SubmitServiceEvent originalPayload,
    bool newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.event.serviceStatus.unavailable = newValue;
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, bool value) {
    return null; // checked or unchecked is valid
  }
}

class MinVersionFormField
    extends
        BaseTextFormField<
          ServiceSubmitBloc,
          ServiceEventSubmission,
          SubmitServiceEvent
        > {
  const MinVersionFormField({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: ServiceEventSubmission.new);

  @override
  String getValueFromPayload(SubmitServiceEvent payload) {
    return payload.event.minVersion.value.toString();
  }

  @override
  SubmitServiceEvent updatePayload(
    SubmitServiceEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.event.minVersion.value = int.tryParse(newValue) ?? 0;
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, String value) {
    final localizations = HyttaHubLocalizations.of(context)!;
    if (value.isEmpty) {
      return localizations.versionNumberEmptyError;
    }
    final version = int.tryParse(value);
    if (version == null || version <= 0) {
      return localizations.versionNumberInvalidError;
    }
    return null;
  }
}

class BetaUsersFormField
    extends
        BaseTextFormField<
          ServiceSubmitBloc,
          ServiceEventSubmission,
          SubmitServiceEvent
        > {
  const BetaUsersFormField({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: ServiceEventSubmission.new);

  @override
  String getValueFromPayload(SubmitServiceEvent payload) {
    return payload.betaUsers;
  }

  @override
  SubmitServiceEvent updatePayload(
    SubmitServiceEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.event = originalPayload.event.deepCopy();

    if (newValue.isEmpty) {
      updatedPayload.betaUsers = '';
      updatedPayload.event.betaUsersFilter.clear();
    } else {
      final emails = newValue
          .toLowerCase()
          .split(',')
          .map((e) => e.trim())
          .toList();
      updatedPayload.betaUsers = emails.join(',');

      final bloom = BloomFilterProcessor(
        size: defaultBloomFilterSize,
        hashCount: defaultBloomFilterHashCount,
      )..addAll(emails);

      updatedPayload.event.betaUsersFilter = BloomFilter()
        ..size = bloom.size
        ..hashCount = bloom.hashCount
        ..bitArray = bloom.bitArray;
    }

    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, String value) {
    return null;
  }
}
