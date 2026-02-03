import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/preferences_cubits/language_cubit.dart';
import 'package:hyttahub/preferences_cubits/theme_cubit.dart';
import 'package:hyttahub/preferences_cubits/platform_cubit.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';

import 'package:hyttahub/utils/refresh_helper.dart';

class HyttaHubAppBarActions extends StatelessWidget {
  final List<AppLanguage>? supportedLanguages;
  final List<StorageEnum>? supportedPlatforms;

  const HyttaHubAppBarActions({
    super.key,
    this.supportedLanguages,
    this.supportedPlatforms,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = HyttaHubLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: l10n.refresh,
          onPressed: () async {
            await RefreshHelper.refresh();
          },
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          tooltip: l10n.info,
          onPressed: () {
            HyttaHubRoutes.landingInfoPageRoute.go(context);
          },
        ),
        _LanguagePicker(l10n: l10n, supportedLanguages: supportedLanguages),
        _ThemePicker(l10n: l10n),
        _PlatformPicker(l10n: l10n, supportedPlatforms: supportedPlatforms),
      ],
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  final HyttaHubLocalizations l10n;
  final List<AppLanguage>? supportedLanguages;
  const _LanguagePicker({required this.l10n, this.supportedLanguages});

  @override
  Widget build(BuildContext context) {
    final languagesToShow = supportedLanguages ?? AppLanguage.values;

    return BlocBuilder<LanguageCubit, AppLanguage>(
      builder: (context, language) {
        return PopupMenuButton<AppLanguage>(
          tooltip: l10n.selectLanguage,
          icon: const Icon(Icons.language),
          onSelected: (AppLanguage newLanguage) {
            context.read<LanguageCubit>().setLanguage(newLanguage);
          },
          itemBuilder: (BuildContext context) {
            return AppLanguage.values.where((l) => languagesToShow.contains(l)).map((l) {
              String name;
              switch (l) {
                case AppLanguage.en:
                  name = l10n.english;
                  break;
                case AppLanguage.it:
                  name = l10n.italian;
                  break;
                case AppLanguage.es:
                  name = l10n.spanish;
                  break;
                case AppLanguage.nb:
                  name = l10n.norwegian;
                  break;
                case AppLanguage.nl:
                  name = l10n.dutch;
                  break;
              }
              return PopupMenuItem<AppLanguage>(
                value: l,
                child: Row(
                  children: [
                    Text(name),
                    if (language == l) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.check, size: 16),
                    ],
                  ],
                ),
              );
            }).toList();
          },
        );
      },
    );
  }
}

class _ThemePicker extends StatelessWidget {
  final HyttaHubLocalizations l10n;
  const _ThemePicker({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        return PopupMenuButton<ThemeMode>(
          tooltip: l10n.nightMode,
          icon: const Icon(Icons.brightness_4),
          onSelected: (ThemeMode newMode) {
            context.read<ThemeCubit>().setTheme(newMode);
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<ThemeMode>>[
            PopupMenuItem<ThemeMode>(
              value: ThemeMode.system,
              child: Row(
                children: [
                  Text(l10n.themeSettingsAutomatic),
                  if (mode == ThemeMode.system) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.check, size: 16),
                  ],
                ],
              ),
            ),
            PopupMenuItem<ThemeMode>(
              value: ThemeMode.light,
              child: Row(
                children: [
                  Text(l10n.themeSettingsAlwaysOff),
                  if (mode == ThemeMode.light) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.check, size: 16),
                  ],
                ],
              ),
            ),
            PopupMenuItem<ThemeMode>(
              value: ThemeMode.dark,
              child: Row(
                children: [
                  Text(l10n.themeSettingsAlwaysOn),
                  if (mode == ThemeMode.dark) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.check, size: 16),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PlatformPicker extends StatelessWidget {
  final HyttaHubLocalizations l10n;
  final List<StorageEnum>? supportedPlatforms;
  const _PlatformPicker({required this.l10n, this.supportedPlatforms});

  @override
  Widget build(BuildContext context) {
    final platformsToShow = supportedPlatforms ?? StorageEnum.values;
    return BlocBuilder<PlatformCubit, StorageEnum>(
      builder: (context, platform) {
        return PopupMenuButton<StorageEnum>(
          tooltip: l10n.platform,
          icon: const Icon(Icons.computer),
          onSelected: (StorageEnum newPlatform) {
            context.read<PlatformCubit>().setPlatform(newPlatform);
          },
          itemBuilder:
              (BuildContext context) =>
                  StorageEnum.values
                      .where((e) => platformsToShow.contains(e))
                      .map(
                        (e) => PopupMenuItem<StorageEnum>(
                          value: e,
                          child: Row(
                            children: [
                              Text(e.name),
                              if (platform == e) ...[
                                const SizedBox(width: 8),
                                const Icon(Icons.check, size: 16),
                              ],
                            ],
                          ),
                        ),
                      )
                      .toList(),
        );
      },
    );
  }
}
