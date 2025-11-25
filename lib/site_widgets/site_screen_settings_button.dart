// Copyright (c) 2025 bjorge

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/site_widgets/site_settings_dialog_options.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:flutter/material.dart';

import 'package:hyttahub/site_blocs/site_replay_bloc.dart';

class SiteSettingsButton extends StatefulWidget {
  const SiteSettingsButton({super.key, required this.siteId, this.appOptions});

  final String siteId;
  final List<SimpleDialogOption>? appOptions;

  @override
  State<SiteSettingsButton> createState() => _SiteSettingsButtonState();
}

class _SiteSettingsButtonState extends State<SiteSettingsButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
      builder: (context, siteState) {
        return IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) => SimpleDialog(
                title: Text(
                  HyttaHubLocalizations.of(context)!.siteSettingsTitle,
                ),
                children: <Widget>[
                  if (widget.appOptions != null) ...widget.appOptions!,
                  ...buildSiteSettingsDialogOptions(
                    context,
                    dialogContext,
                    siteState,
                    widget.siteId,
                  ),
                ],
              ),
            );
          },

          icon: const Icon(Icons.settings),
        );
      },
    );
  }
}
