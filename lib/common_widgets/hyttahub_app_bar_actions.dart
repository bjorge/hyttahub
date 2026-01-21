import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/preferences_cubits/language_cubit.dart';
import 'package:hyttahub/preferences_cubits/theme_cubit.dart';
import 'package:hyttahub/preferences_cubits/platform_cubit.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';

class HyttaHubAppBarActions extends StatelessWidget {
  const HyttaHubAppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = HyttaHubLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          tooltip: l10n.info,
          onPressed: () {
            HyttaHubRoutes.landingInfoPageRoute.go(context);
          },
        ),
        _LanguagePicker(l10n: l10n),
        _ThemePicker(l10n: l10n),
        _PlatformPicker(l10n: l10n),
      ],
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  final HyttaHubLocalizations l10n;
  const _LanguagePicker({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, AppLanguage>(
      builder: (context, language) {
        return PopupMenuButton<AppLanguage>(
          tooltip: l10n.selectLanguage,
          icon: const Icon(Icons.language),
          onSelected: (AppLanguage newLanguage) {
            context.read<LanguageCubit>().setLanguage(newLanguage);
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<AppLanguage>>[
            PopupMenuItem<AppLanguage>(
              value: AppLanguage.en,
              child: Row(
                children: [
                  Text(l10n.english),
                  if (language == AppLanguage.en) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.check, size: 16),
                  ],
                ],
              ),
            ),
            PopupMenuItem<AppLanguage>(
              value: AppLanguage.it,
              child: Row(
                children: [
                  Text(l10n.italian),
                  if (language == AppLanguage.it) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.check, size: 16),
                  ],
                ],
              ),
            ),
            PopupMenuItem<AppLanguage>(
              value: AppLanguage.es,
              child: Row(
                children: [
                  Text(l10n.spanish),
                  if (language == AppLanguage.es) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.check, size: 16),
                  ],
                ],
              ),
            ),
            PopupMenuItem<AppLanguage>(
              value: AppLanguage.nb,
              child: Row(
                children: [
                  Text(l10n.norwegian),
                  if (language == AppLanguage.nb) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.check, size: 16),
                  ],
                ],
              ),
            ),
            PopupMenuItem<AppLanguage>(
              value: AppLanguage.nl,
              child: Row(
                children: [
                  Text(l10n.dutch),
                  if (language == AppLanguage.nl) ...[
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
  const _PlatformPicker({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlatformCubit, StorageEnum>(
      builder: (context, platform) {
        return PopupMenuButton<StorageEnum>(
          tooltip: l10n.platform,
          icon: const Icon(Icons.settings_suggest),
          onSelected: (StorageEnum newPlatform) {
            context.read<PlatformCubit>().setPlatform(newPlatform);
          },
          itemBuilder: (BuildContext context) => StorageEnum.values
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
