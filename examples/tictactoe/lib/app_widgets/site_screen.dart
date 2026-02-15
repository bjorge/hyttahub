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

class SiteScreen extends StatefulWidget {
  const SiteScreen({super.key, required this.siteId});

  final String siteId;

  @override
  State<SiteScreen> createState() => _SiteScreenState();
}

class _SiteScreenState extends State<SiteScreen> {
  // We don't need image fetching for simple X/O game, but keeping structure valid.
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
              // Tic Tac Toe Board
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
                            Navigator.pop(context);
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
    // Don't show pending moves for AI (Player 2) to simulate thinking time
    if (move.player == 2) return false;
    return (move.y * 3 + move.x) == index;
  }

  void _startGame(BuildContext context) {
    final appEvent = AppEvent(startGame: AppEvent_StartGame(vsBot: true));
    _submitAppEvent(context, appEvent);
  }

  void _playAgain(BuildContext context) {
    final appEvent = AppEvent(playAgain: AppEvent_PlayAgain());
    _submitAppEvent(context, appEvent);
  }

  void _submitAppEvent(BuildContext context, AppEvent appEvent) {
    final email = GetIt.instance<AuthBloc>().state.email;
    final version = context.read<AppReplayBloc>().state.nextVersion;

    final submitEvent =
        SubmitAppEvent()
          ..appEvent = appEvent
          ..siteEvent = (SubmitAppEvent_SiteEvent()..version = version)
          ..authorEmail = email;

    final submitBloc = context.read<AppSubmitBloc>();

    // 1. Update payload and set form to valid
    submitBloc.add(
      AppEventSubmission(
        updatedPayload: submitEvent,
        submission: CommonSubmitBlocEvent(isFormValid: true),
      ),
    );

    // 2. Trigger submission
    submitBloc.add(
      AppEventSubmission(
        submission: CommonSubmitBlocEvent(
          submit: CommonSubmitBlocEvent_SubmitNow(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // We already have AppSubmitBloc provided by SiteScreen.
    // We just need to consume it.

    return BlocBuilder<AppSubmitBloc, BaseSubmitState<SubmitAppEvent>>(
      builder: (context, submitState) {
        return BlocBuilder<AppReplayBloc, AppReplayBlocState>(
          builder: (context, appState) {
            final errorWidget = handleAppReplayState(context, appState);
            if (errorWidget != null) return errorWidget;

            final board = appState.board;
            if (board.isEmpty) return const CircularProgressIndicator();

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (appState.winner != 0)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      appState.winner == 3
                          ? "Draw!"
                          : "Player ${appState.winner} Wins!",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      final cellValue = board[index];
                      final isPending = _isPendingBox(index, submitState);

                      // Pending move override
                      // If pending, it must be our move (X or O).
                      // We'll assume user is always moving as 'current turn' player or '1' if we want.
                      // But wait, the submitState payload has the player.
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
                              submitState.submissionState.state !=
                                  CommonSubmitBlocState_State.submitting) {
                            final version = appState.nextVersion;
                            // Submit move
                            final player =
                                appState.turn; // Move as the current turn
                            final x = index % 3;
                            final y = index ~/ 3;

                            final move = AppEvent_Move(
                              x: x,
                              y: y,
                              player: player,
                            );
                            final appEvent = AppEvent(move: move);

                            // We need to trigger submission.
                            // The BaseSubmitBloc expects a 'Submit' event.
                            final submitEvent =
                                SubmitAppEvent()
                                  ..appEvent = appEvent
                                  ..siteEvent =
                                      (SubmitAppEvent_SiteEvent()
                                        ..version = version)
                                  ..authorEmail =
                                      GetIt.instance<AuthBloc>().state.email;

                            // 1. Update payload and set form to valid
                            context.read<AppSubmitBloc>().add(
                              AppEventSubmission(
                                updatedPayload: submitEvent,
                                submission: CommonSubmitBlocEvent(
                                  isFormValid: true,
                                ),
                              ),
                            );

                            // 2. Trigger submission
                            context.read<AppSubmitBloc>().add(
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
                if (appState.status == GameStatus.notStarted)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () => _startGame(context),
                      child: const Text("Start Game"),
                    ),
                  ),
                if (appState.status == GameStatus.gameOver)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () => _playAgain(context),
                      child: const Text("Play Again?"),
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
