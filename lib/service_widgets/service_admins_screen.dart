// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/common_blocs/allowed_emails_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/common_widgets/layout.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';
import 'package:hyttahub/proto/bloom_filter.pb.dart';
import 'package:hyttahub/proto/service_events.pb.dart';
import 'package:hyttahub/proto/service_replay_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/service_blocs/service_replay_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/utilities/bloom_filter.dart';

class ServiceAdminsScreen extends StatelessWidget {
  const ServiceAdminsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AllowedEmailsBloc>(
          create: (_) =>
              AllowedEmailsBloc(
                firebaseServiceServiceAdminsPath(firebaseServiceCollectionName),
              )..add(
                AllowedEmailsBlocEvent(
                  fetchNow: AllowedEmailsBlocEvent_FetchedAllowedEmails(),
                ),
              ),
        ),
        BlocProvider<ServiceReplayBloc>(
          create: (_) =>
              ServiceReplayBloc()..add(CommonReplayBlocEvent(listen: true)),
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

          return BlocBuilder<ServiceReplayBloc, ServiceReplayBlocState>(
            builder: (context, serviceState) {
              // first check if the account state is initialized
              if (!serviceState.hasState() ||
                  serviceState.state == CommonReplayStateEnum.fetchingConfig) {
                return const Center(child: CircularProgressIndicator());
              }

              final currentUserEmail = GetIt.instance<AuthBloc>().state.email;

              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    HyttaHubLocalizations.of(context)!.manageServiceAdminsTitle,
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        final submmitValue = SubmitServiceEvent(
                          email: GetIt.instance<AuthBloc>().state.email,
                          addServiceAdminEmail: '', // new admin email
                          event: ServiceEvent(
                            addServiceAdmin: ServiceEvent_AddServiceAdmin(
                              alias: '', // new admin alias
                            ),
                            version:
                                serviceState.events.keys.fold<int>(
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
                          '${AddServiceAdminRoute.fullPath}?event=$encodedSubmitValue',
                        );
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                body: CommonListViewLayout(
                  children: [
                    ...serviceState.serviceAdmins.entries.map(
                      (entry) => ListTile(
                        title: Text(entry.value.alias),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: HyttaHubLocalizations.of(
                                context,
                              )!.updateMemberTooltip,
                              onPressed: () {
                                final originalEmail = allowedEmailsState
                                    .emails
                                    .entries
                                    .firstWhere(
                                      (e) => e.value.userId == entry.key,
                                    )
                                    .key;

                                final submitValue = SubmitServiceEvent(
                                  email: currentUserEmail,
                                  updateServiceAdminOriginalEmail:
                                      originalEmail,
                                  updateServiceAdminNewEmail: originalEmail,
                                  event: ServiceEvent(
                                    updateServiceAdmin:
                                        ServiceEvent_UpdateServiceAdmin(
                                          id: entry.key,
                                          alias: entry.value.alias,
                                        ),
                                    version:
                                        serviceState.events.keys.fold<int>(
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
                                  '${UpdateServiceAdminRoute.fullPath}?event=$encodedSubmitValue&originalEmail=$originalEmail',
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              tooltip: HyttaHubLocalizations.of(
                                context,
                              )!.removeMemberTooltip,
                              onPressed:
                                  currentUserEmail ==
                                      allowedEmailsState.emails.entries
                                          .firstWhere(
                                            (e) => e.value.userId == entry.key,
                                            orElse: () => MapEntry(
                                              '',
                                              AllowedEmailsBlocState_UserInfo(),
                                            ), // Return empty string if no match
                                          )
                                          .key
                                  ? null
                                  : () {
                                      final emailToRemove = allowedEmailsState
                                          .emails
                                          .entries
                                          .firstWhere(
                                            (e) => e.value.userId == entry.key,
                                            orElse: () => MapEntry(
                                              '',
                                              AllowedEmailsBlocState_UserInfo(),
                                            ),
                                          )
                                          .key;
                                      final newEmails = allowedEmailsState
                                          .emails
                                          .keys
                                          .where((e) => e != emailToRemove)
                                          .toList();
                                      final bloom = BloomFilterProcessor(
                                        size: serviceState.filter.size,
                                        hashCount:
                                            serviceState.filter.hashCount,
                                      )..addAll(newEmails);

                                      final submitValue = SubmitServiceEvent(
                                        email: currentUserEmail,
                                        removeServiceAdminEmail: emailToRemove,
                                        event: ServiceEvent(
                                          removeServiceAdmin:
                                              ServiceEvent_RemoveServiceAdmin(
                                                id: entry.key,
                                                filter: BloomFilter()
                                                  ..size = bloom.size
                                                  ..hashCount = bloom.hashCount
                                                  ..bitArray = bloom.bitArray,
                                              ),
                                          version:
                                              serviceState.events.keys
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
                                        '${RemoveServiceAdminRoute.fullPath}?event=$encodedSubmitValue',
                                      );
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    if (serviceState.removedServiceAdmins.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          HyttaHubLocalizations.of(
                            context,
                          )!.removedMembersTitle,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      ...serviceState.removedServiceAdmins.entries.map(
                        (entry) => ListTile(
                          title: Text(entry.value.alias),
                          trailing: IconButton(
                            icon: const Icon(Icons.restore),
                            tooltip: HyttaHubLocalizations.of(
                              context,
                            )!.restoreMemberTooltip,
                            onPressed: () {
                              final submitValue = SubmitServiceEvent(
                                email: currentUserEmail,
                                addServiceAdminEmail: '',
                                event: ServiceEvent(
                                  restoreServiceAdmin:
                                      ServiceEvent_RestoreServiceAdmin(
                                        id: entry.key,
                                        alias: entry.value.alias,
                                      ),
                                  version:
                                      serviceState.events.keys.fold<int>(
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
                                '${RestoreServiceAdminRoute.fullPath}?event=$encodedSubmitValue',
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
