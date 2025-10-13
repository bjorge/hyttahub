// Copyright (c) 2025 bjorge

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/service_blocs/export_bloc.dart';
import 'package:hyttahub/site_blocs/site_replay.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';

class ExportDetailsScreen extends StatefulWidget {
  final String siteId;
  final String fileName;

  const ExportDetailsScreen({
    super.key,
    required this.siteId,
    required this.fileName,
  });

  @override
  State<ExportDetailsScreen> createState() => _ExportDetailsScreenState();
}

class _ExportDetailsScreenState extends State<ExportDetailsScreen> {
  // final SiteReplayBloc _siteReplayBloc = SiteReplayBloc('');
  SiteReplayBlocState? _replayBlocState;

  @override
  void dispose() {
    // _siteReplayBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ExportBloc()..getExportDetails(widget.siteId, widget.fileName),
      child: Scaffold(
        appBar: AppBar(
          title: Text('exportDetailsTitle'),
          // title: Text(HyttaHubLocalizations.of(context)!.exportDetailsTitle),
        ),
        body: BlocConsumer<ExportBloc, ExportState>(
          listener: (context, state) {
            if (state is ExportDetailsSuccess) {
              final events = state.events.split('\n');
              final Map<int, String> eventsMap = {
                for (var i = 0; i < events.length; i++)
                  if (events[i].isNotEmpty) i + 1: events[i],
              };
              _replayBlocState = siteReplay(SiteReplayBlocState(), eventsMap);
              // _siteReplayBloc.emit(replayedState);
            }
          },
          builder: (context, state) {
            if (state is ExportLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ExportFailure) {
              return Center(child: Text(state.error));
            }
            if (state is ExportDetailsSuccess) {
              return Builder(
                builder: (context) {
                  if (_replayBlocState == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Site Name: ${_replayBlocState!.name}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Members:',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _replayBlocState!.members.length,
                            itemBuilder: (context, index) {
                              final member = _replayBlocState!.members.values
                                  .toList()[index];
                              return ListTile(
                                title: Text(member.name),
                                subtitle: Text(
                                  member.admin ? 'Admin' : 'Member',
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
