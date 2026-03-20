// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/collection_paths.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/bloom_filter.pb.dart';
import 'package:hyttahub/proto/service_events.pb.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/service_blocs/service_replay_bloc.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/storage/hyttahub_storage_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ServiceAdminScreen extends StatelessWidget {
  const ServiceAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final serviceState = context.watch<ServiceReplayBloc>().state;
    final localizations = HyttaHubLocalizations.of(context)!;
    return BlocBuilder<ServiceReplayBloc, ServiceReplayBlocState>(
      builder: (context, serviceState) {
        return Scaffold(
          appBar: AppBar(
            leading: context.canPop()
                ? BackButton(onPressed: () => context.pop())
                : null,
            title: Text(localizations.serviceAdminTitle),
          ),
          body: ListView(
            children: <Widget>[
              ServiceAvailableOption(serviceState: serviceState),
              ServiceMinVersionOption(serviceState: serviceState),
              ServiceTermsOption(serviceState: serviceState),
              ServicePrivacyOption(serviceState: serviceState),
              ServiceBetaUsersOption(serviceState: serviceState),
              ListTile(
                title: Text(localizations.manageServiceAdminsTitle),
                onTap: () {
                  context.push(ServiceAdminsRoute.fullPath);
                },
              ),
              ListTile(
                title: Text(localizations.showServiceEventsStateTitle),
                onTap: () {
                  context.push(ServiceEventsDisplayRoute.fullPath);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class ServiceAvailableOption extends StatelessWidget {
  const ServiceAvailableOption({super.key, required this.serviceState});

  final ServiceReplayBlocState serviceState;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(HyttaHubLocalizations.of(context)!.serviceStatusTitle),
      onTap: () {
        final submmitValue = SubmitServiceEvent(
          email: context.read<AuthBloc>().state.email,
          event: ServiceEvent(
            serviceStatus: ServiceEvent_ServiceStatus(
              unavailable: serviceState.serviceUnavailable,
            ),
            version: serviceState.nextVersion,
          ),
        );

        final encodedSubmitValue = base64UrlEncode(
          submmitValue.writeToBuffer(),
        );

        context.push(
          '${ServiceOptionsRoute.fullPath}?event=$encodedSubmitValue',
        );
      },
    );
  }
}

class ServiceMinVersionOption extends StatelessWidget {
  const ServiceMinVersionOption({super.key, required this.serviceState});

  final ServiceReplayBlocState serviceState;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(HyttaHubLocalizations.of(context)!.minRequiredVersionTitle),
      onTap: () {
        final submmitValue = SubmitServiceEvent(
          email: context.read<AuthBloc>().state.email,
          event: ServiceEvent(
            minVersion: ServiceEvent_MinimumVersionRequired(
              value: serviceState.minVersion,
            ),
            version: serviceState.nextVersion,
          ),
        );

        final encodedSubmitValue = base64UrlEncode(
          submmitValue.writeToBuffer(),
        );

        context.push(
          '${ServiceOptionsRoute.fullPath}?event=$encodedSubmitValue',
        );
      },
    );
  }
}

class ServiceBetaUsersOption extends StatelessWidget {
  const ServiceBetaUsersOption({super.key, required this.serviceState});

  final ServiceReplayBlocState serviceState;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(HyttaHubLocalizations.of(context)!.manageBetaUsersTitle),
      onTap: () async {
        String currentBetaUsers = '';
        try {
          final storage = HyttaHubStorageFactory.getStorage(
            HyttaHubOptions.implementation!.storage,
          );
          final path = collectionServiceBetaUsersPath();
          final lastSlashIndex = path.lastIndexOf('/');
          final parentPath = path.substring(0, lastSlashIndex);
          final docId = path.substring(lastSlashIndex + 1);
          final data = await storage.getDocument(parentPath, docId);
          if (data != null && data.containsKey(fbBetaUsers) == true) {
            currentBetaUsers = data[fbBetaUsers] as String;
          }
        } catch (e) {
          if (context.mounted) {
            showCommonSnackBar(
              context,
              Text(HyttaHubLocalizations.of(context)!.errorFetchingBetaUsers),
            );
          }
        }

        final submmitValue = SubmitServiceEvent(
          email: context.read<AuthBloc>().state.email,
          betaUsers: currentBetaUsers,
          event: ServiceEvent(
            betaUsersFilter: serviceState.hasBetaUsersFilter()
                ? serviceState.betaUsersFilter
                : BloomFilter(),
            version: serviceState.nextVersion,
          ),
        );

        final encodedSubmitValue = base64UrlEncode(
          submmitValue.writeToBuffer(),
        );

        if (!context.mounted) return;
        context.push(
          '${ServiceOptionsRoute.fullPath}?event=$encodedSubmitValue',
        );
      },
    );
  }
}

class ServiceTermsOption extends StatelessWidget {
  const ServiceTermsOption({super.key, required this.serviceState});

  final ServiceReplayBlocState serviceState;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(HyttaHubLocalizations.of(context)!.newTermsOfServiceTitle),
      onTap: () {
        final submmitValue = SubmitServiceEvent(
          email: context.read<AuthBloc>().state.email,
          event: ServiceEvent(
            terms: ServiceEvent_TermsOfService(content: serviceState.terms),
            version: serviceState.nextVersion,
          ),
        );

        final encodedSubmitValue = base64UrlEncode(
          submmitValue.writeToBuffer(),
        );

        context.push(
          '${ServiceOptionsRoute.fullPath}?event=$encodedSubmitValue',
        );
      },
    );
  }
}

class ServicePrivacyOption extends StatelessWidget {
  const ServicePrivacyOption({super.key, required this.serviceState});

  final ServiceReplayBlocState serviceState;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(HyttaHubLocalizations.of(context)!.newPrivacyPolicyTitle),
      onTap: () {
        final submmitValue = SubmitServiceEvent(
          email: context.read<AuthBloc>().state.email,
          event: ServiceEvent(
            privacy: ServiceEvent_PrivacyPolicy(content: serviceState.privacy),
            version: serviceState.nextVersion,
          ),
        );

        final encodedSubmitValue = base64UrlEncode(
          submmitValue.writeToBuffer(),
        );

        context.push(
          '${ServiceOptionsRoute.fullPath}?event=$encodedSubmitValue',
        );
      },
    );
  }
}
