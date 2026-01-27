import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:hyttahub/utilities/common_error_handling.dart';

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
                          loc.bytesLabel(siteTotalSize),
                          style: Theme.of(context).textTheme.headlineSmall,
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
}

