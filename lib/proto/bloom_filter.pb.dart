// This is a generated file - do not edit.
//
// Generated from bloom_filter.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class BloomFilter extends $pb.GeneratedMessage {
  factory BloomFilter({
    $core.List<$core.int>? bitArray,
    $core.int? size,
    $core.int? hashCount,
  }) {
    final result = create();
    if (bitArray != null) result.bitArray = bitArray;
    if (size != null) result.size = size;
    if (hashCount != null) result.hashCount = hashCount;
    return result;
  }

  BloomFilter._();

  factory BloomFilter.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BloomFilter.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BloomFilter',
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'bitArray', $pb.PbFieldType.OY)
    ..aI(2, _omitFieldNames ? '' : 'size')
    ..aI(3, _omitFieldNames ? '' : 'hashCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BloomFilter clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BloomFilter copyWith(void Function(BloomFilter) updates) =>
      super.copyWith((message) => updates(message as BloomFilter))
          as BloomFilter;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BloomFilter create() => BloomFilter._();
  @$core.override
  BloomFilter createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BloomFilter getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BloomFilter>(create);
  static BloomFilter? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get bitArray => $_getN(0);
  @$pb.TagNumber(1)
  set bitArray($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBitArray() => $_has(0);
  @$pb.TagNumber(1)
  void clearBitArray() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get size => $_getIZ(1);
  @$pb.TagNumber(2)
  set size($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get hashCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set hashCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHashCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearHashCount() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
