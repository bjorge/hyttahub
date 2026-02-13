// Copyright (c) 2025 bjorge

import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/site_blocs/site_name_replay_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SiteNameDisplay extends StatefulWidget {
  final String collectionName;

  const SiteNameDisplay({super.key, required this.collectionName});

  @override
  State<SiteNameDisplay> createState() => _SiteNameDisplayState();
}

class _SiteNameDisplayState extends State<SiteNameDisplay> {
  late final SiteNameReplayBloc bloc = SiteNameReplayBloc(widget.collectionName);

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      key: Key("SiteNameDisplay-${widget.collectionName}"),

      // create: (_) => SiteNameReplayBloc(widget.collectionName),
      child: BlocSelector<SiteNameReplayBloc, SiteNameReplayBlocState, String>(
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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(CommonReplayBlocEvent(listen: true));
    });
  }
}
