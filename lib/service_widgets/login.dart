// Copyright (c) 2025 bjorge

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
import 'package:hyttahub/service_widgets/service_down_page.dart';
import 'package:hyttahub/service_widgets/service_new_version_page.dart';
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
              localizations,
            );
          }
        }
        if (!widget.serviceLogin &&
            serviceState.state == CommonReplayStateEnum.listening &&
            serviceState.serviceUnavailable == true) {
          // logout and then rebuild the navigation stack
          context.read<AuthBloc>().add(
            AuthBlocEvent(logout: AuthBlocEvent_Logout()),
          );

          context.goNamed(LoginScreenRoute.routeName);
          return;
        }

        if (!widget.serviceLogin &&
            serviceState.state == CommonReplayStateEnum.listening &&
            serviceState.minVersion >
                (HyttaHubOptions.implementation?.appBuildNumber ?? 0)) {
          // logout and then rebuild the navigation stack
          context.read<AuthBloc>().add(
            AuthBlocEvent(logout: AuthBlocEvent_Logout()),
          );

          context.goNamed(LoginScreenRoute.routeName);
          return;
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

        if (!widget.serviceLogin &&
            serviceState.state == CommonReplayStateEnum.listening &&
            serviceState.serviceUnavailable == true) {
          return ServiceDownPage();
        }

        if (!widget.serviceLogin &&
            serviceState.state == CommonReplayStateEnum.listening &&
            serviceState.minVersion > (HyttaHubOptions.implementation?.appBuildNumber ?? 0)) {
          return ServiceNewVersionPage();
        }

        final authState = context.watch<AuthBloc>().state;
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
                      localizations,
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

                  return createAccount
                      ? EmailSignupForm(
                        serviceLogin: widget.serviceLogin,
                        serviceState: serviceState,
                        emailValidator: emailError,
                      )
                      : EmailLoginForm(
                        serviceLogin: widget.serviceLogin,
                        serviceState: serviceState,
                        emailValidator: emailError,
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
    HyttaHubLocalizations localizations,
  ) {
    if (serviceState.state != CommonReplayStateEnum.listening || _isNavigating) {
      return;
    }
    _isNavigating = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      try {
        if (authState.isServiceAdmin) {
          await context.push(ServiceAdminScreenRoute.fullPath);
        } else {
          final reconstructed = BloomFilterProcessor(
            size: serviceState.filter.size,
            hashCount: serviceState.filter.hashCount,
            bitArray: Uint8List.fromList(serviceState.filter.bitArray),
          );

          final router = GoRouter.of(context);
          if (reconstructed.mightContain(authState.email)) {
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
          if (mounted) {
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

