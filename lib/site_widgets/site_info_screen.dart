import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:hyttahub/utilities/common_error_handling.dart';
import 'package:hyttahub/functions/hyttahub_functions_factory.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';

class SiteInfoScreen extends StatelessWidget {
  const SiteInfoScreen({super.key, required this.siteId});

  final String siteId;

  @override
  Widget build(BuildContext context) {
    final loc = HyttaHubLocalizations.of(context)!;

    return BlocProvider<SiteReplayBloc>(
      key: Key('SiteReplayBloc-SiteInfoScreen-$siteId'),
      create:
          (_) =>
              SiteReplayBloc(siteId)..add(CommonReplayBlocEvent(listen: true)),
      child: BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
        builder: (context, state) {
          final errorWidget = handleSiteReplayState(context, state);
          if (errorWidget != null) {
            return errorWidget;
          }

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
                    ScaffoldMessenger.of(context).showSnackBar(
                      commonSnackBar(context, Text(loc.siteIdCopied)),
                    );
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                        const SizedBox(height: 24),
                        Text(
                          loc.siteEventCount,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          siteEventCount.toString(),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          loc.siteTotalSize,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatSize(siteTotalSize, loc),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 24),
                        FutureBuilder<Map<String, dynamic>>(
                          future: HyttaHubFunctionsFactory.getFunctions(
                            HyttaHubOptions.implementation?.storage ??
                                StorageEnum.firestore,
                          ).listSiteFiles(
                            siteId: siteId,
                            appName: HyttaHubOptions
                                    .implementation?.firebaseRootCollection ??
                                '',
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text(
                                loc.errorFetchingFiles,
                                style: const TextStyle(color: Colors.red),
                              );
                            }

                            final data = snapshot.data;
                            if (data == null || data['files'] == null) {
                              return Container();
                            }

                            final files =
                                List<Map<String, dynamic>>.from(data['files']);
                            final fileCount = files.length;
                            final totalSize = files.fold<int>(
                              0,
                              (prev, file) => prev + (file['size'] as int),
                            );

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.siteFileCount,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  fileCount.toString(),
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  loc.siteTotalFileSize,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _formatSize(totalSize, loc),
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
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

