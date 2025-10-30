// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/service_events.pb.dart';
import 'package:hyttahub/proto/service_replay_bloc.pb.dart';
import 'package:protobuf/protobuf.dart';

// update the passed in replay state with the new events
// note: after the replay, set the approprate state
ServiceReplayBlocState serviceReplay(
  ServiceReplayBlocState serviceReplay,
  Map<int, String> base64Events,
) {
  // if (kDebugMode) {
  //   print(
  //     "ServiceReplay: serviceReplay called with state: ${serviceReplay.toProto3Json()}",
  //   );
  // }
  // if (kDebugMode) {
  //   print("ServiceReplay: serviceReplay called with events: $base64Events");
  // }

  final lastVersion = serviceReplay.events.keys.fold(
    0,
    (previousValue, element) =>
        element > previousValue ? element : previousValue,
  );

  final eventKeys = base64Events.keys.where((key) => key > lastVersion).toList()
    ..sort();

  if (eventKeys.isEmpty) {
    // if (kDebugMode) {
    //   print(
    //     "ServiceReplay: serviceReplay no new events to process, returning current state: ${serviceReplay.toProto3Json()}",
    //   );
    // }

    return serviceReplay;
  }

  final replay = serviceReplay.deepCopy();

  replay.events.addAll(base64Events);

  for (int i = 0; i < eventKeys.length; i++) {
    final eventVersion = eventKeys[i];
    final base64Event = base64Events[eventVersion];
    final event = ServiceEvent.fromBuffer(base64Decode(base64Event!));

    if (event.hasInitialEvent()) {
      replay.serviceAdmins[eventVersion] = ServiceAdmin(
        alias: event.initialEvent.alias,
      );
      replay.instance = event.initialEvent.instance;
      replay.filter = event.initialEvent.filter;

      // setup some default values for the first event
      replay.terms = "Terms of Service";
      replay.termsVersion = 1;
      replay.privacy = "Privacy Policy";
      replay.privacyVersion = 1;

      replay.minVersion = 1;
      replay.serviceUnavailable = false;

      replay.appName = event.initialEvent.appName;
      replay.appId = event.initialEvent.appId;
    }

    if (event.hasAddServiceAdmin()) {
      replay.serviceAdmins[eventVersion] = ServiceAdmin(
        alias: event.addServiceAdmin.alias,
      );
      if (event.addServiceAdmin.hasFilter()) {
        replay.filter = event.addServiceAdmin.filter;
      }
    }

    if (event.hasRemoveServiceAdmin()) {
      final admin = replay.serviceAdmins.remove(event.removeServiceAdmin.id);
      if (admin != null) {
        replay.removedServiceAdmins[event.removeServiceAdmin.id] = admin;
      }
      if (event.removeServiceAdmin.hasFilter()) {
        replay.filter = event.removeServiceAdmin.filter;
      }
    }

    if (event.hasUpdateServiceAdmin()) {
      replay.serviceAdmins[event.updateServiceAdmin.id] = ServiceAdmin(
        alias: event.updateServiceAdmin.alias,
      );

      if (event.updateServiceAdmin.hasFilter()) {
        replay.filter = event.updateServiceAdmin.filter;
      }
    }

    if (event.hasRestoreServiceAdmin()) {
      final admin = replay.removedServiceAdmins.remove(
        event.restoreServiceAdmin.id,
      );
      if (admin != null) {
        replay.serviceAdmins[event.restoreServiceAdmin.id] = ServiceAdmin(
          alias: event.restoreServiceAdmin.alias,
        );
      }
      if (event.restoreServiceAdmin.hasFilter()) {
        replay.filter = event.restoreServiceAdmin.filter;
      }
    }

    if (event.hasBetaUsersFilter()) {
      replay.betaUsersFilter = event.betaUsersFilter;
    }

    if (event.hasMinVersion()) {
      replay.minVersion = event.minVersion.value;
    }

    if (event.hasServiceStatus()) {
      replay.serviceUnavailable = event.serviceStatus.unavailable;
    }

    if (event.hasTerms()) {
      replay.terms = event.terms.content;
      replay.termsVersion = eventVersion;
    }

    if (event.hasPrivacy()) {
      replay.privacy = event.privacy.content;
      replay.privacyVersion = eventVersion;
    }

    replay.state = CommonReplayStateEnum.ok;
  }

  return replay;
}
