// Copyright (c) 2025 bjorge

import 'package:flutter/foundation.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:flutter/material.dart';
import 'package:hyttahub/utils/refresh_helper.dart';

class ServiceNewVersionPage extends StatelessWidget {
  const ServiceNewVersionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = HyttaHubLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.newVersionAvailableTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                localizations.newVersionAvailableMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (kIsWeb) ...[
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () async => await RefreshHelper.refresh(),
                  icon: const Icon(Icons.refresh),
                  label: Text(localizations.refreshBrowserButton),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
