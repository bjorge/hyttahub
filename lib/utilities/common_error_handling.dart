import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hyttahub/account_widgets/account_screen.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/account_replay_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pbenum.dart';
import 'package:hyttahub/proto/service_replay_bloc.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';

/// Handles the different states of the [SiteReplayBloc] and returns a widget
/// for loading or error states.
///
/// Returns a [Widget] to display if the state is not 'ok', otherwise returns `null`.
Widget? handleSiteReplayState(
  BuildContext context,
  SiteReplayBlocState siteState,
) {
  if (kDebugMode) {
    print("handleSiteReplayState: siteState = ${siteState.toProto3Json()}");
  }

  final l10n = HyttaHubLocalizations.of(context)!;
  if (!siteState.hasState()) {
    return const Center(child: CircularProgressIndicator());
  }

  switch (siteState.state) {
    case CommonReplayStateEnum.listening:
      return null;
    case CommonReplayStateEnum.hydrating:
      return const Center(child: CircularProgressIndicator());
    case CommonReplayStateEnum.uninitialized:
    case CommonReplayStateEnum.networkError:
      return Center(child: Text(l10n.unexpectedError));
    case CommonReplayStateEnum.permissionDenied:
      return Center(child: Text(l10n.permissionDenied));
    default:
      return Center(child: Text(l10n.unexpectedError));
  }
}

Widget? handleAccountReplayState(
  BuildContext context,
  AccountReplayBlocState accountState,
) {
  if (kDebugMode) {
    print(
      "handleAccountReplayState: accountState = ${accountState.toProto3Json()}",
    );
  }
  final l10n = HyttaHubLocalizations.of(context)!;

  if (!accountState.hasState()) {
    return const Center(child: CircularProgressIndicator());
  }

  switch (accountState.state) {
    case CommonReplayStateEnum.listening:
      return null;
    case CommonReplayStateEnum.hydrating:
      return const Center(child: CircularProgressIndicator());
    case CommonReplayStateEnum.uninitialized:
      return AccountInitializingWidget(
        email: GetIt.instance<AuthBloc>().state.email,
      );

    case CommonReplayStateEnum.networkError:
      return Center(child: Text(l10n.unexpectedError));
    case CommonReplayStateEnum.permissionDenied:
      return Center(child: Text(l10n.permissionDenied));
    default:
      return Center(child: Text(l10n.unexpectedError));
  }
}

Widget? handleServiceReplayState(
  BuildContext context,
  ServiceReplayBlocState serviceState,
) {
  if (kDebugMode) {
    print(
      "handleServiceReplayState: serviceState = ${serviceState.toProto3Json()}",
    );
  }
  final l10n = HyttaHubLocalizations.of(context)!;
  if (!serviceState.hasState()) {
    return const Center(child: CircularProgressIndicator());
  }

  switch (serviceState.state) {
    case CommonReplayStateEnum.listening:
      return null;
    case CommonReplayStateEnum.hydrating:
      return const Center(child: CircularProgressIndicator());
    case CommonReplayStateEnum.uninitialized:
    case CommonReplayStateEnum.networkError:
      return Center(child: Text(l10n.unexpectedError));
    case CommonReplayStateEnum.permissionDenied:
      return Center(child: Text(l10n.permissionDenied));
    default:
      return Center(child: Text(l10n.unexpectedError));
  }
}
