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
import 'package:hyttahub/proto/auth_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/service_blocs/service_replay_bloc.dart';
import 'package:hyttahub/site_widgets/site_name_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountReplayBloc, AccountReplayBlocState>(
      builder: (context, accountState) {
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
      listener: (BuildContext context, AccountReplayBlocState accountState) {},
    );
  }
}

class ImportSiteDialogOption extends StatelessWidget {
  const ImportSiteDialogOption({super.key, required this.dialogContext});

  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(dialogContext);
        context.push(ImportSiteRoute.fullPath);
      },
      child: Text(HyttaHubLocalizations.of(context)!.importSiteTitle),
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
                CreateSiteDialogOption(
                  accountState: accountState,
                  dialogContext: dialogContext,
                ),
                ImportSiteDialogOption(dialogContext: dialogContext),
                JoinSiteDialogOption(
                  accountState: accountState,
                  dialogContext: dialogContext,
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    context.push(ManageSitesRoute.fullPath);
                  },
                  child: Text(
                    HyttaHubLocalizations.of(context)!.manageSitesTitle,
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    context.push(CopySiteRoute.fullPath);
                  },
                  child: Text(
                    HyttaHubLocalizations.of(context)!.copySiteTitle,
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    final submmitValue = SubmitAccountEvent(
                      event: AccountEvent(
                        version: accountState.nextVersion,
                        reorderSites: ReorderSites(
                          siteIds: accountState.sitesIds,
                        ),
                      ),
                    );

                    final encodedSubmitValue = base64UrlEncode(
                      submmitValue.writeToBuffer(),
                    );

                    context.push(
                      '${ReorderSitesRoute.fullPath}?event=$encodedSubmitValue',
                    );
                  },
                  child: Text(
                    HyttaHubLocalizations.of(context)!.reorderSitesTitle,
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
                    Navigator.pop(dialogContext);
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
                    Navigator.pop(dialogContext);
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
  const CreateSiteDialogOption({
    super.key,
    required this.accountState,
    required this.dialogContext,
  });

  final AccountReplayBlocState accountState;
  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(dialogContext);
        final submmitValue = SubmitAccountEvent(
          createSiteName: '',
          createSiteUserName: '',
          event: AccountEvent(
            createSite: generateId(),
            version: accountState.nextVersion,
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
  const JoinSiteDialogOption({
    super.key,
    required this.accountState,
    required this.dialogContext,
  });

  final AccountReplayBlocState accountState;
  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(dialogContext);
        final submmitValue = SubmitAccountEvent(
          createSiteName: '',
          createSiteUserName: '',
          event: AccountEvent(
            joinSite: '',
            version: accountState.nextVersion,
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
