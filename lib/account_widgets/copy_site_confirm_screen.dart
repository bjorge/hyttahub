// Copyright (c) 2025 bjorge

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';

import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/storage/hyttahub_storage_factory.dart';
import 'package:hyttahub/collection_paths.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/site_widgets/site_submit_button.dart';
import 'package:hyttahub/site_blocs/site_submit_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:intl/intl.dart';

class CopySiteConfirmScreen extends StatefulWidget {
  const CopySiteConfirmScreen({super.key, required this.siteId});

  final String siteId;

  @override
  State<CopySiteConfirmScreen> createState() => _CopySiteConfirmScreenState();
}

class _CopySiteConfirmScreenState extends State<CopySiteConfirmScreen> {
  late final SiteReplayBloc _siteReplayBloc;
  late final SiteSubmitBloc _siteSubmitBloc;
  final _formKey = GlobalKey<FormState>();
  int? _selectedVersion;
  int? _authorId;
  final Map<int, DateTime> _eventDates = {};

  @override
  void initState() {
    super.initState();
    _siteReplayBloc = SiteReplayBloc(widget.siteId);
    _siteReplayBloc.add(CommonReplayBlocEvent(listen: true));
    
    _siteSubmitBloc = SiteSubmitBloc(
      widget.siteId,
      SubmitSiteEvent(
        authorEmail: context.read<AuthBloc>().state.email,
        event: SiteEvent(version: 999999999), 
        isMarkForCopy: true,
      ),
    );
    
    _fetchAuthorId();
    _fetchEventDates();
  }

  Future<void> _fetchEventDates() async {
    final storageType = HyttaHubOptions.implementation?.storage ?? StorageEnum.cloud;
    final storage = HyttaHubStorageFactory.getStorage(storageType);
    
    try {
      final docs = await storage.getCollection(
        collectionSiteEventsPath(widget.siteId),
      );

      final dates = <int, DateTime>{};
      for (final data in docs) {
        if (data case {docVersion: int version, docTimeStamp: dynamic timestampValue}) {
          try {
            if (timestampValue is DateTime) {
               dates[version] = timestampValue;
            } else if (timestampValue is String) {
               dates[version] = DateTime.parse(timestampValue);
            } else if (timestampValue != null &&
                timestampValue.runtimeType.toString() == 'Timestamp') {
              dates[version] = (timestampValue as dynamic).toDate();
            }
          } catch (e) {
            // keep going
          }
        }
      }
      
      if (mounted) {
        setState(() {
          _eventDates.addAll(dates);
        });
      }
    } catch (e) {
      // Ignored: failure fetching dates just means we won't show them
    }
  }

  Future<void> _fetchAuthorId() async {
    final email = context.read<AuthBloc>().state.email;
    final storageType = HyttaHubOptions.implementation?.storage ?? StorageEnum.cloud;
    final storage = HyttaHubStorageFactory.getStorage(storageType);
    
    try {
      final userDoc = await storage.getDocument(collectionSiteUsersPath(widget.siteId), email);
      if (userDoc != null && mounted) {
        setState(() {
          _authorId = userDoc[docUserId] as int?;
        });
      }
    } catch (e) {
      // Ignored: fallback logic applies
    }
  }

  @override
  void dispose() {
    _siteReplayBloc.close();
    _siteSubmitBloc.close();
    super.dispose();
  }

  String _getEventDescription(BuildContext context, SiteEvent event) {
    if (event.hasNewSite()) return HyttaHubLocalizations.of(context)!.eventSiteCreated(event.newSite.siteName);
    if (event.hasAddMember()) return HyttaHubLocalizations.of(context)!.eventAddedMember(event.addMember.memberName);
    if (event.hasUpdateSiteName()) return HyttaHubLocalizations.of(context)!.eventRenamedSite(event.updateSiteName.name);
    if (event.hasRemoveMember()) return HyttaHubLocalizations.of(context)!.eventRemovedMember(event.removeMember.memberId);
    if (event.hasLeaveSite()) return HyttaHubLocalizations.of(context)!.eventMemberLeft(event.leaveSite.memberId);
    if (event.hasRestoreMember()) return HyttaHubLocalizations.of(context)!.eventRestoredMember(event.restoreMember.memberName);
    if (event.hasUpdateMember()) return HyttaHubLocalizations.of(context)!.eventUpdatedMember(event.updateMember.memberName);
    if (event.hasImportEvent()) return HyttaHubLocalizations.of(context)!.eventSiteCopied;
    if (event.hasAppEvent()) {
      if (HyttaHubOptions.appEventDescriptionBuilder != null) {
        return HyttaHubOptions.appEventDescriptionBuilder!(context, event);
      }
      return HyttaHubLocalizations.of(context)!.eventAppSpecific;
    }
    return HyttaHubLocalizations.of(context)!.eventUnknown;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _siteReplayBloc),
        BlocProvider.value(value: _siteSubmitBloc),
      ],
      child: BlocListener<SiteSubmitBloc, BaseSubmitState<SubmitSiteEvent>>(
        listener: (context, state) {
          if (state.submissionState.state == CommonSubmitBlocState_State.success) {
            Navigator.pop(context);
            Navigator.pop(context);
          } else if (state.submissionState.state == CommonSubmitBlocState_State.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Error copying site"),
                duration: Duration(seconds: 5),
              ),
            );
          }
        },
        child: BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
          builder: (context, siteState) {
            if (siteState.state == CommonReplayStateEnum.hydrating) {
              return Scaffold(
              appBar: AppBar(
                title: Text(HyttaHubLocalizations.of(context)!.copySiteConfirmTitle),
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          final decodedEvents = <int, SiteEvent>{};
          for (final entry in siteState.events.entries) {
            decodedEvents[entry.key] = SiteEvent.fromBuffer(base64Decode(entry.value));
          }

          final sortedVersions = decodedEvents.keys.toList()..sort((a, b) => b.compareTo(a));
          if (_selectedVersion == null && sortedVersions.isNotEmpty) {
            _selectedVersion = sortedVersions.first;
            // Initialize payload with the default selected version
            final payload = _siteSubmitBloc.state.payload!.deepCopy();
            payload.markForCopyUpToVersion = _selectedVersion!;
            _siteSubmitBloc.add(
              SiteEventSubmission(
                submission: CommonSubmitBlocEvent(
                  updatedPayload: base64Encode(payload.writeToBuffer()),
                )..freeze(),
              ),
            );
          }

          int? oldestAllowedVersion;
          if (_authorId != null) {
              for (final version in sortedVersions.reversed) {
                final event = decodedEvents[version]!;
                if (event.hasNewSite() && event.author == _authorId) {
                  oldestAllowedVersion = version;
                  break;
                }
                if (event.hasAddMember() && version == _authorId) {
                  oldestAllowedVersion = version;
                  break;
                }
                if (event.hasRestoreMember() && event.restoreMember.memberId == _authorId) {
                  oldestAllowedVersion = version;
                }
              }
          }

          final displayedVersions = sortedVersions.where((version) => oldestAllowedVersion == null || version >= oldestAllowedVersion).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text(HyttaHubLocalizations.of(context)!.copySiteConfirmTitle),
              actions: [
                SiteSubmitIconButton(formKey: _formKey),
              ],
            ),
            body: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(HyttaHubLocalizations.of(context)!.copySiteConfirmMessage),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: displayedVersions.length,
                    itemBuilder: (context, index) {
                      final version = displayedVersions[index];
                      final isLatest = index == 0;
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isLatest)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Text(
                                "Latest Version",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            )
                          else if (index == 1)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Text(
                                "Older Versions",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                          CheckboxListTile(
                            value: _selectedVersion == version,
                            onChanged: (bool? value) {
                              if (value == true) {
                                setState(() {
                                  _selectedVersion = version;
                                });
                                final payload = _siteSubmitBloc.state.payload!.deepCopy();
                                payload.markForCopyUpToVersion = version;
                                _siteSubmitBloc.add(
                                  SiteEventSubmission(
                                    submission: CommonSubmitBlocEvent(
                                      updatedPayload: base64Encode(payload.writeToBuffer()),
                                    )..freeze(),
                                  ),
                                );
                              }
                            },
                            title: Text("Version $version"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_getEventDescription(context, decodedEvents[version]!)),
                                if (_eventDates.containsKey(version))
                                  Text(
                                    DateFormat.yMMMd(Localizations.localeOf(context).languageCode).add_jm().format(_eventDates[version]!),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7)),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  ),
);
  }
}
