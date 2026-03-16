// Copyright (c) 2025 bjorge

import 'package:flutter/foundation.dart';
import 'package:hyttahub/common_widgets/layout.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/preferences_cubits/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/utils/refresh_helper.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:hyttahub/preferences_cubits/theme_cubit.dart';
import 'package:hyttahub/preferences_cubits/language_cubit.dart';
import 'package:hyttahub/preferences_cubits/platform_cubit.dart';

/// A generic page that displays application information and secondary actions.
class HyttaHubInfoPage extends StatelessWidget {
  /// Creates a [HyttaHubInfoPage].
  const HyttaHubInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = HyttaHubLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: context.canPop()
            ? BackButton(onPressed: () => context.pop())
            : null,
        title: Text(HyttaHubOptions.appTitle),
      ),
      body: CommonListViewLayout(
        spacing: 10,
        children: [
          SizedBox(height: 20),
          Center(
            child: Text(
              l10n.app_versionInfo(
                HyttaHubOptions.appVersion,
                HyttaHubOptions.appBuildNumber,
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () {
                context.push(OpenSourceLicensesRoute.fullPath);
              },
              child: Text(l10n.openSourceLicensesButton),
            ),
          ),

          Center(
            child: TextButton.icon(
              icon: const Icon(Icons.refresh),
              label: Text(l10n.clearLocalStorageButton),
              onPressed: () async {
                await HydratedBloc.storage.clear();
                if (context.mounted) {
                  context.read<ThemeCubit>().reset();
                  context.read<LanguageCubit>().reset();
                  await context.read<PlatformCubit>().reset();
                  if (context.mounted) {
                    context.go('/');
                  }
                }
              },
            ),
          ),

          if (kIsWeb)
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.refresh),
                label: Text(l10n.refreshBrowserButton),
                onPressed: () async {
                  await RefreshHelper.refresh();
                },
              ),
            ),

          Center(
            child: TextButton(
              onPressed: () {
                context.read<CreateAccountCubit>().setCreateAccount(false);
                context.push(ServiceLoginScreenRoute.fullPath);
              },
              child: Text(l10n.serviceLoginButton),
            ),
          ),
        ],
      ),
    );
  }
}
