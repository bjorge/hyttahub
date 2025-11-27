import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hyttahub/account_widgets/account_screen.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/account_replay_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pbenum.dart';
import 'package:hyttahub/proto/service_replay_bloc.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';

Widget? handleSiteReplayState(
  BuildContext context,
  SiteReplayBlocState siteState,
) {
  Widget? errorWidget;
  final inScaffold = Scaffold.maybeOf(context) != null;

  final l10n = HyttaHubLocalizations.of(context)!;
  if (!siteState.hasState()) {
    errorWidget = const Center(child: CircularProgressIndicator());
  }

  switch (siteState.state) {
    case CommonReplayStateEnum.listening:
      errorWidget = null;
    case CommonReplayStateEnum.hydrating:
      errorWidget = const Center(child: CircularProgressIndicator());
    case CommonReplayStateEnum.uninitializedListening:
    case CommonReplayStateEnum.networkError:
      errorWidget = Center(child: Text(l10n.unexpectedError));
    case CommonReplayStateEnum.permissionDenied:
      errorWidget = Center(child: Text(l10n.permissionDenied));
    default:
      errorWidget = Center(child: Text(l10n.unexpectedError));
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

Widget? handleAccountReplayState(
  BuildContext context,
  AccountReplayBlocState accountState,
) {
  Widget? errorWidget;
  final inScaffold = Scaffold.maybeOf(context) != null;

  final l10n = HyttaHubLocalizations.of(context)!;

  if (!accountState.hasState()) {
    errorWidget = const Center(child: CircularProgressIndicator());
  }

  switch (accountState.state) {
    case CommonReplayStateEnum.listening:
      errorWidget = null;
    case CommonReplayStateEnum.hydrating:
      errorWidget = const Center(child: CircularProgressIndicator());
    case CommonReplayStateEnum.uninitializedListening:
      errorWidget = AccountInitializingWidget(
        email: GetIt.instance<AuthBloc>().state.email,
      );

    case CommonReplayStateEnum.networkError:
      errorWidget = Center(child: Text(l10n.unexpectedError));
    case CommonReplayStateEnum.permissionDenied:
      errorWidget = Center(child: Text(l10n.permissionDenied));
    default:
      errorWidget = Center(child: Text(l10n.unexpectedError));
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

Widget? handleServiceReplayState(
  BuildContext context,
  ServiceReplayBlocState serviceState,
) {
  Widget? errorWidget;
  final inScaffold = Scaffold.maybeOf(context) != null;

  final l10n = HyttaHubLocalizations.of(context)!;
  if (!serviceState.hasState()) {
    errorWidget = const Center(child: CircularProgressIndicator());
  }

  switch (serviceState.state) {
    case CommonReplayStateEnum.listening:
      errorWidget = null;
    case CommonReplayStateEnum.hydrating:
    case CommonReplayStateEnum.uninitializedListening:
      errorWidget = const Center(child: CircularProgressIndicator());
    case CommonReplayStateEnum.networkError:
      errorWidget = Center(child: Text(l10n.unexpectedError));
    case CommonReplayStateEnum.permissionDenied:
      errorWidget = Center(child: Text(l10n.permissionDenied));
    default:
      errorWidget = Center(child: Text(l10n.unexpectedError));
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
