// Copyright (c) 2025 bjorge

import 'package:template/l10n/app_localizations.dart';
import 'package:template/main.dart';
import 'package:hyttahub/preferences_cubits/login_cubit.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/proto/auth_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/preferences_cubits/theme_cubit.dart';
import 'package:hyttahub/preferences_cubits/language_cubit.dart';
import 'package:hyttahub/preferences_cubits/platform_cubit.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/service_blocs/service_replay_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        actions: [
          PopupMenuButton<AppLanguage>(
            icon: const Icon(Icons.language),
            tooltip: l10n.app_selectLanguage,
            onSelected: (AppLanguage newValue) {
              context.read<LanguageCubit>().setLanguage(newValue);
            },
            itemBuilder: (BuildContext context) {
              return AppLanguage.values.map((language) {
                return PopupMenuItem<AppLanguage>(
                  value: language,
                  child: Text(
                    switch (language) {
                      AppLanguage.en => l10n.app_english,
                      AppLanguage.it => l10n.app_italian,
                      AppLanguage.es => l10n.app_spanish,
                      AppLanguage.nb => l10n.app_norwegian,
                      AppLanguage.nl => l10n.app_dutch,
                    },
                  ),
                );
              }).toList();
            },
          ),
          PopupMenuButton<ThemeMode>(
            icon: const Icon(Icons.brightness_medium),
            tooltip: l10n.app_nightMode,
            onSelected: (ThemeMode newValue) {
              context.read<ThemeCubit>().setTheme(newValue);
            },
            itemBuilder: (BuildContext context) {
              return ThemeMode.values.map((theme) {
                return PopupMenuItem<ThemeMode>(
                  value: theme,
                  child: Text(
                    switch (theme) {
                      ThemeMode.system => l10n.app_themeSettingsAutomatic,
                      ThemeMode.light => l10n.app_themeSettingsAlwaysOff,
                      ThemeMode.dark => l10n.app_themeSettingsAlwaysOn,
                    },
                  ),
                );
              }).toList();
            },
          ),
          PopupMenuButton<int>(
            icon: const Icon(Icons.computer),
            tooltip: "Platform",
            onSelected: (int newValue) {
              final storage =
                  StorageEnum.valueOf(newValue) ?? StorageEnum.inMemory;
              context.read<PlatformCubit>().setPlatform(storage);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: [
                      const Icon(Icons.cloud),
                      const SizedBox(width: 8),
                      const Text("Firebase"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      const Icon(Icons.memory),
                      const SizedBox(width: 8),
                      const Text("In Memory"),
                    ],
                  ),
                ),
              ];
            },
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.app_versionInfo(appVersion, appBuildNumber),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.bodySmall,
                  ),
                  onPressed: () {
                    context.read<ServiceReplayBloc>().add(
                      CommonReplayBlocEvent(listen: true),
                    );
                    context.read<AuthBloc>().add(
                      AuthBlocEvent(logout: AuthBlocEvent_Logout()),
                    );

                    context.read<CreateAccountCubit>().setCreateAccount(false);

                    // This navigates to the login screen.
                    context.push(ServiceLoginScreenRoute.fullPath);
                  },
                  child: Text(l10n.app_serviceLoginButton),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
