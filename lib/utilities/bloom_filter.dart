// Copyright (c) 2025 bjorge

import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

const defaultBloomFilterSize = 240;
const defaultBloomFilterHashCount = 7;

class BloomFilterProcessor {
  final int size; // Number of bits (m)
  final int hashCount; // Number of hash functions (k)
  final Uint8List bitArray;

  BloomFilterProcessor({
    required this.size,
    required this.hashCount,
    Uint8List? bitArray,
  }) : bitArray = bitArray ?? Uint8List((size / 8).ceil());

  void add(String item) {
    for (var i = 0; i < hashCount; i++) {
      final hash = _hash(item, i);
      final bitIndex = hash % size;
      _setBit(bitIndex);
    }
  }

  void addAll(List<String> items) {
    for (final item in items) {
      add(item);
    }
  }

  bool mightContain(String item) {
    for (var i = 0; i < hashCount; i++) {
      final hash = _hash(item, i);
      final bitIndex = hash % size;
      if (!_getBit(bitIndex)) return false;
    }
    return true; // Could be in the set (false positive possible)
  }

  void _setBit(int bitIndex) {
    final byteIndex = bitIndex ~/ 8;
    final bitMask = 1 << (bitIndex % 8);
    bitArray[byteIndex] |= bitMask;
  }

  bool _getBit(int bitIndex) {
    final byteIndex = bitIndex ~/ 8;
    final bitMask = 1 << (bitIndex % 8);
    return (bitArray[byteIndex] & bitMask) != 0;
  }

  int _hash(String input, int seed) {
    final bytes = utf8.encode('$seed:$input');
    final digest = sha256.convert(bytes);
    final byteList = Uint8List.fromList(digest.bytes);
    return byteList.buffer.asByteData().getUint32(0); // 32-bit hash
  }
}
