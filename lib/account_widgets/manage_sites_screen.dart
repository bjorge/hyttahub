// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/account_blocs/account_replay_bloc.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/common_widgets/layout.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/account_events.pb.dart';
import 'package:hyttahub/proto/account_replay_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/site_widgets/site_name_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class ManageSitesScreen extends StatefulWidget {
  const ManageSitesScreen({super.key});

  @override
  State<ManageSitesScreen> createState() => _ManageSitesScreenState();
}

class _ManageSitesScreenState extends State<ManageSitesScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AccountReplayBloc>(
          key: Key('ManageSitesScreenStatenBlocProvider'),

          create: (_) =>
              AccountReplayBloc(GetIt.instance<AuthBloc>().state.email)
                ..add(CommonReplayBlocEvent(listen: true)),
        ),
      ],
      child: BlocBuilder<AccountReplayBloc, AccountReplayBlocState>(
        builder: (context, accountState) {
          return Scaffold(
            appBar: AppBar(
              title: Text(HyttaHubLocalizations.of(context)!.manageSitesTitle),
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
                            key: Key(siteId),
                            title: SiteNameDisplay(collectionName: siteId),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              tooltip: HyttaHubLocalizations.of(
                                context,
                              )!.leaveSiteTooltip,
                              onPressed: () {
                                final submmitValue = SubmitAccountEvent(
                                  event: AccountEvent(
                                    leaveSite: siteId,
                                    version:
                                        accountState.events.keys.fold<int>(
                                          1,
                                          (p, e) => e > p ? e : p,
                                        ) +
                                        1,
                                  ),
                                );

                                final encodedSubmitValue = base64UrlEncode(
                                  submmitValue.writeToBuffer(),
                                );

                                context.push(
                                  '${RemoveSiteRoute.fullPath}?event=$encodedSubmitValue',
                                );
                              },
                            ),
                          ),
                        )
                        .toList(),
            ),
          );
        },
      ),
    );
  }
}
