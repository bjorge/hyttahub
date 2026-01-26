// Copyright (c) 2025 bjorge

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/common_widgets/common_form.dart';

class SiteInfoScreen extends StatelessWidget {
  const SiteInfoScreen({super.key, required this.siteId});

  final String siteId;

  @override
  Widget build(BuildContext context) {
    final loc = HyttaHubLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.siteInfoTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: loc.copySiteIdTooltip,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: siteId));
              ScaffoldMessenger.of(context).showSnackBar(
                commonSnackBar(
                  context,
                  Text(loc.siteIdCopied),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Site ID',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    siteId,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

