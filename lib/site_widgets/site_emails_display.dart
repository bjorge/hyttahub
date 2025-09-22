// Copyright (c) 2025 bjorge

import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/common_widgets/allowed_emails_display.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:flutter/material.dart';

class SiteEmailsDisplayScreen extends StatelessWidget {
  const SiteEmailsDisplayScreen({super.key, required this.siteId});
  final String siteId;

  @override
  Widget build(BuildContext context) {
    return AllowedEmailsDisplay(
      config: SiteEmailsConfig(
        siteId,
        HyttaHubLocalizations.of(context)!.siteEmailsTitle,
      ),
    );
  }
}

class SiteEmailsConfig extends AllowedEmailsDisplayConfig {
  SiteEmailsConfig(this.siteId, this.screenTitle);
  final String siteId;

  @override
  String get collectionPath => firebaseSiteUsersPath(siteId);

  @override
  final String screenTitle;
}
