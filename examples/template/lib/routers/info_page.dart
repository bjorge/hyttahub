// Copyright (c) 2025 bjorge

import 'package:template/l10n/app_localizations.dart';
import 'package:template/main.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/proto/auth_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/service_blocs/service_replay_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/preferences_cubits/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A page that displays application information and secondary actions.
class InfoPage extends StatelessWidget {
  /// Creates an [InfoPage].
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hLoc = HyttaHubLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.app_appTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              l10n.app_versionInfo(appVersion, appBuildNumber),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                context.read<ServiceReplayBloc>().add(
                  CommonReplayBlocEvent(listen: true),
                );
                context.read<AuthBloc>().add(
                  AuthBlocEvent(logout: AuthBlocEvent_Logout()),
                );
                context.read<CreateAccountCubit>().setCreateAccount(false);
                context.push(ServiceLoginScreenRoute.fullPath);
              },
              child: Text(l10n.app_serviceLoginButton),
            ),
            TextButton(
              onPressed: () {
                context.push(OpenSourceLicensesRoute.fullPath);
              },
              child: Text(hLoc.openSourceLicensesButton),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
