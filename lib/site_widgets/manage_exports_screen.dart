// Copyright (c) 2025 bjorge

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/service_blocs/export_bloc.dart';
import 'package:hyttahub/service_blocs/export_state.dart';
import 'package:url_launcher/url_launcher.dart';

class ManageExportsScreen extends StatelessWidget {
  final String siteId;

  const ManageExportsScreen({super.key, required this.siteId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(HyttaHubLocalizations.of(context)!.manageExportsTitle),
      ),
      body: BlocProvider(
        create: (_) => ExportBloc()..listExports(siteId),
        child: BlocConsumer<ExportBloc, ExportState>(
          listener: (context, state) {
            if (state is ExportDeleteSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(HyttaHubLocalizations.of(context)!
                        .exportDeletedSuccessfully)),
              );
              context.read<ExportBloc>().listExports(siteId);
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
            if (state is ExportListSuccess) {
              if (state.files.isEmpty) {
                return Center(
                    child: Text(
                        HyttaHubLocalizations.of(context)!.noExportsFound));
              }
              return ListView.builder(
                itemCount: state.files.length,
                itemBuilder: (context, index) {
                  final file = state.files[index];
                  return ListTile(
                    title: Text(file.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () async {
                            final url = Uri.parse(file.url);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context
                                .read<ExportBloc>()
                                .deleteExport(siteId, file.name);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return Center(
                child:
                    Text(HyttaHubLocalizations.of(context)!.failedToLoadExports));
          },
        ),
      ),
    );
  }
}