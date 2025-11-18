// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:familytree/l10n/intl_localizations.dart';
import 'package:familytree/proto/app_replay_bloc.pb.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:familytree/app_blocs/app_submit_bloc.dart';
import 'package:familytree/app_widgets/app_submit_button.dart';
import 'package:familytree/proto/app_events.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/utilities/app_wrapper_util.dart';
import 'package:protobuf/protobuf.dart';

class ReorderTreesScreen extends StatefulWidget {
  const ReorderTreesScreen({
    super.key,
    required this.siteId,
    required this.event,
  });

  final String siteId;
  final String event;

  @override
  State<ReorderTreesScreen> createState() => _ReorderTreesScreenState();
}

class _ReorderTreesScreenState extends State<ReorderTreesScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final initialSubmitEvent = SubmitAppEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<AppSubmitBloc>(
          create: (_) => AppSubmitBloc(widget.siteId, initialSubmitEvent),
        ),
        BlocProvider<SiteReplayBloc>(
          create:
              (_) =>
                  SiteReplayBloc(widget.siteId)
                    ..add(CommonReplayBlocEvent(listen: true)),
        ),
      ],
      child: BlocConsumer<AppSubmitBloc, BaseSubmitState<SubmitAppEvent>>(
        listener: (context, submitState) {
          if (submitState.submissionState.state ==
              CommonSubmitBlocState_State.success) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, submitState) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.app_reorderTreesTitle),
              actions: [AppSubmitIconButton(formKey: _formKey)],
            ),
            body: Form(
              key: _formKey,
              child: BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
                builder: (context, siteState) {
                  if (!siteState.hasState() ||
                      siteState.state == CommonReplayStateEnum.fetchingConfig) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return CommonSubmitFormLayout<SubmitAppEvent>(
                    submitState: submitState,
                    singleChildScrollView: true,
                    children: [
                      ReorderTreesInputWidget(
                        key: const Key("reorderTrees"),
                        formKey: _formKey,
                        labelText: l10n.app_reorderTreesTitle,
                        eventFactory: appEventSubmissionFactory,
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class ReorderTreesInputWidget
    extends
        BaseReorderableFormField<
          AppSubmitBloc,
          AppEventSubmission,
          SubmitAppEvent
        > {
  const ReorderTreesInputWidget({
    super.key,
    required super.formKey,
    required super.labelText,
    required super.eventFactory,
  });

  @override
  List<ReorderableItem> getItemsFromPayload(
    BuildContext context,
    SubmitAppEvent payload,
  ) {
    final siteState = context.read<SiteReplayBloc>().state;
    final treeIds = payload.appEvent.reorderTrees.treeIds;
    final appBlocState = unpackAppReplayWrapper(
      siteState.appBlocState,
      () => AppReplayBlocState(),
    );
    return treeIds.map((id) {
      final treeName =
          appBlocState.trees.firstWhere((test) => test.id == id).name;
      return ReorderableItem(
        id: id,
        title: treeName,
        leading: const Icon(Icons.account_tree_outlined),
      );
    }).toList();
  }

  @override
  SubmitAppEvent updatePayload(
    SubmitAppEvent originalPayload,
    List<ReorderableItem> newItems,
  ) {
    final newPayload = originalPayload.deepCopy();
    final newTreeIds = newItems.map((item) => item.id).toList();
    newPayload.appEvent.reorderTrees.treeIds
      ..clear()
      ..addAll(newTreeIds);
    return newPayload;
  }
}
