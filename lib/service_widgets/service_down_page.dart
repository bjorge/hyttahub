// Copyright (c) 2025 bjorge

import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:flutter/material.dart';

class ServiceDownPage extends StatelessWidget {
  const ServiceDownPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = HyttaHubLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.serviceDownTitle)),
      body: Center(
        child: Text(
          localizations.serviceDownMessage,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
