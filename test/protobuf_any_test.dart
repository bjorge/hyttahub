import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/proto/account_replay_bloc.pb.dart';

import 'package:hyttahub/proto/bloom_filter.pb.dart';
import 'package:hyttahub/utilities/pack_any.dart';

void main() {
  test('test pack any and unpack', () {
    final myMessage = BloomFilter()..size = 5;
    final packed = packAny(myMessage);

    final unpackedBloomFilter = unpackAny(packed, () => BloomFilter());
    expect(unpackedBloomFilter!.size, 5);

    final unpackedAccountReplayBlocState = unpackAny(
      packed,
      () => AccountReplayBlocState(),
    );
    expect(unpackedAccountReplayBlocState, isNull);
  });
}
