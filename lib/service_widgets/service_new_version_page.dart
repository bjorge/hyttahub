// Copyright (c) 2025 bjorge

import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:flutter/material.dart';

class ServiceNewVersionPage extends StatelessWidget {
  final VoidCallback? onAdminLogin;
  final String? adminLoginButtonLabel;
  const ServiceNewVersionPage({
    super.key,
    this.onAdminLogin,
    this.adminLoginButtonLabel,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = HyttaHubLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.newVersionAvailableTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              localizations.newVersionAvailableMessage,
              textAlign: TextAlign.center,
            ),
            if (onAdminLogin != null) ...[
              const SizedBox(height: 20),
              TextButton(
                onPressed: onAdminLogin,
                child: Text(
                  adminLoginButtonLabel ??
                      localizations.serviceAdminDetectionTitle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
