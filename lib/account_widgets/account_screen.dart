// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/account_blocs/account_replay_bloc.dart';
import 'package:hyttahub/account_blocs/account_submit_bloc.dart';
import 'package:hyttahub/account_widgets/update_terms_form.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/utilities/ids.dart';
import 'package:hyttahub/common_widgets/layout.dart';
import 'package:hyttahub/proto/account_events.pb.dart';
import 'package:hyttahub/proto/account_replay_bloc.pb.dart';
import 'package:hyttahub/proto/auth_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/service_replay_bloc.pb.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/service_blocs/service_replay_bloc.dart';
import 'package:hyttahub/site_widgets/site_edit_mode_cubit.dart';
import 'package:hyttahub/site_widgets/site_name_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AccountReplayBloc>(
          key: Key('AccountScreenBlocProvider'),
          create: (_) =>
              AccountReplayBloc(GetIt.instance<AuthBloc>().state.email)
                ..add(CommonReplayBlocEvent(listen: true)),
        ),
      ],
      child: BlocConsumer<AccountReplayBloc, AccountReplayBlocState>(
        builder: (context, accountState) {
          // first check if the account state is initialized
          if (!accountState.hasState() ||
              accountState.state == CommonReplayStateEnum.fetchingConfig) {
            return Center(child: CircularProgressIndicator());
          } else if (accountState.state ==
              CommonReplayStateEnum.uninitialized) {
            return AccountInitializingWidget(
              email: GetIt.instance<AuthBloc>().state.email,
            );
          }
          return BlocConsumer<ServiceReplayBloc, ServiceReplayBlocState>(
            builder: (context, serviceState) {
              // next check if terms or privacy policy need to be accepted

              if (accountState.termsVersion < serviceState.termsVersion ||
                  accountState.privacyVersion < serviceState.privacyVersion) {
                return UpdateTermsWidget();
              }

              return Scaffold(
                appBar: AppBar(
                  title: Text(HyttaHubLocalizations.of(context)!.sites),
                  automaticallyImplyLeading:
                      false, // Hides the back button, use the logout option instead
                  actions: [AccountSettingsButton()],
                ),
                body: CommonListViewLayout(
                  children: accountState.sitesIds.isEmpty
                      ? [
                          Center(
                            child: Text(
                              HyttaHubLocalizations.of(context)!.noSites,
                            ),
                          ),
                        ]
                      : accountState.sitesIds
                            .map(
                              (siteId) => TextButton(
                                key: Key(siteId),
                                onPressed: () {
                                  // turn off edit mode by default before entering site screen
                                  context
                                      .read<SiteEditModeCubit>()
                                      .editModeClear();

                                  context.push(
                                    '${AccountScreenRoute.fullPath}/site/$siteId',
                                  );
                                },
                                child: SiteNameDisplay(collectionName: siteId),
                              ),
                            )
                            .toList(),
                ),
              );
            },
            listener:
                (BuildContext context, ServiceReplayBlocState serviceState) {
                  if (accountState.termsVersion < serviceState.termsVersion ||
                      accountState.privacyVersion <
                          serviceState.privacyVersion) {
                    context.goNamed(AccountScreenRoute.routeName);
                  }
                },
          );
        },
        listener:
            (BuildContext context, AccountReplayBlocState accountState) {},
      ),
    );
  }
}

class AccountInitializingWidget extends StatefulWidget {
  const AccountInitializingWidget({super.key, required this.email});

  final String email;

  @override
  State<AccountInitializingWidget> createState() =>
      _AccountInitializingWidgetState();
}

class _AccountInitializingWidgetState extends State<AccountInitializingWidget> {
  @override
  Widget build(BuildContext context) {
    final serviceState = context.read<ServiceReplayBloc>().state;
    final accountEvent = SubmitAccountEvent(
      event: AccountEvent(
        version: 1,
        initialEvent: AccountEvent_InitialEvent(
          terms: AccountEvent_Terms(
            termsVersion: serviceState.termsVersion,
            policyVersion: serviceState.privacyVersion,
          ),
          instance:
              generateId(), // generate a unique instance id for this account
        ),
      ),
    );

    return BlocProvider(
      create: (_) => AccountSubmitBloc(widget.email, accountEvent)
        ..add(
          AccountEventSubmission(
            updatedPayload: accountEvent,
            submission: CommonSubmitBlocEvent(isFormValid: true),
          ),
        )
        ..add(
          AccountEventSubmission(
            submission: CommonSubmitBlocEvent(
              submit: CommonSubmitBlocEvent_SubmitNow(),
            ),
          ),
        ),

      child:
          BlocConsumer<AccountSubmitBloc, BaseSubmitState<SubmitAccountEvent>>(
            builder: (context, submitState) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    HyttaHubLocalizations.of(context)!.initializingAccountTitle,
                  ),
                ),
                body: Center(child: CircularProgressIndicator()),
              );
            },
            listener:
                (
                  BuildContext context,
                  BaseSubmitState<SubmitAccountEvent> state,
                ) {},
          ),
    );
  }
}

class AccountSettingsButton extends StatelessWidget {
  const AccountSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final accountState = context.watch<AccountReplayBloc>().state;

    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return SimpleDialog(
              title: Text(
                HyttaHubLocalizations.of(context)!.accountSettingsTitle,
              ),
              children: <Widget>[
                CreateSiteDialogOption(accountState: accountState),
                JoinSiteDialogOption(accountState: accountState),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push(ManageSitesRoute.fullPath);
                  },
                  child: Text(
                    HyttaHubLocalizations.of(context)!.manageSitesTitle,
                  ),
                ),
                Divider(),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(dialogContext); // pop the SimpleDialog

                    if (accountState.sitesIds.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext alertContext) {
                          return AlertDialog(
                            title: Text(
                              HyttaHubLocalizations.of(
                                context,
                              )!.cannotRemoveAccountTitle,
                            ),
                            content: Text(
                              HyttaHubLocalizations.of(
                                context,
                              )!.cannotRemoveAccountContent,
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  HyttaHubLocalizations.of(context)!.okButton,
                                ),
                                onPressed: () {
                                  Navigator.of(
                                    alertContext,
                                  ).pop(); // Dismiss the alert
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      final submitValue = AuthBlocEvent(
                        removeAccount: AuthBlocEvent_RemoveAccount(),
                      );
                      final encodedSubmitValue = base64UrlEncode(
                        submitValue.writeToBuffer(),
                      );
                      context.push(
                        '${RemoveAccountRoute.fullPath}?event=$encodedSubmitValue',
                      );
                    }
                  },
                  child: Text(
                    HyttaHubLocalizations.of(context)!.removeAccountTitle,
                  ),
                ),
                Divider(),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push(AccountEventsDisplayRoute.fullPath);
                  },
                  child: Text(
                    HyttaHubLocalizations.of(context)!.showAccountEventsState,
                  ),
                ),
                Divider(),
                SimpleDialogOption(
                  onPressed: () {
                    // pop the dialog
                    Navigator.pop(context);
                    // pop the account screen
                    Navigator.pop(context);

                    // logout
                    context.read<AuthBloc>().add(
                      AuthBlocEvent(logout: AuthBlocEvent_Logout()),
                    );
                  },
                  child: Text(HyttaHubLocalizations.of(context)!.logout),
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(Icons.manage_accounts),
    );
  }
}

class CreateSiteDialogOption extends StatelessWidget {
  const CreateSiteDialogOption({super.key, required this.accountState});

  final AccountReplayBlocState accountState;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context);
        final submmitValue = SubmitAccountEvent(
          createSiteName: '',
          createSiteUserName: '',
          event: AccountEvent(
            createSite: generateId(),
            version: accountState.events.isEmpty
                ? 1
                : accountState.events.keys.fold<int>(
                        1,
                        (p, e) => e > p ? e : p,
                      ) +
                      1,
          ),
        );

        final encodedSubmitValue = base64UrlEncode(
          submmitValue.writeToBuffer(),
        );

        context.push('${AddSiteRoute.fullPath}?event=$encodedSubmitValue');
      },
      child: Text(HyttaHubLocalizations.of(context)!.createSiteTitle),
    );
  }
}

class JoinSiteDialogOption extends StatelessWidget {
  const JoinSiteDialogOption({super.key, required this.accountState});

  final AccountReplayBlocState accountState;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context);
        final submmitValue = SubmitAccountEvent(
          createSiteName: '',
          createSiteUserName: '',
          event: AccountEvent(
            joinSite: '',
            version:
                accountState.events.keys.fold<int>(1, (p, e) => e > p ? e : p) +
                1,
          ),
        );

        final encodedSubmitValue = base64UrlEncode(
          submmitValue.writeToBuffer(),
        );

        context.push('${JoinSiteRoute.fullPath}?event=$encodedSubmitValue');
      },
      child: Text(HyttaHubLocalizations.of(context)!.joinSiteTitle),
    );
  }
}
