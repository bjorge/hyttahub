import 'dart:convert';

import 'package:template/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/app_blocs/app_replay_bloc.dart';
import 'package:template/proto/app_events.pb.dart';
import 'package:template/proto/app_replay_bloc.pb.dart';
import 'package:template/routers/app_routes.dart';
import 'package:template/utilities/handle_app_bloc_errors.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/common_blocs/allowed_emails_bloc.dart';
import 'package:hyttahub/common_widgets/layout.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:hyttahub/site_widgets/site_edit_mode_cubit.dart';
import 'package:hyttahub/site_widgets/site_screen_settings_button.dart';
import 'package:hyttahub/utilities/common_error_handling.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class SiteScreen extends StatefulWidget {
  const SiteScreen({super.key, required this.siteId});

  final String siteId;

  @override
  State<SiteScreen> createState() => _SiteScreenState();
}

class _SiteScreenState extends State<SiteScreen> {
  final Map<String, Future<Uint8List>> _imageFetchFutures = {};

  Future<String> _fetchDownloadUrl(String fileName) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'getFile',
    );
    final result = await callable.call(<String, dynamic>{
      'appName': HyttaHubOptions.firebaseRootCollection,
      'siteId': widget.siteId,
      'fileName': fileName,
    });
    final data = result.data as Map<String, dynamic>;
    return data['downloadUrl'] as String;
  }

  Future<Uint8List> _getSignedUrl(String fileName) {
    if (_imageFetchFutures.containsKey(fileName)) {
      return _imageFetchFutures[fileName]!;
    }

    final future = () async {
      final downloadUrl = await _fetchDownloadUrl(fileName);
      final response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      throw Exception('Failed to download bytes: ${response.statusCode}');
    }();

    _imageFetchFutures[fileName] = future;
    return future;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SiteReplayBloc>(
          key: Key('SiteReplayBloc-albums-${widget.siteId}'),
          create:
              (_) =>
                  SiteReplayBloc(widget.siteId)
                    ..add(CommonReplayBlocEvent(listen: true)),
        ),
        BlocProvider<AppReplayBloc>(
          key: Key('AppReplayBloc-albums-${widget.siteId}'),
          create:
              (_) =>
                  AppReplayBloc(widget.siteId)
                    ..add(CommonReplayBlocEvent(listen: true)),
        ),
        BlocProvider<AllowedEmailsBloc>(
          create:
              (_) =>
                  AllowedEmailsBloc(firebaseSiteUsersPath(widget.siteId))..add(
                    AllowedEmailsBlocEvent(
                      fetchNow: AllowedEmailsBlocEvent_FetchedAllowedEmails(),
                    ),
                  ),
        ),
      ],
      child: BlocBuilder<AllowedEmailsBloc, AllowedEmailsBlocState>(
        key: Key('AllowedEmailsBloc-site-screen-${widget.siteId}'),
        builder: (context, allowedEmailsState) {
          if (!allowedEmailsState.hasState() ||
              allowedEmailsState.state ==
                  AllowedEmailsBlocState_State.fetching) {
            return const Center(child: CircularProgressIndicator());
          }

          if (allowedEmailsState.state == AllowedEmailsBlocState_State.error) {
            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.app_errorTitle),
              ),
              body: Center(
                child: Text(AppLocalizations.of(context)!.app_unexpectedError),
              ),
            );
          }

          if (allowedEmailsState.state ==
              AllowedEmailsBlocState_State.permissionDenied) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  AppLocalizations.of(context)!.app_accessDeniedTitle,
                ),
              ),
              body: Center(
                child: Text(
                  AppLocalizations.of(context)!.app_accessDeniedMessage,
                ),
              ),
            );
          }

          // ignore: unused_local_variable
          final userId =
              allowedEmailsState
                  .emails[GetIt.instance<AuthBloc>().state.email]
                  ?.userId;

          return BlocBuilder<SiteEditModeCubit, bool?>(
            builder: (context, editModeState) {
              return BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
                builder: (context, siteState) {
                  final errorWidget = handleSiteReplayState(context, siteState);
                  if (errorWidget != null) {
                    return errorWidget;
                  }

                  final isAdmin = siteState.members[userId]?.admin ?? false;

                  if (isAdmin && editModeState == null) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(
                          AppLocalizations.of(context)!.app_editModeTitle,
                        ),
                      ),
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.app_adminPrivileges,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              AppLocalizations.of(context)!.app_howToProceed,
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed:
                                      () =>
                                          context
                                              .read<SiteEditModeCubit>()
                                              .editModeOff(),
                                  icon: const Icon(Icons.visibility),
                                  label: Text(
                                    AppLocalizations.of(context)!.app_viewSite,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                ElevatedButton.icon(
                                  onPressed:
                                      () =>
                                          context
                                              .read<SiteEditModeCubit>()
                                              .editModeOn(),
                                  icon: const Icon(Icons.edit),
                                  label: Text(
                                    AppLocalizations.of(context)!.app_editSite,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final isEditModeOn = editModeState ?? false;

                  return Scaffold(
                    appBar: AppBar(
                      title: const ScreenTitle(),
                      actions:
                          isEditModeOn
                              ? [
                                SiteSettingsButton(
                                  siteId: widget.siteId,
                                  appOptions: [
                                    SimpleDialogOption(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        context.push(
                                          AppEventsDisplayRoute.fullPath(
                                            siteId: widget.siteId,
                                          ),
                                        );
                                      },
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.app_appEventsOption,
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                              : null,
                    ),
                    body: CommonListViewLayout(
                      spacing: 10.0,
                      children: [
                        AppStateDisplay(getSignedUrl: _getSignedUrl),
                        if (isEditModeOn) UpdateButtons(siteId: widget.siteId),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class UpdateButtons extends StatelessWidget {
  const UpdateButtons({super.key, required this.siteId});

  final String siteId;

  int _calculateVersion(Map<int, String> events) {
    return events.isEmpty
        ? 1
        : events.keys.fold<int>(0, (p, e) => e > p ? e : p) + 1;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppReplayBloc, AppReplayBlocState>(
      builder: (context, appState) {
        final errorWidget = handleAppReplayState(context, appState);
        if (errorWidget != null) {
          return errorWidget;
        }

        final version = _calculateVersion(appState.events);
        final email = GetIt.instance<AuthBloc>().state.email;

        return Column(
          children: [
            ElevatedButton(
              onPressed: () {
                final appEvent = AppEvent(
                  updateText: AppEvent_UpdateText(value: appState.textValue),
                );
                _navigateToUpdate(
                  context,
                  appEvent,
                  version,
                  email,
                  UpdateTextRoute.fullPath(siteId),
                );
              },
              child: const Text("Update Text"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final appEvent = AppEvent(
                  updateCode: AppEvent_UpdateCode(value: appState.codeValue),
                );
                _navigateToUpdate(
                  context,
                  appEvent,
                  version,
                  email,
                  UpdateCodeRoute.fullPath(siteId),
                );
              },
              child: const Text("Update Code"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final appEvent = AppEvent(
                  updateCheckbox: AppEvent_UpdateCheckbox(
                    value: appState.checkboxValue,
                  ),
                );
                _navigateToUpdate(
                  context,
                  appEvent,
                  version,
                  email,
                  UpdateCheckboxRoute.fullPath(siteId),
                );
              },
              child: const Text("Update Checkbox"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final appEvent = AppEvent(
                  updateDropdown: AppEvent_UpdateDropdown(
                    value: appState.dropdownValue,
                  ),
                );
                _navigateToUpdate(
                  context,
                  appEvent,
                  version,
                  email,
                  UpdateDropdownRoute.fullPath(siteId),
                );
              },
              child: const Text("Update Dropdown"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final appEvent = AppEvent(
                  updateList: AppEvent_UpdateList(items: appState.listItems),
                );
                _navigateToUpdate(
                  context,
                  appEvent,
                  version,
                  email,
                  UpdateListRoute.fullPath(siteId),
                );
              },
              child: const Text("Update List"),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                // For Photo, we can keep using TemplateForm logic IF we haven't migrated logic yet,
                // BUT better to use UpdatePhoto if we update logic.
                // Let's assume we update PhotoUploadScreen to handle UpdatePhoto.
                // Or stick to TemplateForm for Photo for now as user didn't explicitly ask to change Photo structure, just "form item".
                // But Photo IS a form item.
                // Let's try to use UpdatePhoto.
                final appEvent = AppEvent(
                  updatePhoto: AppEvent_UpdatePhoto(
                    name: appState.photoName,
                    version: appState.photoVersion,
                    // size: appState.photoSize // photoSize not in state yet?
                    // Wait, we added photoSize to templateForm in proto, but maybe not state?
                    // Let's check state.
                  ),
                );
                // If photoSize is missing in state, default to 0.
                _navigateToUpdate(
                  context,
                  appEvent,
                  version,
                  email,
                  AddPhotoRoute.fullPath(siteId: siteId),
                );
              },
              icon: const Icon(Icons.photo_camera),
              label: const Text("Update Photo"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToUpdate(
    BuildContext context,
    AppEvent appEvent,
    int version,
    String email,
    String routePath,
  ) {
    final submitAppEvent = SubmitAppEvent(
      authorEmail: email,
      appEvent: appEvent,
      siteEvent: SubmitAppEvent_SiteEvent(version: version),
    );
    final encodedSubmitValue = base64UrlEncode(submitAppEvent.writeToBuffer());
    context.push('$routePath?event=$encodedSubmitValue');
  }
}

class AppStateDisplay extends StatelessWidget {
  const AppStateDisplay({super.key, required this.getSignedUrl});

  final Future<Uint8List> Function(String) getSignedUrl;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppReplayBloc, AppReplayBlocState>(
      builder: (context, appState) {
        final errorWidget = handleAppReplayState(context, appState);
        if (errorWidget != null) {
          return errorWidget;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Text: ${appState.textValue}"),
            Text("Code: ${appState.codeValue}"),
            Text("Checkbox: ${appState.checkboxValue}"),
            Text("Dropdown: ${appState.dropdownValue}"),
            Text("Items: ${appState.listItems.map((e) => e.title).join(', ')}"),
            if (appState.photoVersion > 0) ...[
              const SizedBox(height: 10),
              Text("Photo: ${appState.photoName} (v${appState.photoVersion})"),
              FutureBuilder<Uint8List>(
                future: getSignedUrl(appState.photoVersion.toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      width: 100,
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Icon(Icons.error, size: 100);
                  }

                  return Image.memory(
                    snapshot.data!,
                    height: 200,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ],
          ],
        );
      },
    );
  }
}

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
      builder: (context, siteState) {
        final errorWidget = handleSiteReplayState(context, siteState);
        if (errorWidget != null) {
          return errorWidget;
        }

        final siteName = siteState.name;

        return Text(siteName);
      },
    );
  }
}
