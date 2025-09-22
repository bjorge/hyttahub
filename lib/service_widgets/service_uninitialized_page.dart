// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/utilities/bloom_filter.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/common_widgets/layout.dart';
import 'package:hyttahub/proto/bloom_filter.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/service_events.pb.dart';
import 'package:hyttahub/service_blocs/service_submit_bloc.dart';
import 'package:hyttahub/service_widgets/service_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';

class ServiceUninitializedPage extends StatefulWidget {
  const ServiceUninitializedPage({super.key, required this.event});

  final String event;

  @override
  State<ServiceUninitializedPage> createState() =>
      _ServiceUninitializedPageState1();
}

class _ServiceUninitializedPageState1 extends State<ServiceUninitializedPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final submitEvent = SubmitServiceEvent.fromBuffer(
      base64Decode(widget.event),
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
                    title: Text(localizations.uninitializedErrorTitle),
                    actions: [ServiceSubmitIconButton(formKey: _formKey)],
                  ),
                  body: _buildBody(context, submitState),
                );
              },
              listener:
                  (
                    BuildContext context,
                    BaseSubmitState<SubmitServiceEvent> state,
                  ) {},
            ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    BaseSubmitState<SubmitServiceEvent> submitState,
  ) {
    switch (submitState.submissionState.state) {
      case CommonSubmitBlocState_State.error:
        return Center(
          child: Text(
            HyttaHubLocalizations.of(context)!.errorTodo,
            style: const TextStyle(color: Colors.red),
          ),
        );
      case CommonSubmitBlocState_State.submitting:
        return const Center(child: CircularProgressIndicator());
      default:
        // Continue with the form UI
        break;
    }

    return CommonListViewLayout(
      spacing: 10.0,
      children: [
        Text(HyttaHubLocalizations.of(context)!.initializeFirebaseEmulator),
        if (submitState.submissionState.state ==
            CommonSubmitBlocState_State.success)
          Text(HyttaHubLocalizations.of(context)!.successfullySubmittedTodo),
        _EmailField(
          formKey: _formKey,
          labelText: HyttaHubLocalizations.of(context)!.loginEmailLabel,
        ),
        AliasFormField(
          formKey: _formKey,
          labelText: HyttaHubLocalizations.of(context)!.aliasLabel,
        ),
      ],
    );
  }
}

class _EmailField
    extends
        BaseTextFormField<
          ServiceSubmitBloc,
          ServiceEventSubmission,
          SubmitServiceEvent
        > {
  const _EmailField({required super.formKey, required super.labelText})
    : super(eventFactory: ServiceEventSubmission.new);

  @override
  String getValueFromPayload(SubmitServiceEvent payload) {
    return payload.email;
  }

  @override
  SubmitServiceEvent updatePayload(
    SubmitServiceEvent originalPayload,
    String newValue,
  ) {
    final value = newValue;
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.email = value;

    // update the bloom with the single email
    if (updatedPayload.email.isEmpty) {
      updatedPayload.event.initialEvent.filter = BloomFilter();
    } else {
      final bloom = BloomFilterProcessor(
        size: defaultBloomFilterSize,
        hashCount: defaultBloomFilterHashCount,
      )..add(updatedPayload.email);

      updatedPayload.event.initialEvent.filter = BloomFilter()
        ..size = bloom.size
        ..hashCount = bloom.hashCount
        ..bitArray = bloom.bitArray;
    }
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, String value) {
    final generalEmailError = emailValidator(value, context);
    if (generalEmailError != null) {
      return generalEmailError;
    }

    return null;
  }
}

class AliasFormField
    extends
        BaseTextFormField<
          ServiceSubmitBloc,
          ServiceEventSubmission,
          SubmitServiceEvent
        > {
  const AliasFormField({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: ServiceEventSubmission.new);

  @override
  String getValueFromPayload(SubmitServiceEvent payload) {
    return payload.event.initialEvent.alias;
  }

  @override
  SubmitServiceEvent updatePayload(
    SubmitServiceEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.event.initialEvent.alias = newValue;
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, String value) {
    if (value.isEmpty) {
      return HyttaHubLocalizations.of(context)!.nicknameEmptyError;
    }
    return null;
  }
}
