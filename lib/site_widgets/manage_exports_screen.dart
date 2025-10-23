// Copyright (c) 2025 bjorge

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/cloud_functions.pb.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/service_blocs/cloud_functions_bloc.dart';
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
        create: (_) => CloudFunctionsBloc()..listExports(siteId),
        child: BlocConsumer<CloudFunctionsBloc, CloudFunctionsState>(
          listener: (context, state) {
            if (state is ExportDeleteSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    HyttaHubLocalizations.of(
                      context,
                    )!.exportDeletedSuccessfully,
                  ),
                ),
              );
              context.read<CloudFunctionsBloc>().listExports(siteId);
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
            if (state.hasExportListSuccess()) {
              if (state.exportListSuccess.files.isEmpty) {
                return Center(
                  child: Text(
                    HyttaHubLocalizations.of(context)!.noExportsFound,
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.exportListSuccess.files.length,
                itemBuilder: (context, index) {
                  final file = state.exportListSuccess.files[index];
                  return ListTile(
                    title: Text(file.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () {
                            context.go(
                              ExportDetailsRoute.fullPath(
                                siteId: siteId,
                                fileName: file.name,
                              ),
                            );
                          },
                        ),
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
                            context.read<CloudFunctionsBloc>().deleteExport(
                              siteId,
                              file.name,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return Center(
              child: Text(
                HyttaHubLocalizations.of(context)!.failedToLoadExports,
              ),
            );
          },
        ),
      ),
    );
  }
}
