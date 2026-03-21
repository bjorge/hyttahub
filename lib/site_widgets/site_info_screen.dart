import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:hyttahub/storage/hyttahub_storage_factory.dart';
import 'package:hyttahub/collection_paths.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';

import 'package:hyttahub/common_widgets/layout.dart';

class SiteInfoScreen extends StatelessWidget {
  const SiteInfoScreen({super.key, required this.siteId});

  final String siteId;

  @override
  Widget build(BuildContext context) {
    final loc = HyttaHubLocalizations.of(context)!;

    return BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
      builder: (context, state) {
        final siteEventCount = state.events.length;
        final siteTotalSize = state.events.values.fold<int>(
          0,
          (previousValue, element) => previousValue + element.length,
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(loc.siteInfoTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.copy),
                tooltip: loc.copySiteIdTooltip,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: siteId));
                  showCommonSnackBar(context, Text(loc.siteIdCopied));
                },
              ),
            ],
          ),
          body: CommonListViewLayout(
            spacing: 24.0,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Site ID',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    siteId,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.siteEventCount,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    siteEventCount.toString(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.siteTotalSize,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatSize(siteTotalSize, loc),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              FutureBuilder<Map<String, dynamic>>(
                future: () async {
                  final storage = HyttaHubStorageFactory.getStorage(
                    HyttaHubOptions.implementation?.storage ?? StorageEnum.cloud,
                  );
                  final appName = HyttaHubOptions.implementation?.cloudRootCollection ?? '';
                  final files = await storage.listFiles(collectionFilesPath(siteId, ''));
                  int totalSize = 0;
                  // If we don't have getFileBytes implementated well for sizing, we still mimic existing behavior for now
                  for (final file in files) {
                    final bytes = await storage.getFileBytes(
                      appName: appName,
                      siteId: siteId,
                      fileName: file.split('/').last,
                    );
                    totalSize += bytes.length;
                  }
                  return {
                    'files': files,
                    'fileCount': files.length,
                    'totalSize': totalSize,
                  };
                }(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    print('Error fetching files for site info: ${snapshot.error}\nStack trace:\n${snapshot.stackTrace}');
                    return Text(
                      '${loc.errorFetchingFiles}: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    );
                  }

                  final data = snapshot.data;
                  if (data == null || data['files'] == null) {
                    return Container();
                  }

                  final fileCount = data['fileCount'] as int;
                  final totalSize = data['totalSize'] as int;

                  return Column(
                    spacing: 24.0,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.siteFileCount,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            fileCount.toString(),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.siteTotalFileSize,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatSize(totalSize, loc),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatSize(int bytes, HyttaHubLocalizations loc) {
    if (bytes < 1024) {
      return loc.bytesLabel(bytes);
    } else if (bytes < 1024 * 1024) {
      return loc.kilobytesLabel(bytes / 1024.0);
    } else if (bytes < 1024 * 1024 * 1024) {
      return loc.megabytesLabel(bytes / (1024.0 * 1024.0));
    } else {
      return loc.gigabytesLabel(bytes / (1024.0 * 1024.0 * 1024.0));
    }
  }
}

