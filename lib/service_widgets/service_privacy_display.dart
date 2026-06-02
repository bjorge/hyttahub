// Copyright (c) 2025 bjorge

import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/preferences_cubits/language_cubit.dart';
import 'package:hyttahub/service_blocs/service_replay_bloc.dart';
import 'package:hyttahub/utilities/localization_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServicePrivacyDisplay extends StatelessWidget {
  const ServicePrivacyDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = HyttaHubLocalizations.of(context)!;
    final currentLanguage = context.watch<LanguageCubit>().state;

    return BlocBuilder<ServiceReplayBloc, ServiceReplayBlocState>(
      builder: (context, serviceState) {
        if (serviceState.hasPrivacy()) {
          final parsedPrivacy = getLocalizedContent(serviceState.privacy, currentLanguage);

          return Scaffold(
            appBar: AppBar(title: Text(localizations.privacyPolicyTitle)),
            body: Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  parsedPrivacy,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          );
        } else {
          return Center(child: Text(localizations.noPrivacyPolicyAvailable));
        }
      },
    );
  }
}
