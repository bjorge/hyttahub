import 'package:flutter/material.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/common_blocs.pbenum.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';

/// Handles the different states of the [SiteReplayBloc] and returns a widget
/// for loading or error states.
///
/// Returns a [Widget] to display if the state is not 'ok', otherwise returns `null`.
Widget? handleSiteReplayState(
  BuildContext context,
  SiteReplayBlocState siteState,
) {
  final l10n = HyttaHubLocalizations.of(context)!;
  if (!siteState.hasState() ||
      siteState.state == CommonReplayStateEnum.fetchingConfig) {
    return const Center(child: CircularProgressIndicator());
  }

  switch (siteState.state) {
    case CommonReplayStateEnum.ok:
      if (!siteState.hasState()) {
        return const Center(child: CircularProgressIndicator());
      }
      return null;
    case CommonReplayStateEnum.fetchingConfig:
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
