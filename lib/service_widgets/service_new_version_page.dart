// Copyright (c) 2025 bjorge

import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:flutter/material.dart';

class ServiceNewVersionPage extends StatelessWidget {
  const ServiceNewVersionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = HyttaHubLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.newVersionAvailableTitle)),
      body: Center(
        child: Text(
          localizations.newVersionAvailableMessage,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
