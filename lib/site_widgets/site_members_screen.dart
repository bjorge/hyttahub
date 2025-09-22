// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/common_blocs/allowed_emails_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/common_widgets/layout.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';

class SiteMembersScreen extends StatelessWidget {
  const SiteMembersScreen({super.key, required this.siteId});

  final String siteId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AllowedEmailsBloc>(
          key: Key('AllowedEmailsBloc-Site-members-screen-$siteId'),

          create: (_) => AllowedEmailsBloc(firebaseSiteUsersPath(siteId))
            ..add(
              AllowedEmailsBlocEvent(
                fetchNow: AllowedEmailsBlocEvent_FetchedAllowedEmails(),
              ),
            ),
        ),
        BlocProvider<SiteReplayBloc>(
          key: Key('SiteReplayBloc-Site-members-screen-$siteId'),
          create: (_) =>
              SiteReplayBloc(siteId)..add(CommonReplayBlocEvent(listen: true)),
        ),
      ],
      child: BlocBuilder<AllowedEmailsBloc, AllowedEmailsBlocState>(
        builder: (context, allowedEmailsState) {
          if (!allowedEmailsState.hasState() ||
              allowedEmailsState.state ==
                  AllowedEmailsBlocState_State.fetching) {
            return const Center(child: CircularProgressIndicator());
          }

          if (allowedEmailsState.state == AllowedEmailsBlocState_State.error) {
            return Scaffold(
              appBar: AppBar(
                title: Text(HyttaHubLocalizations.of(context)!.errorTitle),
              ),
              body: Text(HyttaHubLocalizations.of(context)!.unexpectedError),
            );
          }
          if (allowedEmailsState.state ==
              AllowedEmailsBlocState_State.permissionDenied) {
            return Scaffold(
              appBar: AppBar(
                title: Text(HyttaHubLocalizations.of(context)!.errorTitle),
              ),
              body: Center(
                child: Text(
                  HyttaHubLocalizations.of(context)!.permissionDenied,
                ),
              ),
            );
          }

          return BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
            key: Key('SiteReplayBloc-Site-members-screen-$siteId'),
            builder: (context, siteState) {
              // first check if the account state is initialized
              if (!siteState.hasState() ||
                  siteState.state == CommonReplayStateEnum.fetchingConfig) {
                return const Center(child: CircularProgressIndicator());
              }

              final currentUserEmail = GetIt.instance<AuthBloc>().state.email;

              // return Builder(
              //   builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(HyttaHubLocalizations.of(context)!.membersTitle),

                  actions: [
                    IconButton(
                      onPressed: () {
                        final submmitValue = SubmitSiteEvent(
                          authorEmail: GetIt.instance<AuthBloc>().state.email,

                          addMemberEmail: '', // new member email
                          event: SiteEvent(
                            addMember: SiteEvent_AddMember(
                              memberName: '', // new member name
                              admin: false,
                            ),
                            version:
                                siteState.events.keys.fold<int>(
                                  0,
                                  (p, e) => e > p ? e : p,
                                ) +
                                1,
                          ),
                        );
                        final encodedSubmitValue = base64UrlEncode(
                          submmitValue.writeToBuffer(),
                        );

                        context.push(
                          // HyttaHubOptions.addMemberRoute!(
                          //   siteId,
                          //   encodedSubmitValue,
                          // ),
                          "${AddMemberRoute.fullPath(siteId: siteId)}?event=$encodedSubmitValue",
                        );
                      },

                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),

                body: CommonListViewLayout(
                  children: [
                    ...siteState.members.entries
                        .where((element) => element.key != 0)
                        .map(
                          (entry) => ListTile(
                            title: Text(entry.value.name),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (entry.value.admin)
                                  const Icon(Icons.shield),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  tooltip: HyttaHubLocalizations.of(
                                    context,
                                  )!
                                      .updateMemberTooltip,
                                  onPressed: () {
                                    final originalEmail = allowedEmailsState
                                        .emails.entries
                                        .firstWhere(
                                            (e) => e.value.userId == entry.key)
                                        .key;

                                    final submitValue = SubmitSiteEvent(
                                      authorEmail: currentUserEmail,
                                      updateMemberOriginalEmail: originalEmail,
                                      updateMemberNewEmail: originalEmail,
                                      event: SiteEvent(
                                        updateMember: SiteEvent_UpdateMember(
                                          memberId: entry.key,
                                          memberName: entry.value.name,
                                          admin: entry.value.admin,
                                        ),
                                        version:
                                            siteState.events.keys.fold<int>(
                                                  0,
                                                  (p, e) => e > p ? e : p,
                                                ) +
                                                1,
                                      ),
                                    );
                                    final encodedSubmitValue =
                                        base64UrlEncode(
                                      submitValue.writeToBuffer(),
                                    );
                                    context.push(
                                      '${UpdateMemberRoute.fullPath(siteId: siteId)}?event=$encodedSubmitValue&originalEmail=$originalEmail',
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  tooltip: HyttaHubLocalizations.of(
                                    context,
                                  )!
                                      .removeMemberTooltip,
                                  onPressed: currentUserEmail ==
                                          allowedEmailsState.emails.entries
                                              .firstWhere(
                                                (e) =>
                                                    e.value.userId ==
                                                    entry.key,
                                                orElse: () => MapEntry(
                                                  '',
                                                  AllowedEmailsBlocState_UserInfo(),
                                                ), // Return empty string if no match
                                              )
                                              .key
                                      ? null
                                      : () {
                                          final submitValue = SubmitSiteEvent(
                                            authorEmail: currentUserEmail,
                                            removeMemberEmail:
                                                allowedEmailsState.emails.entries
                                                    .firstWhere(
                                                      (e) =>
                                                          e.value.userId ==
                                                          entry.key,
                                                      orElse: () => MapEntry(
                                                        '',
                                                        AllowedEmailsBlocState_UserInfo(),
                                                      ), // Return empty string if no match
                                                    )
                                                    .key,
                                            event: SiteEvent(
                                              removeMember:
                                                  SiteEvent_RemoveMember(
                                                memberId: entry.key,
                                              ),
                                              version: siteState.events.keys
                                                      .fold<int>(
                                                        0,
                                                        (p, e) => e > p ? e : p,
                                                      ) +
                                                  1,
                                            ),
                                          );
                                          final encodedSubmitValue =
                                              base64UrlEncode(
                                            submitValue.writeToBuffer(),
                                          );
                                          context.push(
                                            '${RemoveMemberRoute.fullPath(siteId: siteId)}?event=$encodedSubmitValue',
                                          );
                                        },
                                ),
                              ],
                            ),
                          ),
                        ),
                    const Divider(),
                    if (siteState.removedMembers.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          HyttaHubLocalizations.of(context)!
                              .removedMembersTitle,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      ...siteState.removedMembers.entries.map(
                        (entry) => ListTile(
                          title: Text(entry.value.name),
                          trailing: IconButton(
                            icon: const Icon(Icons.restore),
                            tooltip: HyttaHubLocalizations.of(
                              context,
                            )!
                                .restoreMemberTooltip,
                            onPressed: () {
                              final submitValue = SubmitSiteEvent(
                                authorEmail: currentUserEmail,
                                addMemberEmail: '',
                                event: SiteEvent(
                                  restoreMember: SiteEvent_RestoreMember(
                                    memberId: entry.key,
                                    memberName: entry.value.name,
                                    admin: entry.value.admin,
                                  ),
                                  version: siteState.events.keys.fold<int>(
                                        0,
                                        (p, e) => e > p ? e : p,
                                      ) +
                                      1,
                                ),
                              );
                              final encodedSubmitValue = base64UrlEncode(
                                submitValue.writeToBuffer(),
                              );
                              context.push(
                                '${RestoreMemberRoute.fullPath(siteId: siteId)}?event=$encodedSubmitValue',
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
              //   },
              // );
            },
          );
        },
      ),
    );
  }
}

//   }
