// Copyright (c) 2025 bjorge

import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:flutter/material.dart';

class ServiceDownPage extends StatelessWidget {
  final VoidCallback? onAdminLogin;
  final String? adminLoginButtonLabel;
  const ServiceDownPage({
    super.key,
    this.onAdminLogin,
    this.adminLoginButtonLabel,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = HyttaHubLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.serviceDownTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              localizations.serviceDownMessage,
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
