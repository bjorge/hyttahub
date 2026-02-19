// Copyright (c) 2025 bjorge

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/service_blocs/cloud_functions_bloc.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/storage/hyttahub_storage_factory.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';

class CopySiteConfirmScreen extends StatefulWidget {
  const CopySiteConfirmScreen({super.key, required this.siteId});

  final String siteId;

  @override
  State<CopySiteConfirmScreen> createState() => _CopySiteConfirmScreenState();
}

class _CopySiteConfirmScreenState extends State<CopySiteConfirmScreen> {
  late final SiteReplayBloc _siteReplayBloc;
  bool _isProcessing = false;
  int? _selectedVersion;
  int? _authorId;

  @override
  void initState() {
    super.initState();
    _siteReplayBloc = SiteReplayBloc(widget.siteId);
    _siteReplayBloc.add(CommonReplayBlocEvent(listen: true));
    
    _fetchAuthorId();
  }

  Future<void> _fetchAuthorId() async {
    final email = context.read<AuthBloc>().state.email;
    final storageType = HyttaHubOptions.implementation?.storage ?? StorageEnum.cloud;
    final storage = HyttaHubStorageFactory.getStorage(storageType);
    
    try {
      final userDoc = await storage.getDocument(firebaseSiteUsersPath(widget.siteId), email);
      if (userDoc != null && mounted) {
        setState(() {
          _authorId = userDoc[fbUserId] as int?;
        });
      }
    } catch (e) {
      // Ignored: fallback logic applies
    }
  }

  @override
  void dispose() {
    _siteReplayBloc.close();
    super.dispose();
  }

  void _copySite() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      await context.read<CloudFunctionsBloc>().copySite(
        widget.siteId,
        upToVersion: _selectedVersion,
      );

      if (!mounted) return;
      
      setState(() {
        _isProcessing = false;
      });
      
      // Navigate back out of confirm and sites loops
      Navigator.pop(context);
      Navigator.pop(context);
      
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error copying site: $error"),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  String _getEventDescription(SiteEvent event) {
    if (event.hasNewSite()) return "Site Created: ${event.newSite.siteName}";
    if (event.hasAddMember()) return "Added Member: ${event.addMember.memberName}";
    if (event.hasUpdateSiteName()) return "Renamed Site: ${event.updateSiteName.name}";
    if (event.hasRemoveMember()) return "Removed Member (${event.removeMember.memberId})";
    if (event.hasLeaveSite()) return "Member Left (${event.leaveSite.memberId})";
    if (event.hasRestoreMember()) return "Restored Member: ${event.restoreMember.memberName}";
    if (event.hasUpdateMember()) return "Updated Member: ${event.updateMember.memberName}";
    if (event.hasImportEvent()) return "Site Copied/Imported";
    if (event.hasAppEvent()) return "App specific event";
    return "Unknown Event";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _siteReplayBloc,
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
          _selectedVersion ??= sortedVersions.isNotEmpty ? sortedVersions.first : null;

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
                if (_isProcessing)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: _selectedVersion != null ? _copySite : null,
                  ),
              ],
            ),
            body: Column(
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
                              }
                            },
                            title: Text("Version $version"),
                            subtitle: Text("Event: ${_getEventDescription(decodedEvents[version]!)}"),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
