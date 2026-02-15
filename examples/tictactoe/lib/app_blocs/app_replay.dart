// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:protobuf/protobuf.dart';
import 'package:tictactoe/app_blocs/app_replay_bloc.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/utilities/app_wrapper_util.dart';

AppReplayBlocState appReplay(
  AppReplayBlocState appBlocState,
  Map<int, String> base64Events,
) {
  final lastVersion = appBlocState.lastVersion;

  final eventKeys =
      base64Events.keys.where((key) => key > lastVersion).toList()..sort();

  if (eventKeys.isEmpty) {
    return appBlocState;
  }

  // ignore: deprecated_member_use, deprecated_member_use_from_same_package
  final replay = appBlocState.deepCopy();

  // Initialize board if empty
  if (replay.board.isEmpty) {
    replay.board.addAll(List.filled(9, 0));
    replay.turn = 1; // X always starts
    replay.winner = 0;
    replay.status = GameStatus.notStarted;
    replay.vsBot = false;
  }

  replay.events.addAll(base64Events);

  for (int i = 0; i < eventKeys.length; i++) {
    final eventVersion = eventKeys[i];
    final base64Event = base64Events[eventVersion];
    final event = SiteEvent.fromBuffer(base64Decode(base64Event!));

    if (event.hasAppEvent()) {
      final appEvent = unpackAppEventWrapper(event.appEvent, AppEvent.create);

      if (appEvent.hasMove()) {
        final move = appEvent.move;
        final index = move.y * 3 + move.x;

        if (index >= 0 && index < 9 && replay.board[index] == 0) {
          if (replay.winner == 0 && replay.status == GameStatus.playing) {
            replay.board[index] = move.player;
            // Toggle turn
            replay.turn = (move.player == 1) ? 2 : 1;
            _checkWinner(replay);
            // Player 1 is user, Player 2 is AI
          }
        }
      } else if (appEvent.hasStartGame()) {
        replay.status = GameStatus.playing;
        replay.vsBot = appEvent.startGame.vsBot;
      } else if (appEvent.hasPlayAgain()) {
        replay.board.fillRange(0, 9, 0);
        replay.turn = 1;
        replay.winner = 0;
        replay.status = GameStatus.playing;
        // vsBot is preserved from the previous game session
      }
    }
  }

  return replay;
}

void _checkWinner(AppReplayBlocState state) {
  final board = state.board;
  final wins = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // cols
    [0, 4, 8], [2, 4, 6], // diags
  ];

  for (var line in wins) {
    final a = board[line[0]];
    final b = board[line[1]];
    final c = board[line[2]];

    if (a != 0 && a == b && a == c) {
      state.winner = a;
      state.status = GameStatus.gameOver;
      return;
    }
  }

  if (!board.contains(0)) {
    state.winner = 3; // Draw
    state.status = GameStatus.gameOver;
  }
}
