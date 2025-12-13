// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:tictactoe/proto/app_events.pb.dart';
import 'package:tictactoe/proto/app_replay_bloc.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/utilities/app_wrapper_util.dart';

AppReplayBlocState appReplay(
  AppReplayBlocState appBlocState,
  Map<int, String> base64Events,
) {
  final lastVersion = appBlocState.events.keys.fold(
    0,
    (previousValue, element) =>
        element > previousValue ? element : previousValue,
  );

  final eventKeys =
      base64Events.keys.where((key) => key > lastVersion).toList()..sort();

  if (eventKeys.isEmpty) {
    return appBlocState;
  }

  // ignore: deprecated_member_use, deprecated_member_use_from_same_package
  final replay = appBlocState.clone();

  // Initialize board if empty
  if (replay.board.isEmpty) {
    replay.board.addAll(List.filled(9, 0));
    replay.turn = 1; // X always starts
    replay.winner = 0;
  }

  replay.events.addAll(base64Events);
  var lastMoveWasUser = false;

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
          if (replay.winner == 0) {
            replay.board[index] = move.player;
            // Toggle turn
            replay.turn = (move.player == 1) ? 2 : 1;
            _checkWinner(replay);
            lastMoveWasUser = true;
          }
        }
      }
    }
  }

  // Auto-Opponent Logic (Simple Random Move)
  // If game is active, it's O's turn (2), and the last processed event was a user move,
  // we hallucinate a move for O.
  // NOTE: This assumes Player 1 (X) is the user and Player 2 (O) is the auto-opponent.
  if (replay.winner == 0 && replay.turn == 2 && lastMoveWasUser) {
    // Find empty spots
    final emptyIndices = <int>[];
    for (int i = 0; i < 9; i++) {
      if (replay.board[i] == 0) {
        emptyIndices.add(i);
      }
    }

    if (emptyIndices.isNotEmpty) {
      // Deterministic choice for validation stability
      final choice = emptyIndices.first;
      replay.board[choice] = 2; // O moves
      replay.turn = 1; // Back to X
      _checkWinner(replay);
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
      return;
    }
  }

  if (!board.contains(0)) {
    state.winner = 3; // Draw
  }
}
