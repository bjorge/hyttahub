import 'package:tictactoe/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tictactoe/app_blocs/app_replay_bloc.dart';
import 'package:tictactoe/app_blocs/app_submit_bloc.dart';
import 'package:tictactoe/proto/app_events.pb.dart';
import 'package:tictactoe/proto/app_replay_bloc.pb.dart';
import 'package:tictactoe/routers/app_routes.dart';
import 'package:tictactoe/utilities/handle_app_bloc_errors.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/common_blocs/allowed_emails_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:hyttahub/site_widgets/site_screen_settings_button.dart';
import 'package:hyttahub/utilities/common_error_handling.dart';

class SiteScreen extends StatefulWidget {
  const SiteScreen({super.key, required this.siteId});

  final String siteId;

  @override
  State<SiteScreen> createState() => _SiteScreenState();
}

class _SiteScreenState extends State<SiteScreen> {
  // We don't need image fetching for simple X/O game, but keeping structure valid.

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SiteReplayBloc>(
          key: Key('SiteReplayBloc-tictactoe-${widget.siteId}'),
          create:
              (_) =>
                  SiteReplayBloc(widget.siteId)
                    ..add(CommonReplayBlocEvent(listen: true)),
        ),
        BlocProvider<AppReplayBloc>(
          key: Key('AppReplayBloc-tictactoe-${widget.siteId}'),
          create:
              (_) =>
                  AppReplayBloc(widget.siteId)
                    ..add(CommonReplayBlocEvent(listen: true)),
        ),
        BlocProvider<AllowedEmailsBloc>(
          create:
              (_) =>
                  AllowedEmailsBloc(firebaseSiteUsersPath(widget.siteId))..add(
                    AllowedEmailsBlocEvent(
                      fetchNow: AllowedEmailsBlocEvent_FetchedAllowedEmails(),
                    ),
                  ),
        ),
      ],
      child: BlocBuilder<AllowedEmailsBloc, AllowedEmailsBlocState>(
        key: Key('AllowedEmailsBloc-site-screen-${widget.siteId}'),
        builder: (context, allowedEmailsState) {
          if (!allowedEmailsState.hasState() ||
              allowedEmailsState.state ==
                  AllowedEmailsBlocState_State.fetching) {
            return const Center(child: CircularProgressIndicator());
          }

          if (allowedEmailsState.state == AllowedEmailsBlocState_State.error) {
            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.app_errorTitle),
              ),
              body: Center(
                child: Text(AppLocalizations.of(context)!.app_unexpectedError),
              ),
            );
          }

          if (allowedEmailsState.state ==
              AllowedEmailsBlocState_State.permissionDenied) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  AppLocalizations.of(context)!.app_accessDeniedTitle,
                ),
              ),
              body: Center(
                child: Text(
                  AppLocalizations.of(context)!.app_accessDeniedMessage,
                ),
              ),
            );
          }

          return BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
            builder: (context, siteState) {
              final errorWidget = handleSiteReplayState(context, siteState);
              if (errorWidget != null) {
                return errorWidget;
              }

              // Tic Tac Toe Board
              return Scaffold(
                appBar: AppBar(
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
                body: Center(child: TicTacToeBoard(siteId: widget.siteId)),
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
    return (move.y * 3 + move.x) == index;
  }

  @override
  Widget build(BuildContext context) {
    // We need the SubmitBloc to show pending moves.
    // But AppSubmitBloc is usually provided/created when submitting.
    // Here we need to watch it if it exists in the tree?
    // or check if we are currently submitting.
    // Actually, the submit bloc is often created transiently or scoped to a screen.
    // If we want to show pending state on the main board, we need to know about the pending submission.
    // The standard pattern in this app seems to be `context.push` to a route that handles submission?
    // But for a game, we want to stay on screen.
    // So we should provide the AppSubmitBloc here or wrap the board in it.
    // Let's wrapping it for now.

    // Wait, normally we navigate to a submission screen. But here we want immediate feedback.
    // We'll create a local bloc provider for submission or use a Global/Page scoped one.
    // Let's create one here.

    // Initial dummy payload for bloc creation
    final initialEvent =
        SubmitAppEvent()
          ..siteEvent = (SubmitAppEvent_SiteEvent()..version = 0)
          ..authorEmail = GetIt.instance<AuthBloc>().state.email;

    return BlocProvider<AppSubmitBloc>(
      create: (context) => AppSubmitBloc(siteId, initialEvent),
      child: BlocBuilder<AppSubmitBloc, BaseSubmitState<SubmitAppEvent>>(
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
                            if (cellValue == 0 &&
                                appState.winner == 0 &&
                                !isPending &&
                                submitState.submissionState.state !=
                                    CommonSubmitBlocState_State.submitting) {
                              final maxVersion = appState.events.keys.fold(
                                0,
                                (p, e) => e > p ? e : p,
                              );
                              final version = maxVersion + 1;
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
                              border: Border.all(color: Colors.black),
                            ),
                            child: Center(
                              child: Text(
                                displayValue == 1
                                    ? "X"
                                    : (displayValue == 2 ? "O" : ""),
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: gray ? Colors.grey : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
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
        final errorWidget = handleSiteReplayState(context, siteState);
        if (errorWidget != null) {
          return errorWidget;
        }

        final siteName = siteState.name;

        return Text(siteName);
      },
    );
  }
}
