// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/common_widgets/common_form.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:albums/l10n/app_localizations.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:albums/app_blocs/app_submit_bloc.dart';
import 'package:albums/app_widgets/app_submit_button.dart';
import 'package:albums/proto/app_events.pb.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';
import 'package:hyttahub/utilities/app_wrapper_util.dart';
import 'package:albums/proto/app_replay_bloc.pb.dart';

class ReorderPhotosScreen extends StatefulWidget {
  const ReorderPhotosScreen({
    super.key,
    required this.siteId,
    required this.albumId,
    required this.event,
  });

  final String siteId;
  final int albumId;
  final String event;

  @override
  State<ReorderPhotosScreen> createState() => _ReorderPhotosScreenState();
}

class _ReorderPhotosScreenState extends State<ReorderPhotosScreen> {
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
              title: Text(AppLocalizations.of(context)!.app_reorderPhotos),
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
                      ReorderPhotosInputWidget(
                        formKey: _formKey,
                        labelText:
                            AppLocalizations.of(context)!.app_reorderPhotos,
                        albumId: widget.albumId,
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

class ReorderPhotosInputWidget
    extends
        BaseReorderableFormField<
          AppSubmitBloc,
          AppEventSubmission,
          SubmitAppEvent
        > {
  final int albumId;

  const ReorderPhotosInputWidget({
    super.key,
    required super.formKey,
    required super.labelText,
    required this.albumId,
  }) : super(eventFactory: appEventSubmissionFactory);

  @override
  List<ReorderableItem> getItemsFromPayload(
    BuildContext context,
    SubmitAppEvent payload,
  ) {
    final siteState = context.read<SiteReplayBloc>().state;
    final appBlocState = unpackAppReplayWrapper(
      siteState.appBlocState,
      () => AppReplayBlocState(),
    );
    final album = appBlocState.albums.firstWhere(
      (a) => a.id == albumId,
      orElse: () => AppReplayBlocState_AlbumInfo(),
    );

    return payload.appEvent.reorderPhotos.photoIds.map((id) {
      final photoInfo = album.photos.firstWhere(
        (p) => p.id == id,
        orElse: () => AppReplayBlocState_Photo(),
      );
      final photoName =
          photoInfo.name.isNotEmpty ? photoInfo.name : id.toString();

      return ReorderableItem(
        id: id,
        title: photoName,
        leading: const Icon(Icons.photo),
      );
    }).toList();
  }

  @override
  SubmitAppEvent updatePayload(
    SubmitAppEvent originalPayload,
    List<ReorderableItem> newItems,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.appEvent.reorderPhotos.photoIds
      ..clear()
      ..addAll(newItems.map((item) => item.id).toList());
    return updatedPayload;
  }
}
