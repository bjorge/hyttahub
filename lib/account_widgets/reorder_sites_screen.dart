// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/account_blocs/account_replay_bloc.dart';
import 'package:hyttahub/account_blocs/account_submit_bloc.dart';
import 'package:hyttahub/account_widgets/account_submit_button.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/proto/account_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/site_widgets/site_name_widget.dart';
import 'package:protobuf/protobuf.dart';

class ReorderSitesScreen extends StatefulWidget {
  const ReorderSitesScreen({super.key, required this.event});

  final String event;

  @override
  State<ReorderSitesScreen> createState() => _ReorderSitesScreenState();
}

class _ReorderSitesScreenState extends State<ReorderSitesScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userEmail = context.read<AuthBloc>().state.email;

    final submitEvent = SubmitAccountEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<AccountReplayBloc>(
          create:
              (_) =>
                  AccountReplayBloc(
                    userEmail,
                  )..add(CommonReplayBlocEvent(listen: true)),
        ),
        BlocProvider<AccountSubmitBloc>(
          create: (_) => AccountSubmitBloc(userEmail, submitEvent),
        ),
      ],
      child: Form(
        key: _formKey,
        child: BlocConsumer<AccountSubmitBloc, BaseSubmitState<SubmitAccountEvent>>(
          builder: (context, submitState) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  HyttaHubLocalizations.of(context)!.reorderSitesTitle,
                ),
                actions: [AccountSubmitIconButton(formKey: _formKey)],
              ),
              body: CommonSubmitFormLayout<SubmitAccountEvent>(
                submitState: submitState,
                children: [
                  ReorderSitesFormField(
                    formKey: _formKey,
                    labelText: HyttaHubLocalizations.of(context)!.reorderSitesTitle,
                  ),
                ],
              ),
            );
          },
          listener: (BuildContext context, BaseSubmitState<SubmitAccountEvent> state) {
            if (state.submissionState.state == CommonSubmitBlocState_State.success) {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}

class ReorderSitesFormField extends BaseReorderableFormField<
    AccountSubmitBloc,
    AccountEventSubmission,
    SubmitAccountEvent
> {
  const ReorderSitesFormField({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: accountEventSubmissionFactory);

  @override
  List<ReorderableItem> getItemsFromPayload(
    BuildContext context,
    SubmitAccountEvent payload,
  ) {
    final siteIds = payload.event.reorderSites.siteIds;
    return List.generate(
      siteIds.length,
      (index) {
        final siteId = siteIds[index];
        return ReorderableItem(
          id: siteId.hashCode,
          title: siteId,
          leading: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: SiteNameDisplay(collectionName: siteId),
          ),
        );
      },
    );
  }

  @override
  SubmitAccountEvent updatePayload(
    SubmitAccountEvent originalPayload,
    List<ReorderableItem> newItems,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    final newSiteIds = newItems.map((item) => item.title).toList();
    updatedPayload.event.reorderSites.siteIds.clear();
    updatedPayload.event.reorderSites.siteIds.addAll(newSiteIds);
    return updatedPayload;
  }
}
