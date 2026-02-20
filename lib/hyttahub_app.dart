// Copyright (c) 2025 bjorge

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/preferences_cubits/language_cubit.dart';
import 'package:hyttahub/preferences_cubits/login_cubit.dart';
import 'package:hyttahub/preferences_cubits/platform_cubit.dart';
import 'package:hyttahub/preferences_cubits/theme_cubit.dart';
import 'package:hyttahub/service_blocs/cloud_functions_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';


/// A wrapper around [MaterialApp.router] that provides common HyttaHub BLoCs
/// and handles platform-specific lifecycle management.
class HyttaHubApp extends StatelessWidget {
  /// The router configuration for the application.
  final RouterConfig<Object> routerConfig;

  /// The localization delegates for the application.
  /// These will be merged with HyttaHub library defaults.
  final List<LocalizationsDelegate<dynamic>> localizationsDelegates;

  /// The supported locales for the application.
  final List<Locale> supportedLocales;

  /// The light theme for the application.
  final ThemeData? lightTheme;

  /// The dark theme for the application.
  final ThemeData? darkTheme;

  /// Additional BLoC providers that should persist across platform switches.
  final List<BlocProvider> additionalOuterProviders;

  /// Additional BLoC providers that should be recreated when the platform changes.
  final List<BlocProvider> additionalInnerProviders;

  /// Creates a [HyttaHubApp].
  const HyttaHubApp({
    super.key,
    required this.routerConfig,
    this.localizationsDelegates = const [],
    this.supportedLocales = const [
      Locale('en'),
      Locale('it'),
      Locale('es'),
      Locale('nb'),
      Locale('nl'),
    ],
    this.lightTheme,
    this.darkTheme,
    this.additionalOuterProviders = const [],
    this.additionalInnerProviders = const [],
  });

  @override
  Widget build(BuildContext context) {
    final rootCollection = HyttaHubOptions.implementation?.firebaseRootCollection ?? '';

    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit(rootCollection)),
        BlocProvider<LanguageCubit>(create: (_) => LanguageCubit(rootCollection)),
        BlocProvider<PlatformCubit>(create: (_) => PlatformCubit(rootCollection)),
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        ...additionalOuterProviders,
      ],
      child: BlocBuilder<PlatformCubit, String>(
        builder: (context, implementationId) {
          return MultiBlocProvider(
            key: ValueKey(implementationId),
            providers: [
              BlocProvider<CreateAccountCubit>(
                create: (_) => CreateAccountCubit('$rootCollection:$implementationId'),
              ),
              BlocProvider<CloudFunctionsBloc>(create: (_) => CloudFunctionsBloc()),
              ...additionalInnerProviders,
            ],
            child: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) {
                return BlocBuilder<LanguageCubit, AppLanguage>(
                  builder: (context, language) {
                    return MaterialApp.router(
                      debugShowCheckedModeBanner: false,
                      themeMode: mode,
                      theme: lightTheme ?? _defaultLightTheme,
                      darkTheme: darkTheme ?? _defaultDarkTheme,
                      locale: Locale(language.name),
                      supportedLocales: supportedLocales,
                      localizationsDelegates: [
                        ...localizationsDelegates,
                        HyttaHubLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      routerConfig: routerConfig,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  ThemeData get _defaultLightTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      );

  ThemeData get _defaultDarkTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlueAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      );
}
