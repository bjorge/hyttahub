// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:albums/l10n/app_localizations.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:albums/app_blocs/app_submit_bloc.dart';
import 'package:albums/app_widgets/app_submit_button.dart';
import 'package:albums/proto/app_events.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';
import 'package:hyttahub/utilities/pack_any.dart';
import 'package:albums/proto/app_replay_bloc.pb.dart';

class ReorderAlbumsScreen extends StatefulWidget {
  const ReorderAlbumsScreen({
    super.key,
    required this.siteId,
    required this.event,
  });

  final String siteId;
  final String event;

  @override
  State<ReorderAlbumsScreen> createState() => _ReorderAlbumsScreenState();
}

class _ReorderAlbumsScreenState extends State<ReorderAlbumsScreen> {
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
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.app_reorderAlbumsTitle),
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
                      ReorderAlbumsInputWidget(
                        formKey: _formKey,
                        labelText:
                            AppLocalizations.of(context)!.app_reorderAlbumsTitle,
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

class ReorderAlbumsInputWidget
    extends
        BaseReorderableFormField<
          AppSubmitBloc,
          AppEventSubmission,
          SubmitAppEvent
        > {
  const ReorderAlbumsInputWidget({
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
    final appBlocState = unpackAny(siteState.appBlocState, () => AppReplayBlocState())!;
    final albumIds = payload.appEvent.reorderAlbums.albumIds;

    return albumIds.map((id) {
      final album = appBlocState.albums.firstWhere((a) => a.id == id, orElse: () => AppReplayBlocState_AlbumInfo());
      final albumName = album.name.isNotEmpty ? album.name : AppLocalizations.of(context)!.app_unknownAlbum;
      return ReorderableItem(
        id: id,
        title: albumName,
        leading: const Icon(Icons.photo_album_outlined),
      );
    }).toList();
  }

  @override
  SubmitAppEvent updatePayload(
    SubmitAppEvent originalPayload,
    List<ReorderableItem> newItems,
  ) {
    final newPayload = originalPayload.deepCopy();
    final newAlbumIds = newItems.map((item) => item.id).toList();
    newPayload.appEvent.reorderAlbums.albumIds
      ..clear()
      ..addAll(newAlbumIds);
    return newPayload;
  }
}
