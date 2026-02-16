import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:tictactoe/app_blocs/app_replay_bloc.dart';

class TicTacToeBot {
  final AppReplayBloc appReplayBloc;
  final AppSubmitBloc appSubmitBloc;
  StreamSubscription? _subscription;
  bool _isThinking = false;

  TicTacToeBot({
    required this.appReplayBloc,
    required this.appSubmitBloc,
  });

  void start() {
    _subscription?.cancel();
    _subscription = appReplayBloc.stream.listen(_onStateChanged);
    // Trigger initial check in case we started mid-game
    _onStateChanged(appReplayBloc.state);
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }

  void _onStateChanged(AppReplayBlocState state) {
    if (state.status == GameStatus.playing &&
        state.vsBot &&
        state.turn == 2 &&
        state.winner == 0 &&
        !_isThinking) {
      _makeMove(state);
    }
  }

  Future<void> _makeMove(AppReplayBlocState state) async {
    _isThinking = true;

    // Simulate thinking delay
    await Future.delayed(const Duration(seconds: 1));

    // Re-check state after delay
    if (appReplayBloc.state.turn != 2 ||
        appReplayBloc.state.status != GameStatus.playing ||
        appReplayBloc.state.winner != 0) {
      _isThinking = false;
      return;
    }

    final emptyIndices = <int>[];
    for (int i = 0; i < 9; i++) {
      if (appReplayBloc.state.board[i] == 0) {
        emptyIndices.add(i);
      }
    }

    if (emptyIndices.isNotEmpty) {
      // Simple random move for now
      final choice = (emptyIndices..shuffle()).first;
      final x = choice % 3;
      final y = choice ~/ 3;

      final appEvent = AppEvent(
        move: AppEvent_Move(x: x, y: y, player: 2),
      );

      final email = GetIt.instance<AuthBloc>().state.email;
      final version = appReplayBloc.state.nextVersion;

      final submitEvent =
          SubmitAppEvent()
            ..appEvent = appEvent
            ..siteEvent = (SubmitAppEvent_SiteEvent()..version = version)
            ..authorEmail = email;

      // 1. Update payload and set form to valid
      appSubmitBloc.add(
        AppEventSubmission(
          updatedPayload: submitEvent,
          submission: CommonSubmitBlocEvent(isFormValid: true),
        ),
      );

      // 2. Trigger submission
      appSubmitBloc.add(
        AppEventSubmission(
          submission: CommonSubmitBlocEvent(
            submit: CommonSubmitBlocEvent_SubmitNow(),
          ),
        ),
      );
    }

    _isThinking = false;
  }
}
