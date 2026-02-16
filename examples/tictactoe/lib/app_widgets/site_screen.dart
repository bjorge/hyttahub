import 'package:tictactoe/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tictactoe/app_blocs/app_replay_bloc.dart';
import 'package:tictactoe/app_blocs/tictactoe_bot.dart';
import 'package:tictactoe/routers/app_routes.dart';
import 'package:tictactoe/utilities/handle_app_bloc_errors.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/common_blocs/allowed_emails_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:hyttahub/site_widgets/site_screen_settings_button.dart';
import 'package:hyttahub/common_widgets/layout.dart';

class SiteScreen extends StatefulWidget {
  const SiteScreen({super.key, required this.siteId});

  final String siteId;

  @override
  State<SiteScreen> createState() => _SiteScreenState();
}

class _SiteScreenState extends State<SiteScreen> {
  TicTacToeBot? _bot;

  @override
  void dispose() {
    _bot?.stop();
    super.dispose();
  }

  void _ensureBotRunning(BuildContext context) {
    if (_bot != null) return;

    final appReplayBloc = context.read<AppReplayBloc>();
    final appSubmitBloc = context.read<AppSubmitBloc>();

    _bot = TicTacToeBot(
      appReplayBloc: appReplayBloc,
      appSubmitBloc: appSubmitBloc,
    );
    _bot!.start();
  }

  @override
  Widget build(BuildContext context) {
    // Initial dummy payload for bloc creation
    final initialEvent =
        SubmitAppEvent()
          ..siteEvent = (SubmitAppEvent_SiteEvent()..version = 0)
          ..authorEmail = GetIt.instance<AuthBloc>().state.email;

    return BlocProvider<AppSubmitBloc>(
      create: (context) => AppSubmitBloc(widget.siteId, initialEvent),
      child: BlocBuilder<SiteAllowedEmailsBloc, AllowedEmailsBlocState>(
        key: Key('SiteAllowedEmailsBloc-site-screen-${widget.siteId}'),
        builder: (context, allowedEmailsState) {
          return BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
            builder: (context, siteState) {
              return Scaffold(
                appBar: AppBar(
                  leading: context.canPop() ? BackButton(onPressed: () => context.pop()) : null,
                  title: const ScreenTitle(),
                  actions: [
                    SiteSettingsButton(
                      siteId: widget.siteId,
                      appOptions: [
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                            context.push(
                              AppEventsDisplayRoute.fullPath(
                                siteId: widget.siteId,
                              ),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.app_appEventsOption,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                body: Center(
                  child: MultiBlocListener(
                    listeners: [
                      BlocListener<AppReplayBloc, AppReplayBlocState>(
                        listener: (context, appState) {
                          if (appState.status == GameStatus.playing &&
                              appState.vsBot) {
                            _ensureBotRunning(context);
                          } else if (appState.status == GameStatus.gameOver) {
                            _bot?.stop();
                            _bot = null;
                          }
                        },
                      ),
                      BlocListener<AppSubmitBloc, BaseSubmitState<SubmitAppEvent>>(
                        listener: (context, submitState) {
                          if (submitState.submissionState.state == CommonSubmitBlocState_State.error) {
                            final errorCode = submitState.submissionState.errorCode;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Submission Error: $errorCode')),
                            );
                          }
                        },
                      ),
                    ],
                    child: TicTacToeBoard(siteId: widget.siteId),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class TicTacToeBoard extends StatelessWidget {
  const TicTacToeBoard({super.key, required this.siteId});
  final String siteId;

  bool _isPendingBox(int index, BaseSubmitState<SubmitAppEvent>? submitState) {
    if (submitState == null ||
        submitState.submissionState.state !=
            CommonSubmitBlocState_State.submitting) {
      return false;
    }
    if (submitState.payload == null || !submitState.payload!.hasAppEvent()) {
      return false;
    }
    final appEvent = submitState.payload!.appEvent;
    if (!appEvent.hasMove()) return false;
    final move = appEvent.move;
    if (move.player == 2) return false;
    return (move.y * 3 + move.x) == index;
  }

  void _startGame(BuildContext context, SiteReplayBlocState siteState, AppReplayBlocState appState, bool vsBot) {
    final nextVersion = siteState.events.keys.fold<int>(0, (p, e) => e > p ? e : p) + 1;
    final submitEvent = SubmitAppEvent()
      ..appEvent = AppEvent(
        startGame: AppEvent_StartGame(
          vsBot: vsBot,
        ),
      )
      ..siteEvent = (SubmitAppEvent_SiteEvent()..version = nextVersion)
      ..authorEmail = GetIt.instance<AuthBloc>().state.email;

    final submitBloc = context.read<AppSubmitBloc>();
    // Step 1: Update the payload and mark form as valid
    submitBloc.add(
      AppEventSubmission(
        updatedPayload: submitEvent,
        submission: CommonSubmitBlocEvent(isFormValid: true),
      ),
    );
    // Step 2: Trigger the submission
    submitBloc.add(
      AppEventSubmission(
        submission: CommonSubmitBlocEvent(submit: CommonSubmitBlocEvent_SubmitNow()),
      ),
    );
  }

  void _playAgain(BuildContext context, SiteReplayBlocState siteState, AppReplayBlocState appState) {
    final nextVersion = siteState.events.keys.fold<int>(0, (p, e) => e > p ? e : p) + 1;
    final submitEvent = SubmitAppEvent()
      ..appEvent = AppEvent(
        playAgain: AppEvent_PlayAgain(),
      )
      ..siteEvent = (SubmitAppEvent_SiteEvent()..version = nextVersion)
      ..authorEmail = GetIt.instance<AuthBloc>().state.email;

    final submitBloc = context.read<AppSubmitBloc>();
    submitBloc.add(
      AppEventSubmission(
        updatedPayload: submitEvent,
        submission: CommonSubmitBlocEvent(isFormValid: true),
      ),
    );
    submitBloc.add(
      AppEventSubmission(
        submission: CommonSubmitBlocEvent(submit: CommonSubmitBlocEvent_SubmitNow()),
      ),
    );
  }

  String _getPlayerName(SiteReplayBlocState siteState, int playerId) {
    if (playerId == 0) return "Bot";
    return siteState.members[playerId]?.name ??
        siteState.removedMembers[playerId]?.name ??
        "Unknown ($playerId)";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSubmitBloc, BaseSubmitState<SubmitAppEvent>>(
      builder: (context, submitState) {
        return BlocBuilder<AppReplayBloc, AppReplayBlocState>(
          builder: (context, appState) {
            final errorWidget = handleAppReplayState(context, appState);
            if (errorWidget != null) return errorWidget;

            final board = appState.board;
            if (board.isEmpty) return const CircularProgressIndicator();

            final siteState = context.read<SiteReplayBloc>().state;
            final allowedEmailsState = context.read<SiteAllowedEmailsBloc>().state;
            final currentUserEmail = GetIt.instance<AuthBloc>().state.email;

            final myMemberId = allowedEmailsState.emails.entries
                .firstWhere(
                  (e) => e.key == currentUserEmail,
                  orElse: () => MapEntry("", AllowedEmailsBlocState_UserInfo()),
                )
                .value
                .userId;

            final xName = _getPlayerName(siteState, appState.xPlayerId);
            final oName = _getPlayerName(siteState, appState.oPlayerId);

            final isPlayerX = myMemberId == appState.xPlayerId;
            final isMyTurn = (appState.turn == 1 && isPlayerX) ||
                             (appState.turn == 2 && myMemberId == appState.oPlayerId);

            return CommonListViewLayout(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _PlayerChip(
                        name: xName,
                        symbol: "X",
                        isTurn: appState.status == GameStatus.playing && appState.turn == 1,
                        isMe: myMemberId == appState.xPlayerId,
                      ),
                      const SizedBox(width: 24),
                      _PlayerChip(
                        name: oName,
                        symbol: "O",
                        isTurn: appState.status == GameStatus.playing && appState.turn == 2,
                        isMe: myMemberId == appState.oPlayerId,
                      ),
                    ],
                  ),
                ),
                if (appState.status == GameStatus.gameOver)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: Text(
                        appState.winner == 3
                            ? "Draw!"
                            : "${appState.winner == 1 ? xName : oName} Wins!",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Center(
                  child: SizedBox(
                    width: 300,
                    height: 300,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        final cellValue = board[index];
                        final isPending = _isPendingBox(index, submitState);

                        int displayValue = cellValue;
                        bool gray = false;

                        if (isPending) {
                          displayValue =
                              submitState.payload!.appEvent.move.player;
                          gray = true;
                        }

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (appState.status == GameStatus.playing &&
                                cellValue == 0 &&
                                appState.winner == 0 &&
                                !isPending &&
                                isMyTurn &&
                                submitState.submissionState.state !=
                                    CommonSubmitBlocState_State.submitting) {
                              
                              final version = siteState.events.keys.fold<int>(0, (p, e) => e > p ? e : p) + 1;
                              final player = appState.turn;
                              final x = index % 3;
                              final y = index ~/ 3;

                              final move = AppEvent_Move(
                                x: x,
                                y: y,
                                player: player,
                              );
                              final appEvent = AppEvent(move: move);

                              final submitEvent =
                                  SubmitAppEvent()
                                    ..appEvent = appEvent
                                    ..siteEvent =
                                        (SubmitAppEvent_SiteEvent()
                                          ..version = version)
                                    ..authorEmail =
                                        currentUserEmail;

                              final submitBloc = context.read<AppSubmitBloc>();
                              // Step 1: Update the payload and mark form as valid
                              submitBloc.add(
                                AppEventSubmission(
                                  updatedPayload: submitEvent,
                                  submission: CommonSubmitBlocEvent(isFormValid: true),
                                ),
                              );
                              // Step 2: Trigger the submission
                              submitBloc.add(
                                AppEventSubmission(
                                  submission: CommonSubmitBlocEvent(
                                    submit: CommonSubmitBlocEvent_SubmitNow(),
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                displayValue == 1
                                    ? "X"
                                    : (displayValue == 2 ? "O" : ""),
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: gray
                                      ? Colors.grey
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (appState.status == GameStatus.notStarted)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: isPlayerX ? () => _startGame(context, siteState, appState, false) : null,
                          child: const Text("Start Multiplayer Game"),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: isPlayerX ? () => _startGame(context, siteState, appState, true) : null,
                          child: const Text("Start Bot Game"),
                        ),
                      ],
                    ),
                  ),
                if (appState.status == GameStatus.gameOver)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: isPlayerX ? () => _playAgain(context, siteState, appState) : null,
                        child: const Text("Play Again"),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _PlayerChip extends StatelessWidget {
  const _PlayerChip({
    required this.name,
    required this.symbol,
    required this.isTurn,
    required this.isMe,
  });

  final String name;
  final String symbol;
  final bool isTurn;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isTurn ? Theme.of(context).colorScheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isTurn ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            symbol,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isTurn ? Theme.of(context).colorScheme.onPrimaryContainer : null,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isMe ? "$name (You)" : name,
            style: TextStyle(
              fontWeight: isTurn ? FontWeight.bold : FontWeight.normal,
              color: isTurn ? Theme.of(context).colorScheme.onPrimaryContainer : null,
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
      builder: (context, siteState) {
        final siteName = siteState.name;

        return Text(siteName);
      },
    );
  }
}
