import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/account_blocs/account_replay_bloc.dart';
import 'package:hyttahub/account_widgets/account_screen.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pbenum.dart';
import 'package:hyttahub/proto/service_replay_bloc.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';

Widget? handleSiteReplayState(
  BuildContext context,
  SiteReplayBlocState siteState, String siteId,
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
      break;
    case CommonReplayStateEnum.hydrating:
      errorWidget = const Center(child: CircularProgressIndicator());
      break;
    case CommonReplayStateEnum.uninitializedListening:
    case CommonReplayStateEnum.networkError:
      errorWidget = Center(child: Text(l10n.unexpectedError));
      break;
    case CommonReplayStateEnum.permissionDenied:
      errorWidget = Center(child: Text(l10n.permissionDenied));
      break;
    default:
      errorWidget = Center(child: Text(l10n.unexpectedError));
      break;
  }

  if (errorWidget == null) {
    final accountState = context.read<AccountReplayBloc>().state;
    final siteIds = accountState.sitesIds.toList();
    if (!siteIds.contains(siteId)) {
      errorWidget = Center(child: Text("You have been removed from this site."));
    }
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
      break;
    case CommonReplayStateEnum.hydrating:
      errorWidget = const Center(child: CircularProgressIndicator());
      break;
    case CommonReplayStateEnum.uninitializedListening:
      errorWidget = AccountInitializingWidget(
        email: context.read<AuthBloc>().state.email,
      );
      break;
    case CommonReplayStateEnum.networkError:
      errorWidget = Center(child: Text(l10n.unexpectedError));
      break;
    case CommonReplayStateEnum.permissionDenied:
      errorWidget = Center(child: Text(l10n.permissionDenied));
      break;
    default:
      errorWidget = Center(child: Text(l10n.unexpectedError));
      break;
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
      break;
    case CommonReplayStateEnum.hydrating:
      errorWidget = const Center(child: CircularProgressIndicator());
      break;
    case CommonReplayStateEnum.uninitializedListening:
      // Return null so that the shell route can handle this state
      // (e.g. by showing the ServiceUninitializedPage)
      errorWidget = null;
      break;
    case CommonReplayStateEnum.networkError:
      errorWidget = Center(child: Text(l10n.unexpectedError));
      break;
    case CommonReplayStateEnum.permissionDenied:
      errorWidget = Center(child: Text(l10n.permissionDenied));
      break;
    default:
      errorWidget = Center(child: Text(l10n.unexpectedError));
      break;
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

Widget? handleAllowedEmailsState(
  BuildContext context,
  AllowedEmailsBlocState allowedEmailsState,
) {
  Widget? errorWidget;
  final inScaffold = Scaffold.maybeOf(context) != null;

  final l10n = HyttaHubLocalizations.of(context)!;
  if (!allowedEmailsState.hasState() ||
      allowedEmailsState.state == AllowedEmailsBlocState_State.fetching) {
    errorWidget = const Center(child: CircularProgressIndicator());
  } else if (allowedEmailsState.state == AllowedEmailsBlocState_State.error) {
    errorWidget = Center(child: Text(l10n.unexpectedError));
  } else if (allowedEmailsState.state ==
      AllowedEmailsBlocState_State.permissionDenied) {
    errorWidget = Center(child: Text(l10n.permissionDenied));
  }

  if (errorWidget != null) {
    if (!inScaffold) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.errorTitle)),
        body: Center(child: errorWidget),
      );
    } else {
      return errorWidget;
    }
  }
  return null;
}
