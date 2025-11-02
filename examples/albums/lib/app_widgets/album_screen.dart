// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:albums/l10n/app_localizations.dart';
import 'package:albums/proto/app_events.pb.dart';
import 'package:albums/routers/app_routes.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/site_widgets/site_edit_mode_cubit.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import '../proto/app_replay_bloc.pb.dart';
import 'package:hyttahub/utilities/app_wrapper_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key, required this.albumId, required this.siteId});

  final int albumId;
  final String siteId;

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showCaption = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<String> _getSignedUrl(String fileName) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'getFile',
    );
    final result = await callable.call(<String, dynamic>{
      'appName': HyttaHubOptions.firebaseRootCollection,
      'siteId': widget.siteId,
      'fileName': fileName,
    });

    // Cloud Function returns: { uploadUrl: "https://..." }
    final data = result.data as Map<String, dynamic>;
    return data['downloadUrl'] as String;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SiteReplayBloc>(
          key: Key("album-screen-${widget.siteId}-${widget.albumId}"),
          create:
              (_) =>
                  SiteReplayBloc(widget.siteId)
                    ..add(CommonReplayBlocEvent(listen: true)),
        ),
      ],
      child: BlocConsumer<SiteReplayBloc, SiteReplayBlocState>(
        builder: (context, siteState) {
          // first check if the account state is initialized
          if (!siteState.hasState() ||
              siteState.state == CommonReplayStateEnum.fetchingConfig) {
            return const Center(child: CircularProgressIndicator());
          } else if (siteState.state == CommonReplayStateEnum.uninitialized) {
            throw UnimplementedError('Site state is uninitialized');
          }
          return Builder(
            builder: (context) {
              final appState =
                  unpackAppReplayWrapper(
                    siteState.appBlocState,
                    () => AppReplayBlocState(),
                  )!;

              final album = appState.albums.firstWhere(
                (test) => test.id == widget.albumId,
                orElse: () => AppReplayBlocState_AlbumInfo(),
              );
              if (album.id == 0) {
                // Album not found, maybe it was deleted.
                return Scaffold(
                  appBar: AppBar(),
                  body: Center(
                    child: Text(
                      AppLocalizations.of(context)!.app_albumNotFound,
                    ),
                  ),
                );
              }

              final photos = album.photos;
              final currentPhoto =
                  photos.isNotEmpty ? photos[_currentPage] : null;

              final isEditMode =
                  context.read<SiteEditModeCubit>().isEditModeConfigured() &&
                  (context.read<SiteEditModeCubit>().state ?? false);

              return Scaffold(
                appBar: AppBar(
                  title: Text(album.name),
                  actions: [
                    if (currentPhoto != null)
                      IconButton(
                        icon: Icon(
                          _showCaption ? Icons.subtitles_off : Icons.subtitles,
                        ),
                        tooltip:
                            _showCaption
                                ? AppLocalizations.of(
                                  context,
                                )!.app_hideCaptionTooltip
                                : AppLocalizations.of(
                                  context,
                                )!.app_showCaptionTooltip,
                        onPressed: () {
                          setState(() {
                            _showCaption = !_showCaption;
                          });
                        },
                      ),
                    if (isEditMode) ...[
                      if (currentPhoto != null)
                        PhotoActionsButton(
                          siteId: widget.siteId,
                          albumId: widget.albumId,
                          photo: currentPhoto,
                        ),
                      AlbumSettingsButton(
                        siteId: widget.siteId,
                        albumId: widget.albumId,
                      ),
                    ],
                  ],
                ),
                body:
                    photos.isEmpty
                        ? Center(
                          child: Text(
                            AppLocalizations.of(context)!.app_noPhotos,
                          ),
                        )
                        : Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              onPageChanged: (int page) {
                                setState(() {
                                  _currentPage = page;
                                });
                              },
                              itemCount: photos.length,
                              itemBuilder: (context, index) {
                                final photoInfo = photos[index];

                                return FutureBuilder<String>(
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Icon(Icons.error);
                                    } else {
                                      return InteractiveViewer(
                                        child: Image.network(
                                          snapshot.data!,
                                          fit: BoxFit.contain,
                                          loadingBuilder: (
                                            context,
                                            child,
                                            loadingProgress,
                                          ) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value:
                                                    loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                              ),
                                            );
                                          },
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return const Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                                size: 48.0,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  future: _getSignedUrl(
                                    photoInfo.id.toString(),
                                  ),
                                );
                              },
                            ),
                            // Page indicators
                            if (photos.length > 1)
                              Positioned(
                                bottom: 20.0,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(photos.length, (i) {
                                    return AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4.0,
                                      ),
                                      height: 8,
                                      width: _currentPage == i ? 24 : 8,
                                      decoration: BoxDecoration(
                                        color:
                                            _currentPage == i
                                                ? Theme.of(
                                                  context,
                                                ).colorScheme.primary
                                                : Colors.grey,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            // Left/Right navigation arrows for web/desktop
                            if (kIsWeb) ...[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(
                                      (0.5 * 255).toInt(),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_back_ios_new),
                                    color: Colors.white,
                                    onPressed:
                                        _currentPage > 0
                                            ? () =>
                                                _pageController.previousPage(
                                                  duration: const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  curve: Curves.easeOut,
                                                )
                                            : null,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(
                                      (0.5 * 255).toInt(),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_forward_ios),
                                    color: Colors.white,
                                    onPressed:
                                        _currentPage < photos.length - 1
                                            ? () => _pageController.nextPage(
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              curve: Curves.easeOut,
                                            )
                                            : null,
                                  ),
                                ),
                              ),
                            ],
                            if (_showCaption)
                              _buildCaption(context, currentPhoto),
                          ],
                        ),
              );
            },
          );
        },
        listener: (BuildContext context, SiteReplayBlocState state) {},
      ),
    );
  }

  Widget _buildCaption(BuildContext context, AppReplayBlocState_Photo? photo) {
    if (photo == null || photo.caption.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 60.0, // Above page indicators
      left: 16.0,
      right: 16.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha((0.7 * 255).toInt()),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          photo.caption,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
    );
  }
}

class AlbumSettingsButton extends StatelessWidget {
  const AlbumSettingsButton({
    super.key,
    required this.siteId,
    required this.albumId,
  });

  final String siteId;
  final int albumId;

  @override
  Widget build(BuildContext context) {
    final siteState = context.read<SiteReplayBloc>().state;
    final appState =
        unpackAppReplayWrapper(
          siteState.appBlocState,
          () => AppReplayBlocState(),
        )!;
    final album = appState.albums.firstWhere(
      (a) => a.id == albumId,
      orElse: () => AppReplayBlocState_AlbumInfo(),
    );

    return PopupMenuButton<String>(
      onSelected: (value) {
        final version =
            siteState.events.isEmpty
                ? 1
                : siteState.events.keys.fold<int>(0, (p, e) => e > p ? e : p) +
                    1;
        if (value == 'add_photo') {
          final submmitValue = SubmitAppEvent(
            authorEmail: GetIt.instance<AuthBloc>().state.email,
            appEvent: AppEvent(addPhoto: AppEvent_AddPhoto(albumId: albumId)),
            siteEvent: SubmitAppEvent_SiteEvent(version: version),
          );
          final encodedSubmitValue = base64UrlEncode(
            submmitValue.writeToBuffer(),
          );
          context.push(
            '${AddPhotoRoute.fullPath(siteId: siteId, albumId: albumId)}?event=$encodedSubmitValue',
          );
        } else if (value == 'reorder_photos') {
          final submmitValue = SubmitAppEvent(
            authorEmail: GetIt.instance<AuthBloc>().state.email,
            appEvent: AppEvent(
              reorderPhotos: AppEvent_ReorderPhotos(
                albumId: albumId,
                photoIds: album.photos.map((p) => p.id).toList(),
              ),
            ),
            siteEvent: SubmitAppEvent_SiteEvent(version: version),
          );
          final encodedSubmitValue = base64UrlEncode(
            submmitValue.writeToBuffer(),
          );
          context.push(
            '${ReorderPhotosRoute.fullPath(siteId: siteId, albumId: albumId)}?event=$encodedSubmitValue',
          );
        } else if (value == 'rename_album') {
          final submmitValue = SubmitAppEvent(
            authorEmail: GetIt.instance<AuthBloc>().state.email,
            appEvent: AppEvent(
              updateAlbum: AppEvent_UpdateAlbum(
                albumId: albumId,
                name: album.name,
              ),
            ),
            siteEvent: SubmitAppEvent_SiteEvent(version: version),
          );
          final encodedSubmitValue = base64UrlEncode(
            submmitValue.writeToBuffer(),
          );
          context.push(
            '${UpdateAlbumRoute.fullPath(siteId: siteId, albumId: albumId)}?event=$encodedSubmitValue',
          );
        } else if (value == 'delete_album') {
          final submmitValue = SubmitAppEvent(
            authorEmail: GetIt.instance<AuthBloc>().state.email,
            appEvent: AppEvent(
              deleteAlbum: AppEvent_DeleteAlbum(albumId: albumId),
            ),
            siteEvent: SubmitAppEvent_SiteEvent(version: version),
          );
          final encodedSubmitValue = base64UrlEncode(
            submmitValue.writeToBuffer(),
          );
          context.push(
            '${DeleteAlbumRoute.fullPath(siteId: siteId, albumId: albumId)}?event=$encodedSubmitValue',
          );
        }
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'add_photo',
              child: Text(AppLocalizations.of(context)!.app_addPhotosTitle),
            ),
            PopupMenuItem<String>(
              value: 'reorder_photos',
              child: Text(AppLocalizations.of(context)!.app_reorderPhotos),
            ),
            PopupMenuItem<String>(
              value: 'rename_album',
              child: Text(AppLocalizations.of(context)!.app_renameAlbumTitle),
            ),
            PopupMenuItem<String>(
              value: 'delete_album',
              child: Text(AppLocalizations.of(context)!.app_deleteAlbumTitle),
            ),
          ],
      icon: const Icon(Icons.settings),
    );
  }
}

class PhotoActionsButton extends StatelessWidget {
  const PhotoActionsButton({
    super.key,
    required this.siteId,
    required this.albumId,
    required this.photo,
  });

  final String siteId;
  final int albumId;
  final AppReplayBlocState_Photo photo;

  @override
  Widget build(BuildContext context) {
    final siteState = context.read<SiteReplayBloc>().state;

    return PopupMenuButton<String>(
      onSelected: (value) {
        final version =
            siteState.events.isEmpty
                ? 1
                : siteState.events.keys.fold<int>(0, (p, e) => e > p ? e : p) +
                    1;
        if (value == 'update_caption') {
          final submmitValue = SubmitAppEvent(
            authorEmail: GetIt.instance<AuthBloc>().state.email,
            appEvent: AppEvent(
              updateCaption: AppEvent_UpdateCaption(
                photoId: photo.id,
                caption: photo.caption,
              ),
            ),
            siteEvent: SubmitAppEvent_SiteEvent(version: version),
          );
          final encodedSubmitValue = base64UrlEncode(
            submmitValue.writeToBuffer(),
          );
          context.push(
            '${UpdatePhotoCaptionRoute.fullPath(siteId: siteId, albumId: albumId, photoId: photo.id)}?event=$encodedSubmitValue',
          );
        } else if (value == 'delete_photo') {
          final submmitValue = SubmitAppEvent(
            authorEmail: GetIt.instance<AuthBloc>().state.email,
            appEvent: AppEvent(
              deletePhoto: AppEvent_DeletePhoto(photoId: photo.id),
            ),
            siteEvent: SubmitAppEvent_SiteEvent(version: version),
          );
          final encodedSubmitValue = base64UrlEncode(
            submmitValue.writeToBuffer(),
          );
          context.push(
            '${DeletePhotoRoute.fullPath(siteId: siteId, albumId: albumId, photoId: photo.id)}?event=$encodedSubmitValue',
          );
        } else if (value == 'photo_info') {
          context.push(
            PhotoInfoRoute.fullPath(
              siteId: siteId,
              albumId: albumId,
              photoId: photo.id,
            ),
          );
        }
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'update_caption',
              child: Text(AppLocalizations.of(context)!.app_updateCaption),
            ),
            PopupMenuItem<String>(
              value: 'delete_photo',
              child: Text(AppLocalizations.of(context)!.app_deletePhotoTitle),
            ),
            PopupMenuItem<String>(
              value: 'photo_info',
              child: Text(AppLocalizations.of(context)!.app_photoInfoTitle),
            ),
          ],
      icon: const Icon(Icons.more_vert),
    );
  }
}
