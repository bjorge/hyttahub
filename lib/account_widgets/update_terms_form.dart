// Copyright (c) 2025 bjorge

import 'package:hyttahub/account_blocs/account_replay_bloc.dart';
import 'package:hyttahub/account_blocs/account_submit_bloc.dart';
import 'package:hyttahub/account_widgets/account_submit_button.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/common_widgets/layout.dart';
import 'package:hyttahub/proto/account_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/service_replay_bloc.pb.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/service_blocs/service_replay_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:protobuf/protobuf.dart';

class UpdateTermsWidget extends StatefulWidget {
  const UpdateTermsWidget({super.key});

  @override
  State<UpdateTermsWidget> createState() => _UpdateTermsWidget();
}

class _UpdateTermsWidget extends State<UpdateTermsWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final accountState = context.read<AccountReplayBloc>().state;
    final accountEvent = SubmitAccountEvent(
      event: AccountEvent(
        version: accountState.events.isEmpty
            ? 1
            : accountState.events.keys.fold<int>(1, (p, e) => e > p ? e : p) +
                  1,
        terms: AccountEvent_Terms(termsVersion: 0, policyVersion: 0),
      ),
    );

    return BlocProvider(
      create: (_) => AccountSubmitBloc(
        GetIt.instance<AuthBloc>().state.email,
        accountEvent,
      ),
      child: Form(
        key: _formKey,
        child: BlocConsumer<AccountSubmitBloc, BaseSubmitState<SubmitAccountEvent>>(
          listener: (BuildContext context, BaseSubmitState<SubmitAccountEvent> state) {
            // if (state.submissionState.state ==
            //     CommonSubmitBlocState_State.success) {
            //   // When submission is successful, set a flag.
            //   // The AccountReplayBloc in the parent will eventually get the update
            //   // and rebuild the AccountScreen, which will remove this widget.
            //   setState(() {
            //     _isSubmitted = true;
            //   });
            // }

            if (state.submissionState.state ==
                CommonSubmitBlocState_State.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                commonSnackBar(
                  context,
                  Text(HyttaHubLocalizations.of(context)!.errorSubmittingForm),
                ),
              );
            }
          },
          builder: (context, submitState) {
            // if (_isSubmitted) {
            //   // While waiting for the parent to rebuild, show a loading indicator.
            //   return Scaffold(
            //     appBar: AppBar(title: const Text('Updating Terms...')),
            //     body: const Center(child: CircularProgressIndicator()),
            //   );
            // }
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  HyttaHubLocalizations.of(context)!.updateTermsTitle,
                ),

                actions: [AccountSubmitIconButton(formKey: _formKey)],
              ),
              body: _buildBody(context, submitState),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    BaseSubmitState<SubmitAccountEvent> submitState,
  ) {
    // final payload = _fromEncodedBuffer(submitState.submissionState.payload);
    final serviceState = context.read<ServiceReplayBloc>().state;

    return CommonListViewLayout(
      spacing: 10.0,
      children: [
        _TermsCheckbox(
          formKey: _formKey,
          serviceState: serviceState,
          labelText: HyttaHubLocalizations.of(context)!.agreeToTerms,
        ),
        _PrivacyCheckbox(
          formKey: _formKey,
          serviceState: serviceState,
          labelText: HyttaHubLocalizations.of(context)!.agreeToPrivacyPolicy,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                context.push(TermsDisplayRoute.fullPath);
              },
              child: Text(HyttaHubLocalizations.of(context)!.viewTerms),
            ),
            Text(HyttaHubLocalizations.of(context)!.and),
            TextButton(
              onPressed: () {
                context.push(PrivacyDisplayRoute.fullPath);
              },
              child: Text(HyttaHubLocalizations.of(context)!.viewPrivacyPolicy),
            ),
          ],
        ),
      ],
    );
  }
}

AccountEventSubmission _eventFactory({
  required SubmitAccountEvent? updatedPayload,
  required CommonSubmitBlocEvent submission,
  required ServiceReplayBlocState serviceState,
}) {
  final isValid =
      updatedPayload!.event.terms.termsVersion == serviceState.termsVersion &&
      updatedPayload.event.terms.policyVersion == serviceState.privacyVersion;

  return AccountEventSubmission(
    updatedPayload: updatedPayload,
    submission: CommonSubmitBlocEvent(isFormValid: isValid),
  );
}

class _TermsCheckbox
    extends
        BaseCheckboxFormField<
          AccountSubmitBloc,
          AccountEventSubmission,
          SubmitAccountEvent
        > {
  final ServiceReplayBlocState serviceState;

  _TermsCheckbox({
    required super.formKey,
    required this.serviceState,
    required super.labelText,
  }) : super(
         key: const Key('terms-checkbox'),
         eventFactory: ({updatedPayload, required submission}) => _eventFactory(
           updatedPayload: updatedPayload,
           submission: submission,
           serviceState: serviceState,
         ),
       );

  @override
  bool getValueFromPayload(SubmitAccountEvent payload) {
    return payload.event.terms.termsVersion == serviceState.termsVersion;
  }

  @override
  SubmitAccountEvent updatePayload(
    SubmitAccountEvent originalPayload,
    bool newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.event.terms.termsVersion = newValue
        ? serviceState.termsVersion
        : 0;
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, bool value) => !value
      ? HyttaHubLocalizations.of(context)!.mustAgreeToTermsError
      : null;
}

class _PrivacyCheckbox
    extends
        BaseCheckboxFormField<
          AccountSubmitBloc,
          AccountEventSubmission,
          SubmitAccountEvent
        > {
  final ServiceReplayBlocState serviceState;

  _PrivacyCheckbox({
    required super.formKey,
    required this.serviceState,
    required super.labelText,
  }) : super(
         key: const Key('privacy-checkbox'),
         eventFactory: ({updatedPayload, required submission}) => _eventFactory(
           updatedPayload: updatedPayload,
           submission: submission,
           serviceState: serviceState,
         ),
       );

  @override
  bool getValueFromPayload(SubmitAccountEvent payload) {
    return payload.event.terms.policyVersion == serviceState.privacyVersion;
  }

  @override
  SubmitAccountEvent updatePayload(
    SubmitAccountEvent originalPayload,
    bool newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.event.terms.policyVersion = newValue
        ? serviceState.privacyVersion
        : 0;
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, bool value) => !value
      ? HyttaHubLocalizations.of(context)!.mustAgreeToPrivacyPolicyError
      : null;
}
