// Copyright (c) 2025 bjorge

import 'package:hyttahub/common_blocs/allowed_emails_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Abstract configuration to drive the generic [AllowedEmailsDisplay] widget.
abstract class AllowedEmailsDisplayConfig {
  String get collectionPath;
  String get screenTitle;
}

/// A generic screen for displaying a list of allowed emails from Firestore.
class AllowedEmailsDisplay extends StatefulWidget {
  const AllowedEmailsDisplay({super.key, required this.config});

  final AllowedEmailsDisplayConfig config;

  @override
  State<AllowedEmailsDisplay> createState() => _AllowedEmailsDisplayState();
}

class _AllowedEmailsDisplayState extends State<AllowedEmailsDisplay> {
  @override
  Widget build(BuildContext context) {
    final l10n = HyttaHubLocalizations.of(context)!;
    return BlocProvider<AllowedEmailsBloc>(
      create: (_) => AllowedEmailsBloc(widget.config.collectionPath)
        ..add(
          AllowedEmailsBlocEvent(
            fetchNow: AllowedEmailsBlocEvent_FetchedAllowedEmails(),
          ),
        ),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.config.screenTitle)),
        body: BlocBuilder<AllowedEmailsBloc, AllowedEmailsBlocState>(
          builder: (context, state) {
            if (state.state == AllowedEmailsBlocState_State.fetching) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.state == AllowedEmailsBlocState_State.error) {
              return Center(child: Text(l10n.failedToLoadEmails));
            }
            if (state.state == AllowedEmailsBlocState_State.permissionDenied) {
              return Center(child: Text(l10n.permissionDeniedViewList));
            }
            if (state.emails.isEmpty) {
              return Center(child: Text(l10n.noEmailsFound));
            }

            final sortedEmails = state.emails.entries.toList()
              ..sort((a, b) => a.key.compareTo(b.key));

            return ListView.builder(
              itemCount: sortedEmails.length,
              itemBuilder: (context, index) {
                final entry = sortedEmails[index];
                final email = entry.key;
                final userInfo = entry.value;

                return ListTile(
                  title: Text(email),
                  subtitle: Text(l10n.userId(userInfo.userId)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
