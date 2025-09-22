// Copyright (c) 2025 bjorge

import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SiteNameDisplay extends StatelessWidget {
  final String collectionName;

  const SiteNameDisplay({super.key, required this.collectionName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: Key("SiteNameDisplay-$collectionName"),

      create: (_) =>
          SiteReplayBloc(collectionName)
            ..add(CommonReplayBlocEvent(listen: true)),
      child: BlocSelector<SiteReplayBloc, SiteReplayBlocState, String>(
        selector: (state) => state.name,
        builder: (context, name) {
          return Text(
            name.isNotEmpty
                ? name
                : HyttaHubLocalizations.of(context)!.loadingEllipsis,
          );
        },
      ),
    );
  }
}
