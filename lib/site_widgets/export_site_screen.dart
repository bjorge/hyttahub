// Copyright (c) 2025 bjorge

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/service_blocs/export_bloc.dart';

class ExportSiteScreen extends StatelessWidget {
  final String siteId;

  const ExportSiteScreen({super.key, required this.siteId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(HyttaHubLocalizations.of(context)!.exportSiteTitle),
      ),
      body: BlocProvider(
        create: (_) => ExportBloc(),
        child: BlocConsumer<ExportBloc, ExportState>(
          listener: (context, state) {
            if (state is ExportSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              Navigator.of(context).pop();
            } else if (state is ExportFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is ExportLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<ExportBloc>().exportPhotos(siteId);
                },
                child: Text(HyttaHubLocalizations.of(context)!.exportSiteTitle),
              ),
            );
          },
        ),
      ),
    );
  }
}