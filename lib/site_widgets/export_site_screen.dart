// Copyright (c) 2025 bjorge

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/cloud_functions.pb.dart';
import 'package:hyttahub/service_blocs/cloud_functions_bloc.dart';
// import 'package:hyttahub/service_blocs/cloud_functions_state.dart';

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
        create: (_) => CloudFunctionsBloc(),
        child: BlocConsumer<CloudFunctionsBloc, CloudFunctionsState>(
          listener: (context, state) {
            if (state.hasExportSuccess()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.exportSuccess.message)),
              );
              Navigator.of(context).pop();
            } else if (state.hasFailure()) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.failure.error)));
            }
          },
          builder: (context, state) {
            if (state.hasLoading()) {
              return const Center(child: CircularProgressIndicator());
            }
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<CloudFunctionsBloc>().exportSite(siteId);
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
