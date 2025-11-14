import 'package:hyttahub/preferences_cubits/login_cubit.dart';
import 'package:hyttahub/auth_bloc/auth_submit_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/service_widgets/login.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/auth_bloc.pb.dart';
import 'package:hyttahub/proto/service_replay_bloc.pb.dart';
import 'package:hyttahub/account_widgets/auth_submit_button.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:protobuf/protobuf.dart';

class EmailSignupForm extends StatefulWidget {
  const EmailSignupForm({
    super.key,
    required this.serviceLogin,
    required this.serviceState,
    required this.emailValidator,
  });

  final bool serviceLogin;
  final ServiceReplayBlocState serviceState;
  final String? Function(String, BuildContext, ServiceReplayBlocState)
  emailValidator;

  @override
  State<EmailSignupForm> createState() => _EmailSignupFormState();
}

class _EmailSignupFormState extends State<EmailSignupForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final localizations = HyttaHubLocalizations.of(context)!;
    final createAccountCubit = context.read<CreateAccountCubit>();
    final initialEvent = AuthBlocEvent(
      emailSignup: AuthBlocEvent_EmailSignup(
        serviceAdmin: widget.serviceLogin,
        termsVersion: 0, // to be confirmed by user
        privacyVersion: 0, // to be confirmed by user
      ),
    );

    return BlocProvider<AuthSubmitBloc>(
      create: (_) => AuthSubmitBloc('', initialEvent)..isFormValid = false,
      child: BlocBuilder<AuthSubmitBloc, BaseSubmitState<AuthBlocEvent>>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.serviceLogin
                    ? localizations.serviceCreateAccountTitle
                    : localizations.createAccountTitle,
              ),
              actions: [AuthSubmitIconButton(formKey: _formKey)],
            ),
            body: Form(
              key: _formKey,
              child: CommonSubmitFormLayout<AuthBlocEvent>(
                // spacing: 10.0,
                submitState: state,
                children: [
                  EmailFormField(
                    formKey: _formKey,
                    labelText: localizations.loginEmailLabel,
                    emailValidator: widget.emailValidator,
                    serviceState: widget.serviceState,
                  ),
                  PasswordFormFieldWrapper(
                    formKey: _formKey,
                    labelText: localizations.loginPasswordLabel,
                    helperText: localizations.loginPasswordHelperText,
                  ),

                  _TermsCheckbox(
                    formKey: _formKey,
                    labelText: localizations.loginAgreeToTermsCheckbox,
                    serviceState: widget.serviceState,
                  ),

                  _PrivacyCheckbox(
                    formKey: _formKey,
                    labelText: localizations.loginAgreeToPrivacyPolicyCheckbox,
                    serviceState: widget.serviceState,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => context.push(
                          CreateAccountTermsDisplayRoute.fullPath,
                        ),
                        child: Text(localizations.viewTerms),
                      ),
                      Text(localizations.and),
                      TextButton(
                        onPressed: () => context.push(
                          CreateAccountPrivacyDisplayRoute.fullPath,
                        ),
                        child: Text(localizations.viewPrivacyPolicy),
                      ),
                    ],
                  ),
                  TextButton(
                    child: Text(localizations.loginAlreadyHaveAccountButton),
                    onPressed: () {
                      createAccountCubit.setCreateAccount(false);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TermsCheckbox
    extends
        BaseCheckboxFormField<
          AuthSubmitBloc,
          AuthEventSubmission,
          AuthBlocEvent
        > {
  final ServiceReplayBlocState serviceState;

  const _TermsCheckbox({
    required super.formKey,
    required this.serviceState,
    required super.labelText,
  }) : super(
         key: const Key('terms-checkbox'),
         eventFactory: authEventSubmissionFactory,
       );

  @override
  bool getValueFromPayload(AuthBlocEvent payload) {
    return payload.emailSignup.termsVersion == serviceState.termsVersion;
  }

  @override
  AuthBlocEvent updatePayload(AuthBlocEvent originalPayload, bool newValue) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.emailSignup.termsVersion = newValue
        ? serviceState.termsVersion
        : 0;
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, bool value) =>
      !value ? HyttaHubLocalizations.of(context)!.mustAgreeToTermsError : null;
}

class _PrivacyCheckbox
    extends
        BaseCheckboxFormField<
          AuthSubmitBloc,
          AuthEventSubmission,
          AuthBlocEvent
        > {
  final ServiceReplayBlocState serviceState;

  const _PrivacyCheckbox({
    required super.formKey,
    required this.serviceState,
    required super.labelText,
  }) : super(
         key: const Key('privacy-checkbox'),
         eventFactory: authEventSubmissionFactory,
       );

  @override
  bool getValueFromPayload(AuthBlocEvent payload) {
    return payload.emailSignup.privacyVersion == serviceState.privacyVersion;
  }

  @override
  AuthBlocEvent updatePayload(AuthBlocEvent originalPayload, bool newValue) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.emailSignup.privacyVersion = newValue
        ? serviceState.privacyVersion
        : 0;
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, bool value) => !value
      ? HyttaHubLocalizations.of(context)!.mustAgreeToPrivacyPolicyError
      : null;
}
