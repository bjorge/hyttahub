// Copyright (c) 2025 bjorge

import 'package:hyttahub/l10n/intl_localizations.dart';
import 'dart:convert';

import 'package:hyttahub/firebase_paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protobuf/protobuf.dart';

/// Abstract configuration to drive the generic [EventsDisplay] widget.
///
/// Implement this class for each event type (Service, Account, Site) to provide
/// the specific paths, titles, and parsing/replaying logic.
abstract class EventsDisplayConfig<
  R extends GeneratedMessage,
  S extends GeneratedMessage
> {
  String get collectionPath;
  String get screenTitle;
  String get replayTitle;

  R parseRecord(Map<String, dynamic> data, Timestamp timestamp, String payload);
  int getVersion(R record);
  String getIsoDate(R record);
  S replay(Map<int, String> base64Events);
}

/// A generic screen for displaying a list of events from Firestore and their replayed state.
class EventsDisplay<R extends GeneratedMessage, S extends GeneratedMessage>
    extends StatefulWidget {
  const EventsDisplay({super.key, required this.config});

  final EventsDisplayConfig<R, S> config;

  @override
  State<EventsDisplay<R, S>> createState() => _EventsDisplayState<R, S>();
}

class _EventsDisplayState<
  R extends GeneratedMessage,
  S extends GeneratedMessage
>
    extends State<EventsDisplay<R, S>> {
  List<R>? _records;
  Map<int, String>? _base64Events;
  bool _isLoading = true;
  String? _error;
  bool _isDescending = false;
  bool _showReplay = false;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  void _toggleViewMode() {
    setState(() {
      _showReplay = !_showReplay;
    });
  }

  void _toggleSortOrder() {
    setState(() {
      _isDescending = !_isDescending;
      _isLoading = true;
      _records = null;
      _base64Events = null;
      _error = null;
    });
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final snapshot = await firestore
          .collection(widget.config.collectionPath)
          .orderBy(fbVersion, descending: _isDescending)
          .get();

      final records = <R>[];
      final base64Events = <int, String>{};
      for (final doc in snapshot.docs) {
        final data = doc.data();
        if (data case {
          fbPayload: String payload,
          fbTimeStamp: Timestamp timestamp,
        }) {
          final record = widget.config.parseRecord(data, timestamp, payload);
          final eventVersion = widget.config.getVersion(record);
          base64Events[eventVersion] = payload;
          records.add(record);
        }
      }

      if (mounted) {
        setState(() {
          _records = records;
          _base64Events = base64Events;
          _isLoading = false;
        });
      }
    } catch (e, s) {
      debugPrint('Error fetching events: $e\n$s');
      if (mounted) {
        setState(() {
          _error = HyttaHubLocalizations.of(
            context,
          )!.failedToLoadEvents(e.toString());
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = HyttaHubLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _showReplay ? widget.config.replayTitle : widget.config.screenTitle,
        ),
        actions: [
          IconButton(
            icon: Icon(_showReplay ? Icons.list : Icons.replay),
            tooltip: _showReplay
                ? localizations.showEventsListTooltip
                : localizations.showReplayStateTooltip,
            onPressed: _toggleViewMode,
          ),
          if (!_showReplay)
            IconButton(
              icon: Icon(
                _isDescending ? Icons.arrow_downward : Icons.arrow_upward,
              ),
              tooltip: localizations.toggleSortOrderTooltip,
              onPressed: _toggleSortOrder,
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(_error!, textAlign: TextAlign.center),
        ),
      );
    }

    if (_showReplay) {
      return _buildReplayView();
    } else {
      return _buildEventsListView();
    }
  }

  Widget _buildEventsListView() {
    if (_records == null || _records!.isEmpty) {
      return Center(
        // child: Text(HyttaHubLocalizations.of(context)!.noEventsFound),
        child: Text("noEventsFound - needs localization"),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: _records!.length,
      itemBuilder: (context, index) {
        final record = _records![index];
        final jsonMap = record.toProto3Json();
        const jsonEncoder = JsonEncoder.withIndent('  ');
        final jsonString = jsonEncoder.convert(jsonMap);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: _EventCardContent(
              version: widget.config.getVersion(record),
              isoDate: widget.config.getIsoDate(record),
              jsonString: jsonString,
            ),
          ),
        );
      },
    );
  }

  Widget _buildReplayView() {
    if (_base64Events == null || _base64Events!.isEmpty) {
      return Center(
        child: Text(HyttaHubLocalizations.of(context)!.noEventsToReplay),
      );
    }

    final replayState = widget.config.replay(_base64Events!);

    final jsonMap = replayState.toProto3Json();
    const jsonEncoder = JsonEncoder.withIndent('  ');
    final jsonString = jsonEncoder.convert(jsonMap);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: _JsonViewer(jsonString: jsonString),
    );
  }
}

class _EventCardContent extends StatelessWidget {
  const _EventCardContent({
    required this.version,
    required this.isoDate,
    required this.jsonString,
  });

  final int version;
  final String isoDate;
  final String jsonString;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          HyttaHubLocalizations.of(context)!.eventVersion(version),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(isoDate, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 12),
        _JsonViewer(jsonString: jsonString),
      ],
    );
  }
}

class _JsonViewer extends StatelessWidget {
  const _JsonViewer({required this.jsonString});

  final String jsonString;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0)),
      child: SelectableText(
        jsonString,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
      ),
    );
  }
}
