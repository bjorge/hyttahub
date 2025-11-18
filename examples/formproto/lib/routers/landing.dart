// Copyright (c) 2025 bjorge

import 'package:formproto/l10n/app_localizations.dart';
import 'package:formproto/main.dart';
import 'package:hyttahub/preferences_cubits/login_cubit.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/proto/auth_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/preferences_cubits/theme_cubit.dart';
import 'package:hyttahub/preferences_cubits/language_cubit.dart';
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
    final languageCubit = context.watch<LanguageCubit>();
    final themeCubit = context.watch<ThemeCubit>();

    return Scaffold(
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

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      l10n.app_selectLanguage,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<AppLanguage>(
                      value: languageCubit.state,
                      onChanged: (AppLanguage? newValue) {
                        if (newValue != null) {
                          context.read<LanguageCubit>().setLanguage(newValue);
                        }
                      },
                      items:
                          AppLanguage.values.map((language) {
                            return DropdownMenuItem<AppLanguage>(
                              value: language,
                              child: Text(switch (language) {
                                AppLanguage.en => l10n.app_english,
                                AppLanguage.it => l10n.app_italian,
                                AppLanguage.es => l10n.app_spanish,
                              }),
                            );
                          }).toList(),
                    ),
                  ],
                ),
                const SizedBox(width: 48),
                Column(
                  children: [
                    Text(
                      l10n.app_nightMode,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<ThemeMode>(
                      value: themeCubit.state,
                      onChanged: (ThemeMode? newValue) {
                        if (newValue != null) {
                          context.read<ThemeCubit>().setTheme(newValue);
                        }
                      },
                      items:
                          ThemeMode.values.map((theme) {
                            return DropdownMenuItem<ThemeMode>(
                              value: theme,
                              child: Text(switch (theme) {
                                ThemeMode.system =>
                                  l10n.app_themeSettingsAutomatic,
                                ThemeMode.light =>
                                  l10n.app_themeSettingsAlwaysOff,
                                ThemeMode.dark =>
                                  l10n.app_themeSettingsAlwaysOn,
                              }),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ],
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
            const SizedBox(height: 48),
            Text(
              l10n.app_otherAppsTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // final uri = Uri.parse('https://friendlyreservations.com');
                // launchUrl(uri);
              },
              child: Text(l10n.app_reservationsAppButton),
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
                    // padding: const EdgeInsets.symmetric(
                    //   horizontal: 40,
                    //   vertical: 20,
                    // ),
                    textStyle: Theme.of(context).textTheme.bodySmall,
                  ),
                  onPressed: () {
                    context.read<ServiceReplayBloc>().add(
                      CommonReplayBlocEvent(listen: true),
                    );
                    context.read<AuthBloc>().add(
                      AuthBlocEvent(logout: AuthBlocEvent_Logout()),
                      // AuthBlocEvent(startup: AuthBlocEvent_AppStartup()),
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
