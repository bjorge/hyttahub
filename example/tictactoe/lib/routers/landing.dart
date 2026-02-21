// Copyright (c) 2025 bjorge

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/preferences_cubits/login_cubit.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/proto/auth_bloc.pb.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/preferences_cubits/theme_cubit.dart';
import 'package:hyttahub/preferences_cubits/language_cubit.dart';
import 'package:hyttahub/preferences_cubits/platform_cubit.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/utilities/persistence_registries.dart';
import 'package:tictactoe/l10n/app_localizations.dart';
import 'package:tictactoe/main.dart';

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
    final platformCubit = context.watch<PlatformCubit>();

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

            Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: [
                DropdownMenu<AppLanguage>(
                  width: 250,
                  initialSelection: languageCubit.state,
                  leadingIcon: const Icon(Icons.language),
                  label: Text(l10n.app_selectLanguage),
                  onSelected: (AppLanguage? newValue) {
                    if (newValue != null) {
                      context.read<LanguageCubit>().setLanguage(newValue);
                    }
                  },
                  dropdownMenuEntries:
                      AppLanguage.values.map((language) {
                        return DropdownMenuEntry<AppLanguage>(
                          value: language,
                          label: switch (language) {
                            AppLanguage.en => l10n.app_english,
                            AppLanguage.it => l10n.app_italian,
                            AppLanguage.es => l10n.app_spanish,
                            AppLanguage.nb => l10n.app_norwegian,
                            AppLanguage.nl => l10n.app_dutch,
                          },
                        );
                      }).toList(),
                ),
                DropdownMenu<ThemeMode>(
                  width: 250,
                  initialSelection: themeCubit.state,
                  leadingIcon: const Icon(Icons.brightness_medium),
                  label: Text(l10n.app_nightMode),
                  onSelected: (ThemeMode? newValue) {
                    if (newValue != null) {
                      context.read<ThemeCubit>().setTheme(newValue);
                    }
                  },
                  dropdownMenuEntries:
                      ThemeMode.values.map((theme) {
                        return DropdownMenuEntry<ThemeMode>(
                          value: theme,
                          label: switch (theme) {
                            ThemeMode.system => l10n.app_themeSettingsAutomatic,
                            ThemeMode.light => l10n.app_themeSettingsAlwaysOff,
                            ThemeMode.dark => l10n.app_themeSettingsAlwaysOn,
                          },
                        );
                      }).toList(),
                ),
                DropdownMenu<String>(
                  width: 250,
                  initialSelection: platformCubit.state,
                  leadingIcon: const Icon(Icons.computer),
                  label: const Text("Platform"),
                  onSelected: (String? newValue) {
                    if (newValue != null) {
                      context.read<PlatformCubit>().setImplementation(newValue, authBloc: context.read<AuthBloc>());
                    }
                  },
                  dropdownMenuEntries: PersistenceRegistry.registeredImplementations.map((impl) {
                    return DropdownMenuEntry<String>(
                      value: impl.id,
                      label: impl.name,
                      leadingIcon: Icon(switch (impl.type) {
                        StorageEnum.memory => Icons.memory,
                        StorageEnum.cloud => Icons.cloud,
                        StorageEnum.local => Icons.storage,
                        _ => Icons.help_outline,
                      }),
                    );
                  }).toList(),
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
                    // padding: const EdgeInsets.symmetric(
                    //   horizontal: 40,
                    //   vertical: 20,
                    // ),
                    textStyle: Theme.of(context).textTheme.bodySmall,
                  ),
                  onPressed: () {
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
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.bodySmall,
                  ),
                  onPressed: () {
                    context.push(OpenSourceLicensesRoute.fullPath);
                  },
                  child: Text(HyttaHubLocalizations.of(context)!.openSourceLicensesButton),
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
