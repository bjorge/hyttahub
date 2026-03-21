// Copyright (c) 2025 bjorge

import 'package:hyttahub/account_blocs/account_replay_bloc.dart';
import 'package:hyttahub/common_widgets/layout.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/site_widgets/site_name_widget.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CopySiteScreen extends StatefulWidget {
  const CopySiteScreen({super.key});

  @override
  State<CopySiteScreen> createState() => _CopySiteScreenState();
}

class _CopySiteScreenState extends State<CopySiteScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountReplayBloc, AccountReplayBlocState>(
      builder: (context, accountState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(HyttaHubLocalizations.of(context)!.copySiteTitle),
          ),
          body: CommonListViewLayout(
            children: accountState.sitesIds.isEmpty
                ? [
                    Center(
                      child: Text(HyttaHubLocalizations.of(context)!.noSites),
                    ),
                  ]
                : accountState.sitesIds
                      .map(
                        (siteId) => ListTile(
                          key: Key('copy_$siteId'),
                          title: SiteNameDisplay(collectionName: siteId),
                          trailing: IconButton(
                            icon: const Icon(Icons.content_copy),
                            tooltip: HyttaHubLocalizations.of(
                              context,
                            )!.copySiteTooltip,
                            onPressed: () {
                              final email = context.read<AuthBloc>().state.email;
                              final payload = SubmitSiteEvent(
                                authorEmail: email,
                                event: SiteEvent(version: 999999999),
                                isMarkForCopy: true,
                              );
                              final serialized = base64UrlEncode(payload.writeToBuffer());

                              context.push(
                                CopySiteConfirmRoute.fullPath(
                                  siteId: siteId,
                                  event: serialized,
                                ),
                              );
                            },
                          ),
                        ),
                      )
                      .toList(),
          ),
        );
      },
    );
  }
}
