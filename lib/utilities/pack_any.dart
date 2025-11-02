import 'dart:typed_data';

import 'package:hyttahub/proto/app_wrapper.pb.dart';
import 'package:protobuf/protobuf.dart';

AppReplayWrapper packAppReplayWrapper(Uint8List appState) {
  return AppReplayWrapper()..payload = appState;
}

AppEventWrapper packAppEventWrapper(Uint8List appEvent) {
  return AppEventWrapper()..payload = appEvent;
}

/// Unpacks an AppReplayWrapper into a target message type
T? unpackAppReplayWrapper<T extends GeneratedMessage>(
  AppReplayWrapper any,
  T Function() create,
) {
  final message = create();
  message.mergeFromBuffer(any.payload);
  return message;
}

/// Unpacks an AppEventWrapper into a target message type
T? unpackAppEventWrapper<T extends GeneratedMessage>(
  AppEventWrapper any,
  T Function() create,
) {
  final message = create();
  message.mergeFromBuffer(any.payload);
  return message;
}
