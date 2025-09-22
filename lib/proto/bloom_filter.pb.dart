//
//  Generated code. Do not modify.
//  source: bloom_filter.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class BloomFilter extends $pb.GeneratedMessage {
  factory BloomFilter({
    $core.List<$core.int>? bitArray,
    $core.int? size,
    $core.int? hashCount,
  }) {
    final $result = create();
    if (bitArray != null) {
      $result.bitArray = bitArray;
    }
    if (size != null) {
      $result.size = size;
    }
    if (hashCount != null) {
      $result.hashCount = hashCount;
    }
    return $result;
  }
  BloomFilter._() : super();
  factory BloomFilter.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BloomFilter.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BloomFilter', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'bitArray', $pb.PbFieldType.OY)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'size', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'hashCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BloomFilter clone() => BloomFilter()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BloomFilter copyWith(void Function(BloomFilter) updates) => super.copyWith((message) => updates(message as BloomFilter)) as BloomFilter;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BloomFilter create() => BloomFilter._();
  BloomFilter createEmptyInstance() => create();
  static $pb.PbList<BloomFilter> createRepeated() => $pb.PbList<BloomFilter>();
  @$core.pragma('dart2js:noInline')
  static BloomFilter getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BloomFilter>(create);
  static BloomFilter? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get bitArray => $_getN(0);
  @$pb.TagNumber(1)
  set bitArray($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBitArray() => $_has(0);
  @$pb.TagNumber(1)
  void clearBitArray() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get size => $_getIZ(1);
  @$pb.TagNumber(2)
  set size($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearSize() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get hashCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set hashCount($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHashCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearHashCount() => clearField(3);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
