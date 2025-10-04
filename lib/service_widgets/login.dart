// Copyright (c) 2025 bjorge

import 'dart:convert';
import 'dart:typed_data';

import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/preferences_cubits/login_cubit.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/auth_bloc/auth_submit_bloc.dart';
import 'package:hyttahub/service_widgets/email_login_form.dart';
import 'package:hyttahub/service_widgets/email_signup_form.dart';
import 'package:hyttahub/utilities/bloom_filter.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/utilities/ids.dart';
import 'package:hyttahub/common_widgets/layout.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/auth_bloc.pb.dart';
import 'package:hyttahub/proto/bloom_filter.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/service_events.pb.dart';
import 'package:hyttahub/proto/service_replay_bloc.pb.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/service_widgets/service_down_page.dart';
import 'package:hyttahub/service_widgets/service_new_version_page.dart';
import 'package:hyttahub/service_blocs/service_replay_bloc.dart';
import 'package:hyttahub/service_widgets/service_network_error_page.dart';
import 'package:hyttahub/service_widgets/service_uninitialized_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:protobuf/protobuf.dart';

class LoginScreen extends StatefulWidget {
  /// Constructs a [LoginScreen]
  const LoginScreen({super.key, required this.serviceLogin});

  final bool serviceLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = HyttaHubLocalizations.of(context)!;
    final createAccountCubit = context.read<CreateAccountCubit>();

    return BlocConsumer<ServiceReplayBloc, ServiceReplayBlocState>(
      listener: (context, serviceState) {
        if (!widget.serviceLogin &&
            serviceState.state == CommonReplayStateEnum.ok &&
            serviceState.serviceUnavailable == true) {
          // logout and then rebuild the navigation stack
          context.read<AuthBloc>().add(
            AuthBlocEvent(logout: AuthBlocEvent_Logout()),
          );

          context.goNamed(LoginScreenRoute.routeName);
        }

        if (!widget.serviceLogin &&
            serviceState.state == CommonReplayStateEnum.ok &&
            serviceState.minVersion > HyttaHubOptions.appBuildNumber!) {
          // logout and then rebuild the navigation stack
          context.read<AuthBloc>().add(
            AuthBlocEvent(logout: AuthBlocEvent_Logout()),
          );

          context.goNamed(LoginScreenRoute.routeName);
        }
      },
      builder: (context, serviceState) {
        if (!serviceState.hasState() ||
            serviceState.state == CommonReplayStateEnum.fetchingConfig) {
          return Scaffold(
            appBar: AppBar(title: Text(localizations.loadingTitle)),
            body: Center(
              child: CommonListViewLayout(
                spacing: 10.0,
                children: <Widget>[
                  Center(child: const CircularProgressIndicator()),
                ],
              ),
            ),
          );
        }

        if (serviceState.state == CommonReplayStateEnum.uninitialized) {
          final submitServiceEvent = SubmitServiceEvent(
            email: '',
            event: ServiceEvent(
              version: 1,
              author: 1,
              initialEvent: ServiceEvent_InitialEvent(
                instance: generateId(), // a good enough random value
                alias: '',
                filter: BloomFilter(),
              ),
            ),
          );

          final encodedEvent = base64Encode(submitServiceEvent.writeToBuffer());

          return ServiceUninitializedPage(event: encodedEvent);
        }

        if (serviceState.state == CommonReplayStateEnum.networkError) {
          return ServiceNetworkErrorPage();
        }

        if (!widget.serviceLogin &&
            serviceState.state == CommonReplayStateEnum.ok &&
            serviceState.serviceUnavailable == true) {
          return ServiceDownPage();
        }

        if (!widget.serviceLogin &&
            serviceState.state == CommonReplayStateEnum.ok &&
            serviceState.minVersion > HyttaHubOptions.appBuildNumber!) {
          return ServiceNewVersionPage();
        }

        return BlocBuilder<CreateAccountCubit, bool>(
          builder: (context, createAccount) {
            return BlocConsumer<AuthBloc, AuthBlocState>(
              listener: (context, authState) {
                if (authState.authState == AuthState.authenticated &&
                    serviceState.state == CommonReplayStateEnum.ok) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // Ensure the widget is still in the tree
                    if (mounted) {
                      if (authState.isServiceAdmin) {
                        context.push(ServiceAdminScreenRoute.fullPath);
                      } else {
                        context.push(AccountScreenRoute.fullPath);
                      }
                    }
                  });
                } else if (authState.authState ==
                    AuthState.forgottenPasswordEmailSent) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    commonSnackBar(
                      context,
                      Text(localizations.loginGoToEmailResetPasswordMessage),
                      durationSeconds: 20,
                    ),
                  );
                } else if (authState.authState ==
                    AuthState.emailVerificationSent) {
                  createAccountCubit.setCreateAccount(false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    commonSnackBar(
                      context,
                      Text(localizations.loginGoToEmailVerifyEmailMessage),
                      durationSeconds: 20,
                    ),
                  );
                } else if (authState.authState ==
                    AuthState.authenticationError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    commonSnackBar(
                      context,
                      Text(
                        localizations.authenticationErrorWithDetails(
                          authState.errorMessage,
                        ),
                      ),
                      durationSeconds: 15,
                    ),
                  );
                }
              },
              builder: (BuildContext context, AuthBlocState authState) {
                // Handle the new loginSuccess state to show an intermediate UI
                if (authState.authState == AuthState.loginSuccess) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(
                        HyttaHubLocalizations.of(context)!.loginSuccessTitle,
                      ),
                    ),
                    body: Center(
                      child: CommonListViewLayout(
                        spacing: 10.0,
                        children: <Widget>[
                          Center(child: const CircularProgressIndicator()),
                        ],
                      ),
                    ),
                  );
                }

                if (authState.authState != AuthState.unauthenticated &&
                    authState.authState !=
                        AuthState.forgottenPasswordEmailSent &&
                    authState.authState != AuthState.emailVerificationSent &&
                    authState.authState != AuthState.authenticationError) {
                  // Covers .authenticated (before navigation), .unknown, .authenticationError (which also shows a snackbar)
                  // This will be shown briefly for .authenticated before the listener navigates.

                  return Scaffold(
                    appBar: AppBar(title: Text(localizations.loadingTitle)),
                    body: Center(
                      child: CommonListViewLayout(
                        spacing: 10.0,
                        children: <Widget>[
                          Center(child: const CircularProgressIndicator()),
                        ],
                      ),
                    ),
                  );
                } else {
                  return BlocBuilder<CreateAccountCubit, bool>(
                    builder: (context, createAccount) {
                      if (createAccount) {
                        return EmailSignupForm(
                          serviceLogin: widget.serviceLogin,
                          serviceState: serviceState,
                          emailValidator: emailError,
                        );
                      } else {
                        return EmailLoginForm(
                          serviceLogin: widget.serviceLogin,
                          serviceState: serviceState,
                          emailValidator: emailError,
                        );
                      }
                    },
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  String? emailError(
    String elementValue,
    BuildContext context,
    ServiceReplayBlocState serviceState,
  ) {
    final value = elementValue;

    final generalEmailError = emailValidator(value, context);
    if (generalEmailError != null) {
      return generalEmailError;
    }
    final localizations = HyttaHubLocalizations.of(context)!;

    if (widget.serviceLogin) {
      final reconstructed = BloomFilterProcessor(
        size: serviceState.filter.size,
        hashCount: serviceState.filter.hashCount,
        bitArray: Uint8List.fromList(serviceState.filter.bitArray),
      );

      final mightBeSuperUser = reconstructed.mightContain(value);

      if (!mightBeSuperUser) {
        return localizations.loginNotServiceAdminError;
      }
    } else if (serviceState.hasBetaUsersFilter()) {
      final reconstructed = BloomFilterProcessor(
        size: serviceState.betaUsersFilter.size,
        hashCount: serviceState.betaUsersFilter.hashCount,
        bitArray: Uint8List.fromList(serviceState.betaUsersFilter.bitArray),
      );

      final mightBeBetaUser = reconstructed.mightContain(value);

      if (!mightBeBetaUser) {
        return localizations.loginNotBetaUserError;
      }
    }

    // mightBeSuperUser

    return null;
  }
}

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
