import 'package:flutter/material.dart';
import 'package:template/l10n/app_localizations.dart';
import 'package:template/proto/app_replay_bloc.pb.dart';

Widget? handleAppReplayState(
  BuildContext context,
  AppReplayBlocState appState,
) {
  // No error for the normal listening state.
  if (appState.state == AppReplayStateEnum.listening) {
    return null;
  }

  final inScaffold = Scaffold.maybeOf(context) != null;
  final l10n = AppLocalizations.of(context)!;

  final Widget errorWidget;
  if (!appState.hasState()) {
    errorWidget = const Center(child: CircularProgressIndicator());
  } else {
    switch (appState.state) {
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
  }

  if (!inScaffold) {
    return Scaffold(body: Center(child: errorWidget));
  }
  return errorWidget;
}
