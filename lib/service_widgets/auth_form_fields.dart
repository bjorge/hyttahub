// Copyright (c) 2025 bjorge

import 'package:flutter/material.dart';
import 'package:hyttahub/auth_bloc/auth_submit_bloc.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/auth_bloc.pb.dart';
import 'package:hyttahub/proto/service_replay_bloc.pb.dart';
import 'package:protobuf/protobuf.dart';

class EmailFormField
    extends
        BaseTextFormField<AuthSubmitBloc, AuthEventSubmission, AuthBlocEvent> {
  const EmailFormField({
    super.key,
    required super.formKey,
    required super.labelText,
    required this.emailValidator,
    required this.serviceState,
  }) : super(eventFactory: authEventSubmissionFactory);

  final String? Function(String, BuildContext, ServiceReplayBlocState)
  emailValidator;
  final ServiceReplayBlocState serviceState;

  @override
  String getValueFromPayload(AuthBlocEvent payload) {
    if (payload.hasEmailLogin()) {
      return payload.emailLogin.email;
    }
    return payload.emailSignup.email;
  }

  @override
  AuthBlocEvent updatePayload(AuthBlocEvent originalPayload, String newValue) {
    if (originalPayload.hasEmailLogin()) {
      final copy = originalPayload.deepCopy();
      copy.emailLogin.email = newValue;
      return copy;
    } else {
      final copy = originalPayload.deepCopy();
      copy.emailSignup.email = newValue;
      return copy;
    }
  }

  @override
  String? validator(BuildContext context, String value) {
    return emailValidator(value, context, serviceState);
  }
}

class PasswordFormFieldWrapper extends StatefulWidget {
  const PasswordFormFieldWrapper({
    super.key,
    required this.formKey,
    required this.labelText,
    this.helperText,
  });

  final GlobalKey<FormState> formKey;
  final String labelText;
  final String? helperText;

  @override
  State<PasswordFormFieldWrapper> createState() =>
      _PasswordFormFieldWrapperState();
}

class _PasswordFormFieldWrapperState extends State<PasswordFormFieldWrapper> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return _PasswordFormField(
      formKey: widget.formKey,
      labelText: widget.labelText,
      helperText: widget.helperText,
      obscureText: _hidePassword,
      suffixIcon: IconButton(
        icon: _hidePassword
            ? const Icon(Icons.visibility_off)
            : const Icon(Icons.visibility),
        onPressed: () {
          setState(() {
            _hidePassword = !_hidePassword;
          });
        },
      ),
    );
  }
}

class _PasswordFormField
    extends
        BaseTextFormField<AuthSubmitBloc, AuthEventSubmission, AuthBlocEvent> {
  const _PasswordFormField({
    required super.formKey,
    required super.labelText,
    required bool obscureText,
    required Widget suffixIcon,
    this.helperText,
  }) : super(
         eventFactory: authEventSubmissionFactory,
         obscureText: obscureText,
         suffixIcon: suffixIcon,
       );

  final String? helperText;

  @override
  String getValueFromPayload(AuthBlocEvent payload) {
    if (payload.hasEmailLogin()) {
      return payload.emailLogin.password;
    }
    return payload.emailSignup.password;
  }

  @override
  AuthBlocEvent updatePayload(AuthBlocEvent originalPayload, String newValue) {
    if (originalPayload.hasEmailLogin()) {
      final copy = originalPayload.deepCopy();
      copy.emailLogin.password = newValue;
      return copy;
    } else {
      final copy = originalPayload.deepCopy();
      copy.emailSignup.password = newValue;
      return copy;
    }
  }

  @override
  String? validator(BuildContext context, String value) {
    final localizations = HyttaHubLocalizations.of(context)!;
    if (value.isEmpty) {
      return localizations.passwordEmptyError;
    }
    if (value.length < 16) {
      return localizations.passwordTooShortError;
    }
    if (value.length > 128) {
      return localizations.passwordTooLongError;
    }
    return null;
  }
}
