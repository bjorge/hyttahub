// Copyright (c) 2025 bjorge

import 'dart:async';
import 'package:hyttahub/service_blocs/service_submit_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/preferences_cubits/login_cubit.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
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
import 'package:hyttahub/service_blocs/service_replay_bloc.dart';
import 'package:hyttahub/service_widgets/service_network_error_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  /// Constructs a [LoginScreen]
  const LoginScreen({super.key, required this.serviceLogin});

  final bool serviceLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isNavigating = false;
  String? _blockedEmail;

  FutureOr<bool> _onPreSubmit(
    AuthBlocEvent event,
    ServiceReplayBlocState serviceState,
  ) {
    final versionMismatch = !widget.serviceLogin &&
        serviceState.state == CommonReplayStateEnum.listening &&
        serviceState.minVersion >
            (HyttaHubOptions.implementation?.appBuildNumber ?? 0);
    final serviceUnavailable = !widget.serviceLogin &&
        serviceState.state == CommonReplayStateEnum.listening &&
        serviceState.serviceUnavailable == true;

    if (versionMismatch || serviceUnavailable) {
      final email = event.hasEmailLogin()
          ? event.emailLogin.email
          : event.emailSignup.email;
      setState(() {
        _blockedEmail = email;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = HyttaHubLocalizations.of(context)!;

    return BlocConsumer<ServiceReplayBloc, ServiceReplayBlocState>(
      listener: (context, serviceState) {
        if (serviceState.state == CommonReplayStateEnum.listening) {
          final authState = context.read<AuthBloc>().state;
          if (authState.authState == AuthState.authenticated) {
            _handleAuthenticatedNavigation(
              context,
              authState,
              serviceState,
            );
          }
        }
      },
      builder: (context, serviceState) {
        if (serviceState.state == CommonReplayStateEnum.hydrating) {
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

        if (serviceState.state == CommonReplayStateEnum.networkError) {
          return ServiceNetworkErrorPage();
        }

        final authState = context.watch<AuthBloc>().state;

        final versionMismatch = !widget.serviceLogin &&
            serviceState.state == CommonReplayStateEnum.listening &&
            serviceState.minVersion >
                (HyttaHubOptions.implementation?.appBuildNumber ?? 0);
        final serviceUnavailable = !widget.serviceLogin &&
            serviceState.state == CommonReplayStateEnum.listening &&
            serviceState.serviceUnavailable == true;

        if (versionMismatch || serviceUnavailable) {
          final emailToCheck =
              authState.authState == AuthState.authenticated
                  ? authState.email
                  : _blockedEmail;

          bool isBlocked = authState.authState == AuthState.authenticated || _blockedEmail != null;
          if (emailToCheck != null) {
            final reconstructed = BloomFilterProcessor(
              size: serviceState.filter.size,
              hashCount: serviceState.filter.hashCount,
              bitArray: Uint8List.fromList(serviceState.filter.bitArray),
            );
            if (reconstructed.mightContain(emailToCheck)) {
              isBlocked = false;
            }
          }

          if (isBlocked) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                if (versionMismatch) {
                  context.go(ServiceNewVersionRoute.fullPath);
                } else {
                  context.go(ServiceDownRoute.fullPath);
                }
              }
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        }

        final isUninitialized =
            serviceState.state == CommonReplayStateEnum.uninitializedListening;

        return MultiBlocProvider(
          providers: [
            BlocProvider<CreateAccountCubit>(
              create: (_) => CreateAccountCubit(),
            ),
            if (isUninitialized &&
                authState.authState == AuthState.authenticated)
              BlocProvider<ServiceSubmitBloc>(
                create: (context) {
                  final bloom = BloomFilterProcessor(
                    size: defaultBloomFilterSize,
                    hashCount: defaultBloomFilterHashCount,
                  )..add(authState.email);

                  final submitServiceEvent = SubmitServiceEvent(
                    email: authState.email,
                    event: ServiceEvent(
                      version: 1,
                      author: 1,
                      initialEvent: ServiceEvent_InitialEvent(
                        instance: generateId(),
                        alias: 'Admin',
                        filter:
                            BloomFilter()
                              ..size = bloom.size
                              ..hashCount = bloom.hashCount
                              ..bitArray = bloom.bitArray,
                        appName:
                            HyttaHubOptions
                                .implementation
                                ?.firebaseRootCollection ??
                            '',
                        appId: HyttaHubOptions.implementation?.appId ?? '',
                      ),
                    ),
                  );
                  return ServiceSubmitBloc(submitServiceEvent)
                    ..isFormValid = true
                    ..add(
                      ServiceEventSubmission(
                        submission: CommonSubmitBlocEvent(
                          submit: CommonSubmitBlocEvent_SubmitNow(),
                        ),
                      ),
                    );
                },
              ),
          ],
          child: BlocBuilder<CreateAccountCubit, bool>(
            builder: (context, createAccount) {
              final authConsumer = BlocConsumer<AuthBloc, AuthBlocState>(
                listener: (context, authState) {
                  if (authState.authState == AuthState.authenticated) {
                    _handleAuthenticatedNavigation(
                      context,
                      authState,
                      serviceState,
                    );
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
                    context.read<CreateAccountCubit>().setCreateAccount(false);
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
                  if (authState.authState == AuthState.loginSuccess) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(localizations.loginSuccessTitle),
                      ),
                      body: const Center(
                        child: CommonListViewLayout(
                          spacing: 10.0,
                          children: <Widget>[
                            Center(child: CircularProgressIndicator()),
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
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(
                          isUninitialized &&
                                  authState.authState == AuthState.authenticated
                              ? localizations.initializingAccountTitle
                              : localizations.loadingTitle,
                        ),
                      ),
                      body: const Center(
                        child: CommonListViewLayout(
                          spacing: 10.0,
                          children: <Widget>[
                            Center(child: CircularProgressIndicator()),
                          ],
                        ),
                      ),
                    );
                  }

                  final showSignup = createAccount && !widget.serviceLogin;

                  return showSignup
                      ? EmailSignupForm(
                        serviceLogin: widget.serviceLogin,
                        serviceState: serviceState,
                        emailValidator: emailError,
                        onPreSubmit: (event) => _onPreSubmit(event, serviceState),
                      )
                      : EmailLoginForm(
                        serviceLogin: widget.serviceLogin,
                        serviceState: serviceState,
                        emailValidator: emailError,
                        onPreSubmit: (event) => _onPreSubmit(event, serviceState),
                      );
                },
              );

              if (isUninitialized &&
                  authState.authState == AuthState.authenticated) {
                return BlocListener<ServiceSubmitBloc,
                    BaseSubmitState<SubmitServiceEvent>>(
                  listener: (context, serviceSubmitState) {
                    if (serviceSubmitState.submissionState.state ==
                        CommonSubmitBlocState_State.success) {
                      // Initialization successful!
                    }
                  },
                  child: authConsumer,
                );
              }

              return authConsumer;
            },
          ),
        );
      },
    );
  }

  void _handleAuthenticatedNavigation(
    BuildContext context,
    AuthBlocState authState,
    ServiceReplayBlocState serviceState,
  ) {
    if (serviceState.state != CommonReplayStateEnum.listening || _isNavigating) {
      return;
    }
    final router = GoRouter.of(context);
    final localizations = HyttaHubLocalizations.of(context)!;

    _isNavigating = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      try {
        final versionMismatch = !widget.serviceLogin &&
            serviceState.minVersion >
                (HyttaHubOptions.implementation?.appBuildNumber ?? 0);
        final serviceDown =
            !widget.serviceLogin && serviceState.serviceUnavailable == true;
        final isBlocked = versionMismatch || serviceDown;

        if (authState.isServiceAdmin) {
          if (isBlocked) {
            final result = await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text(localizations.serviceAdminDetectionTitle),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (versionMismatch)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              localizations.serviceAdminVersionWarning(
                                HyttaHubOptions.implementation?.appBuildNumber ??
                                    0,
                                serviceState.minVersion,
                              ),
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (serviceDown)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              localizations.serviceDownMessage,
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        Text(localizations.serviceAdminDetectionMessage),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(localizations.goUserAccountButton),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(localizations.goServiceSettingsButton),
                      ),
                    ],
                  ),
            );

            if (mounted && result == true) {
              await router.push(ServiceAdminScreenRoute.fullPath);
              return;
            }
            // If they chose User Account but it's blocked, they will see the block page after this
          } else {
            await router.push(ServiceAdminScreenRoute.fullPath);
            return;
          }
        }

        final reconstructed = BloomFilterProcessor(
          size: serviceState.filter.size,
          hashCount: serviceState.filter.hashCount,
          bitArray: Uint8List.fromList(serviceState.filter.bitArray),
        );

        final mightBeAdmin = reconstructed.mightContain(authState.email);

        if (mightBeAdmin) {
          // In the new flow, the builder handles showing the block page with a "Service Login" button
          // so we don't need to show a dialog here if we are blocked.
          if (!isBlocked) {
            if (!context.mounted) return;
            final result = await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text(localizations.serviceAdminDetectionTitle),
                    content: Text(localizations.serviceAdminDetectionMessage),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(localizations.goUserAccountButton),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(localizations.goServiceSettingsButton),
                      ),
                    ],
                  ),
            );

            if (mounted && result == true) {
              await router.push(ServiceAdminScreenRoute.fullPath);
              return;
            }
          }
        }

        if (mounted) {
          if (isBlocked && !authState.isServiceAdmin) {
            if (versionMismatch) {
              router.go(ServiceNewVersionRoute.fullPath);
            } else {
              router.go(ServiceDownRoute.fullPath);
            }
          } else {
            await router.push(AccountScreenRoute.fullPath);
          }
        }
      } finally {
        _isNavigating = false;
      }
    });
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

