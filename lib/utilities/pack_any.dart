import 'package:hyttahub/proto/any.pb.dart';
import 'package:protobuf/protobuf.dart';

/// Packs a message into an Any.
Any packAny(GeneratedMessage msg) {
  return Any()
    ..typeUrl = 'type.hyttehub.com/${msg.info_.qualifiedMessageName}'
    ..value = msg.writeToBuffer();
}

/// Unpacks an Any into a target message type (e.g. MyMessage()).
/// Returns null if typeUrl doesn't match.
T? unpackAny<T extends GeneratedMessage>(Any any, T Function() create) {
  final message = create();
  final expectedUrl = 'type.hyttehub.com/${message.info_.qualifiedMessageName}';
  if (any.typeUrl != expectedUrl) {
    // print('Type mismatch: expected $expectedUrl, got ${any.typeUrl}');
    return null;
  }
  message.mergeFromBuffer(any.value);
  return message;
}
