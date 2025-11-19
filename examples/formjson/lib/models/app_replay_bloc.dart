import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_replay_bloc.freezed.dart';
part 'app_replay_bloc.g.dart';

@freezed
class AppReplayBlocState with _$AppReplayBlocState {
  const factory AppReplayBlocState({
    String? text,
  }) = _AppReplayBlocState;

  factory AppReplayBlocState.fromJson(Map<String, dynamic> json) =>
      _$AppReplayBlocStateFromJson(json);
}
