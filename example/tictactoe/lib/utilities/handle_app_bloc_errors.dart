import 'package:flutter/material.dart';
import 'package:tictactoe/l10n/app_localizations.dart';
import 'package:tictactoe/proto/app_replay_bloc.pb.dart';

Widget? handleAppReplayState(
  BuildContext context,
  AppReplayBlocState appState,
) {
  Widget? errorWidget;
  final inScaffold = Scaffold.maybeOf(context) != null;

  final l10n = AppLocalizations.of(context)!;
  if (!appState.hasState()) {
    errorWidget = const Center(child: CircularProgressIndicator());
  }

  switch (appState.state) {
    case AppReplayStateEnum.listening:
      errorWidget = null;
    case AppReplayStateEnum.hydrating:
      errorWidget = const Center(child: CircularProgressIndicator());
    case AppReplayStateEnum.uninitializedListening:
    case AppReplayStateEnum.networkError:
      errorWidget = Center(child: Text(l10n.app_unexpectedError));
    case AppReplayStateEnum.permissionDenied:
      errorWidget = Center(child: Text(l10n.app_permissionDenied));
    default:
      errorWidget = Center(child: Text(l10n.app_unexpectedError));
  }

  if (errorWidget != null) {
    if (!inScaffold) {
      return Scaffold(body: Center(child: errorWidget));
    } else {
      return errorWidget;
    }
  }
  return null;
}
