// Copyright (c) 2025 bjorge

import 'package:template/l10n/app_localizations.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/proto/auth_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/service_blocs/service_replay_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/common_widgets/hyttahub_app_bar_actions.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/preferences_cubits/language_cubit.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';

/// The initial page of the application.
///
/// From here, users can proceed to the login/authentication flow.
/// This page displays the app name, an entry button, and the app version.
class LandingPage extends StatelessWidget {
  /// Creates a [LandingPage].
  const LandingPage({super.key});

  /// The route name for this page, used in GoRouter.
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        actions: const [
          HyttaHubAppBarActions(
            supportedLanguages: [
              AppLanguage.en,
              AppLanguage.es,
              AppLanguage.it,
              AppLanguage.nb,
              AppLanguage.nl,
            ],
            supportedPlatforms: [
              StorageEnum.inMemory,
              StorageEnum.firestore,
              StorageEnum.localStorage,
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(flex: 3),
            Text(
              l10n.app_appTitle,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                textStyle: Theme.of(context).textTheme.titleLarge,
              ),
              onPressed: () {
                context.read<ServiceReplayBloc>().add(
                  CommonReplayBlocEvent(listen: true),
                );
                context.read<AuthBloc>().add(
                  AuthBlocEvent(startup: AuthBlocEvent_AppStartup()),
                );

                // This navigates to the login screen.
                context.push(LoginScreenRoute.fullPath);
              },
              child: Text(l10n.app_enterButton),
            ),
            const Spacer(flex: 2),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
