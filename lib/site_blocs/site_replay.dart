// Copyright (c) 2025 bjorge

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pbenum.dart';
import 'package:protobuf/protobuf.dart';

// update the passed in replay state with the new events
// note: after the replay, set the approprate state
SiteReplayBlocState siteReplay(
  SiteReplayBlocState siteReplay,
  Map<int, String> base64Events,
) {
  final lastVersion = siteReplay.events.keys.fold(
    0,
    (previousValue, element) =>
        element > previousValue ? element : previousValue,
  );

  final eventKeys = base64Events.keys.where((key) => key > lastVersion).toList()
    ..sort();

  if (eventKeys.isEmpty) {
    return siteReplay;
  }

  final replay = siteReplay.deepCopy();

  replay.events.addAll(base64Events);

  if (kDebugMode) {
    print('Replaying ${eventKeys.length} events');
    print(base64Events.values.join('\n'));
    print(base64Events.keys.join('\n'));
  }

  for (int i = 0; i < eventKeys.length; i++) {
    final eventVersion = eventKeys[i];
    final base64Event = base64Events[eventVersion];
    final event = SiteEvent.fromBuffer(base64Decode(base64Event!));

    if (event.hasNewSite()) {
      replay.name = event.newSite.siteName;
      replay.members[eventVersion] = SiteReplayBlocState_Member(
        name: event.newSite.memberName,
        admin: true,
      );
    }

    if (event.hasAddMember()) {
      replay.members[eventVersion] = SiteReplayBlocState_Member(
        name: event.addMember.memberName,
        admin: event.addMember.admin,
      );
    }

    // the member has left the site
    if (event.hasLeaveSite()) {
      final memberId = event.leaveSite.memberId;
      if (replay.members.containsKey(memberId)) {
        replay.removedMembers[memberId] = replay.members[memberId]!.deepCopy();
        replay.members.remove(memberId);
      }
    }

    // the member has been removed from the site
    if (event.hasRemoveMember()) {
      final memberId = event.removeMember.memberId;
      if (replay.members.containsKey(memberId)) {
        replay.removedMembers[memberId] = replay.members[memberId]!.deepCopy();
        replay.members.remove(memberId);
      }
    }

    if (event.hasRestoreMember()) {
      final memberId = event.restoreMember.memberId;
      if (replay.removedMembers.containsKey(memberId)) {
        // check for duplicate member names
        // if (replay.members.values
        //     .any((member) => member.name == event.restoreMember.memberName)) {
        //   return replay..state = CommonReplayStateEnum.error;
        // }

        replay.members[memberId] = SiteReplayBlocState_Member(
          name: event.restoreMember.memberName,
          admin: event.restoreMember.admin,
        );
        replay.removedMembers.remove(memberId);
      }
    }

    if (event.hasUpdateMember()) {
      final memberId = event.updateMember.memberId;
      if (replay.members.containsKey(memberId)) {
        // check for duplicate member names
        // if (replay.members.entries.any((entry) =>
        //     entry.key != memberId &&
        //     entry.value.name == event.updateMember.memberName)) {
        //   return replay..state = CommonReplayStateEnum.error;
        // }

        replay.members[memberId]!.name = event.updateMember.memberName;
        replay.members[memberId]!.admin = event.updateMember.admin;
      }
    }

    if (event.hasUpdateSiteName()) {
      replay.name = event.updateSiteName.name;
    }

    if (event.hasImportEvent()) {
      // update the site name if provided in the import event
      if (event.importEvent.hasSiteName()) {
        replay.name = event.importEvent.siteName;
      } else {
        // default - mark imported sites with ~...~
        replay.name = '~${replay.name}~';
      }

      // the import does not assign any members except the author
      final unassignedMembers = replay.members.entries
          .where((entry) => entry.key != event.author)
          .map((entry) => entry.key)
          .toList();

      // so remove all unassigned members
      for (final memberId in unassignedMembers) {
        replay.removedMembers[memberId] = replay.members[memberId]!.deepCopy();
        replay.members.remove(memberId);
      }
    }

    // update the app state last by calling the user-defined replay function
    if (HyttaHubOptions.appReplay == null) {
      throw Exception(
        'HyttaHubOptions.appReplay must be set by the application.',
      );
    }
    replay.appBlocState = HyttaHubOptions.appReplay!(replay, event);

    replay.state = CommonReplayStateEnum.ok;
  }

  return replay;
}
