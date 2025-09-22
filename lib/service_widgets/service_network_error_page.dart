// Copyright (c) 2025 bjorge

import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:flutter/material.dart';

class ServiceNetworkErrorPage extends StatelessWidget {
  const ServiceNetworkErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = HyttaHubLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.networkErrorTitle)),
      body: Center(
        child: Text(
          localizations.serviceNetworkErrorMessage,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
