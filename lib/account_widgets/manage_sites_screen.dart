// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/account_blocs/account_replay_bloc.dart';
import 'package:hyttahub/common_widgets/layout.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/account_events.pb.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/site_widgets/site_name_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/utilities/common_error_handling.dart';

class ManageSitesScreen extends StatefulWidget {
  const ManageSitesScreen({super.key});

  @override
  State<ManageSitesScreen> createState() => _ManageSitesScreenState();
}

class _ManageSitesScreenState extends State<ManageSitesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountReplayBloc, AccountReplayBlocState>(
      builder: (context, accountState) {
        final errorWidget = handleAccountReplayState(context, accountState);
        if (errorWidget != null) {
          return errorWidget;
        }

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
                                  version: accountState.nextVersion,
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
    );
  }
}
