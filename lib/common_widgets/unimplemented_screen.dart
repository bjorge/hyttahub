// Copyright (c) 2025 bjorge

import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:material_ui/material_ui.dart';

class UnimplementedScreen extends StatelessWidget {
  const UnimplementedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(HyttaHubLocalizations.of(context)!.unimplementedTitle),
      ),
      body: Center(
        child: Text(HyttaHubLocalizations.of(context)!.toBeImplemented),
      ),
    );
  }
}
