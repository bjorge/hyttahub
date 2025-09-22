// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/proto/account_replay_bloc.pb.dart';
import 'package:hyttahub/proto/account_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pbenum.dart';
import 'package:protobuf/protobuf.dart';

// update the passed in replay state with the new events
// note: after the replay, set the approprate state
AccountReplayBlocState accountReplay(
  AccountReplayBlocState accountReplay,
  Map<int, String> base64Events,
) {
  // if (kDebugMode) {
  //   print(
  //     "AccountReplay: accountReplay called with state: ${accountReplay.toProto3Json()}",
  //   );
  // }
  // if (kDebugMode) {
  //   print("AccountReplay: accountReplay called with events: $base64Events");
  // }

  final lastVersion = accountReplay.events.keys.fold(
    0,
    (previousValue, element) =>
        element > previousValue ? element : previousValue,
  );

  final eventKeys = base64Events.keys.where((key) => key > lastVersion).toList()
    ..sort();

  if (eventKeys.isEmpty) {
    // if (kDebugMode) {
    //   print(
    //     "AccountReplay: accountReplay no new events to process, returning current state: ${accountReplay.toProto3Json()}",
    //   );
    // }

    return accountReplay;
  }

  final replay = accountReplay.deepCopy();

  replay.events.addAll(base64Events);

  for (int i = 0; i < eventKeys.length; i++) {
    final eventVersion = eventKeys[i];
    final base64Event = base64Events[eventVersion];
    final event = AccountEvent.fromBuffer(base64Decode(base64Event!));

    // if (kDebugMode) {
    //   print(
    //     "AccountReplay: processing event version: $eventVersion, event: ${event.toProto3Json()}",
    //   );
    // }

    if (event.hasInitialEvent()) {
      if (event.initialEvent.hasTerms()) {
        if (event.initialEvent.terms.hasTermsVersion()) {
          replay.termsVersion = event.initialEvent.terms.termsVersion;
        }
        if (event.initialEvent.terms.hasPolicyVersion()) {
          replay.privacyVersion = event.initialEvent.terms.policyVersion;
        }
      }
    }

    if (event.hasTerms()) {
      if (event.terms.hasTermsVersion()) {
        replay.termsVersion = event.terms.termsVersion;
      }
      if (event.terms.hasPolicyVersion()) {
        replay.privacyVersion = event.terms.policyVersion;
      }
      replay.termsVersion = event.terms.termsVersion;
    }

    if (event.hasCreateSite()) {
      if (!replay.sitesIds.contains(event.createSite)) {
        replay.sitesIds.add(event.createSite);
      }
    }

    if (event.hasJoinSite()) {
      if (!replay.sitesIds.contains(event.joinSite)) {
        replay.sitesIds.add(event.joinSite);
      }
    }

    if (event.hasRemoveSite()) {
      replay.sitesIds.remove(event.removeSite);
    }

    if (event.hasLeaveSite()) {
      replay.sitesIds.remove(event.leaveSite);
    }

    replay.state = CommonReplayStateEnum.ok;
  }

  return replay;
}
