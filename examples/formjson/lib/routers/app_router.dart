// Copyright (c) 2025 bjorge

import 'package:formjson/routers/app_routes.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/preferences_cubits/language_cubit.dart';
import 'package:hyttahub/preferences_cubits/login_cubit.dart';
import 'package:hyttahub/preferences_cubits/theme_cubit.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/service_blocs/cloud_functions_bloc.dart';
import 'package:hyttahub/service_blocs/service_replay_bloc.dart';
import 'package:hyttahub/site_widgets/site_edit_mode_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:hyttahub/proto/auth_bloc.pb.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    // tell hyttahub how to route to the site screen for the app
    accountScreenRoute.routes.add(siteScreenRoute);

    _router = GoRouter(
      initialLocation: LandingScreenRoute.fullPath,
      routes: <RouteBase>[landingScreenRoute],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create:
              (_) => ThemeCubit(HyttaHubOptions.firebaseRootCollection ?? ''),
        ),
        BlocProvider<LanguageCubit>(
          create:
              (_) =>
                  LanguageCubit(HyttaHubOptions.firebaseRootCollection ?? ''),
        ),
        BlocProvider<CreateAccountCubit>(create: (_) => CreateAccountCubit()),
        BlocProvider<SiteEditModeCubit>(create: (_) => SiteEditModeCubit()),
        BlocProvider<ServiceReplayBloc>(create: (_) => ServiceReplayBloc()),
        BlocProvider<CloudFunctionsBloc>(create: (_) => CloudFunctionsBloc()),
        BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          return BlocBuilder<LanguageCubit, AppLanguage>(
            builder: (context, language) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                themeMode: mode, // Automatically switch based on system setting
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.blueAccent,
                    brightness: Brightness.light,
                  ),
                  useMaterial3: true,
                ),
                darkTheme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.lightBlueAccent,
                    brightness: Brightness.dark,
                  ),
                  useMaterial3: true,
                ),
                locale: Locale(language.name),
                supportedLocales: const [
                  Locale('en'),
                  Locale('it'),
                  Locale('es'),
                ],
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  HyttaHubLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                routerConfig: _router,
              );
            },
          );
        },
      ),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Logout?'),
              content: const Text('Are you sure you want to log out?'),
              actions: [
                TextButton(
                  onPressed:
                      () => Navigator.pop(context, false), // Stay on page
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      AuthBlocEvent(logout: AuthBlocEvent_Logout()),
                    );

                    // FirebaseAuth.instance.signOut(); // Sign out user
                    Navigator.pop(context, true); // Allow navigation away
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
      ) ??
      false; // Default to false if dialog is dismissed
}
