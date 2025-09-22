import 'package:hyttahub/preferences_cubits/login_cubit.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/auth_bloc/auth_submit_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/service_widgets/login.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/auth_bloc.pb.dart';
import 'package:hyttahub/proto/service_replay_bloc.pb.dart';
import 'package:hyttahub/account_widgets/auth_submit_button.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailLoginForm extends StatefulWidget {
  const EmailLoginForm({
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
  State<EmailLoginForm> createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends State<EmailLoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = HyttaHubLocalizations.of(context)!;
    final createAccountCubit = context.read<CreateAccountCubit>();
    final initialEvent = AuthBlocEvent(
      emailLogin: AuthBlocEvent_EmailLogin(serviceAdmin: widget.serviceLogin),
    );

    return BlocProvider<AuthSubmitBloc>(
      create: (_) => AuthSubmitBloc('', initialEvent),
      child: BlocBuilder<AuthSubmitBloc, BaseSubmitState<AuthBlocEvent>>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.serviceLogin
                    ? localizations.serviceLoginTitle
                    : localizations.loginTitle,
              ),
              actions: [AuthSubmitIconButton(formKey: _formKey)],
            ),
            body: Form(
              key: _formKey,
              child: CommonSubmitFormLayout<AuthBlocEvent>(
                // spacing: 10.0,
                submitState: state,
                children: [
                  Center(child: Text(localizations.loginWelcomeMessage)),
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
                  if (!widget.serviceLogin)
                    TextButton(
                      child: Text(localizations.loginNeedToCreateAccountButton),
                      onPressed: () {
                        createAccountCubit.setCreateAccount(true);
                      },
                    ),
                  if (!widget.serviceLogin)
                    TextButton(
                      onPressed:
                          widget.emailValidator(
                                context
                                    .read<AuthSubmitBloc>()
                                    .state
                                    .payload!
                                    .emailLogin
                                    .email,
                                context,
                                widget.serviceState,
                              ) ==
                              null
                          ? () {
                              context.read<AuthBloc>().add(
                                AuthBlocEvent(
                                  emailForgotPassword:
                                      AuthBlocEvent_EmailForgotPassword(
                                        email: context
                                            .read<AuthSubmitBloc>()
                                            .state
                                            .payload!
                                            .emailLogin
                                            .email,
                                      ),
                                ),
                              );
                            }
                          : null,
                      child: Text(localizations.loginForgotPasswordButton),
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
