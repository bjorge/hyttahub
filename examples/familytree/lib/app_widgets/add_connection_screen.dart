// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:familytree/app_blocs/app_submit_bloc.dart';
import 'package:familytree/app_widgets/app_submit_button.dart';
import 'package:familytree/l10n/intl_localizations.dart';

import 'package:familytree/proto/app_events.pb.dart';
import 'package:familytree/proto/app_replay_bloc.pb.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:hyttahub/utilities/app_wrapper_util.dart';
import 'package:protobuf/protobuf.dart';

class AddConnectionScreen extends StatefulWidget {
  const AddConnectionScreen({
    super.key,
    required this.event,
    required this.siteId,
    required this.treeId,
    required this.fromTreeMemberId,
  });

  final String event;
  final String siteId;
  final int treeId;
  final int fromTreeMemberId;

  @override
  State<AddConnectionScreen> createState() => _AddConnectionScreenState();
}

class _AddConnectionScreenState extends State<AddConnectionScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final submitEvent = SubmitAppEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<AppSubmitBloc>(
          create: (_) => AppSubmitBloc(widget.siteId, submitEvent),
        ),
        BlocProvider<SiteReplayBloc>(
          create:
              (_) =>
                  SiteReplayBloc(widget.siteId)
                    ..add(CommonReplayBlocEvent(listen: true)),
        ),
      ],
      child: Form(
        key: _formKey,
        child: BlocConsumer<AppSubmitBloc, BaseSubmitState<SubmitAppEvent>>(
          builder: (context, submitState) {
            final l10n = AppLocalizations.of(context)!;
            return Scaffold(
              appBar: AppBar(
                title: Text(l10n.app_addConnectionTitle),
                actions: [AppSubmitIconButton(formKey: _formKey)],
              ),
              body: _buildBody(context, submitState),
            );
          },
          listener: (
            BuildContext context,
            BaseSubmitState<SubmitAppEvent> state,
          ) {
            if (state.submissionState.state ==
                CommonSubmitBlocState_State.success) {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    BaseSubmitState<SubmitAppEvent> submitState,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return CommonSubmitFormLayout<SubmitAppEvent>(
      submitState: submitState,
      children: [
        BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
          builder: (context, siteState) {
            if (!siteState.hasState()) {
              return const CircularProgressIndicator();
            }

            final appBlocState =
                unpackAppReplayWrapper(
                  siteState.appBlocState,
                  () => AppReplayBlocState(),
                )!;

            final treeInfo = appBlocState.trees.firstWhere(
              (test) => test.id == widget.treeId,
            );

            return Column(
              children: [
                _ToTreeMemberIdDropdown(
                  formKey: _formKey,
                  items:
                      treeInfo.treePersons
                          .where((test) => test.id != widget.fromTreeMemberId)
                          .map((person) {
                            return DropdownMenuItem(
                              value: person.id,
                              child: Text(person.name),
                            );
                          })
                          .toList(),
                  labelText: l10n.app_selectMember,
                ),
                _ConnectionTypeDropdown(
                  formKey: _formKey,
                  labelText: l10n.app_selectConnectionType,
                  l10n: l10n,
                ),
                _InfoTextField(
                  formKey: _formKey,
                  labelText: l10n.app_infoLabel,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ToTreeMemberIdDropdown
    extends
        BaseDropdownFormField<
          AppSubmitBloc,
          AppEventSubmission,
          SubmitAppEvent,
          int
        > {
  const _ToTreeMemberIdDropdown({
    required super.formKey,
    required super.items,
    required super.labelText,
  }) : super(eventFactory: AppEventSubmission.new);

  @override
  int? getValueFromPayload(SubmitAppEvent payload) {
    return payload.appEvent.addConnection.hasToTreeMemberId()
        ? payload.appEvent.addConnection.toTreeMemberId
        : null;
  }

  @override
  SubmitAppEvent updatePayload(SubmitAppEvent originalPayload, int? newValue) {
    final updatedPayload = originalPayload.deepCopy();
    if (newValue != null) {
      updatedPayload.appEvent.addConnection.toTreeMemberId = newValue;
    }
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, int? value) {
    if (value == null) {
      return AppLocalizations.of(context)!.app_pleaseSelectMemberError;
    }
    return null;
  }
}

class _ConnectionTypeDropdown
    extends
        BaseDropdownFormField<
          AppSubmitBloc,
          AppEventSubmission,
          SubmitAppEvent,
          TreeConnectionType
        > {
  _ConnectionTypeDropdown({
    required super.formKey,
    required super.labelText,
    required AppLocalizations l10n,
  }) : super(
         eventFactory: AppEventSubmission.new,
         items:
             TreeConnectionType.values.map((type) {
               return DropdownMenuItem(
                 value: type,
                 child: Text(_connectionTypeToString(l10n, type)),
               );
             }).toList(),
       );

  static String _connectionTypeToString(
    AppLocalizations l10n,
    TreeConnectionType type,
  ) {
    // final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case TreeConnectionType.partner:
        return l10n.app_connectionTypePartner;
      case TreeConnectionType.exPartner:
        return l10n.app_connectionTypeExPartner;
      case TreeConnectionType.child:
        return l10n.app_connectionTypeChild;
      case TreeConnectionType.friend:
        return l10n.app_connectionTypeFriend;
      case TreeConnectionType.parent:
        return l10n.app_connectionTypeParent;
      case TreeConnectionType.pet:
        return l10n.app_connectionTypePet;
      default:
        return l10n.app_connectionTypeConnections;
    }
  }

  @override
  TreeConnectionType? getValueFromPayload(SubmitAppEvent payload) {
    return payload.appEvent.addConnection.connection.hasType()
        ? payload.appEvent.addConnection.connection.type
        : null;
  }

  @override
  SubmitAppEvent updatePayload(
    SubmitAppEvent originalPayload,
    TreeConnectionType? newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    if (newValue != null) {
      updatedPayload.appEvent.addConnection.connection.type = newValue;
    }
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, TreeConnectionType? value) {
    if (value == null) {
      return AppLocalizations.of(context)!.app_pleaseSelectConnectionType;
    }
    return null;
  }
}

class _InfoTextField
    extends
        BaseTextFormField<AppSubmitBloc, AppEventSubmission, SubmitAppEvent> {
  const _InfoTextField({required super.formKey, required super.labelText})
    : super(eventFactory: AppEventSubmission.new);

  @override
  String getValueFromPayload(SubmitAppEvent payload) {
    return payload.appEvent.addConnection.connection.info;
  }

  @override
  SubmitAppEvent updatePayload(
    SubmitAppEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.appEvent.addConnection.connection.info = newValue;
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, String value) {
    return null; // Optional field
  }
}
