// Copyright (c) 2026 bjorge

import 'package:flutter/material.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';

class OpenSourceLicensesScreen extends StatelessWidget {
  const OpenSourceLicensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LicensePage(
      applicationName: HyttaHubLocalizations.of(context)!.openSourceLicensesTitle,
    );
  }
}
