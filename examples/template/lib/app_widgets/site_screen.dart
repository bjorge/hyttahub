import 'dart:convert';
import 'dart:typed_data';

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
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/storage/hyttahub_storage_factory.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/utilities/app_wrapper_util.dart';

class SiteScreen extends StatefulWidget {
  const SiteScreen({super.key, required this.siteId});

  final String siteId;

  @override
  State<SiteScreen> createState() => _SiteScreenState();
}

class _SiteScreenState extends State<SiteScreen> {
  final Map<String, Future<Uint8List>> _imageFetchFutures = {};

  Future<Uint8List> _getSignedUrl(String fileName) {
    if (_imageFetchFutures.containsKey(fileName)) {
      return _imageFetchFutures[fileName]!;
    }

    final future = () async {
      final storage = HyttaHubStorageFactory.getStorage(
        HyttaHubOptions.implementation?.storage ?? StorageEnum.firestore,
      );
      return storage.getFileBytes(
        appName: HyttaHubOptions.implementation?.firebaseRootCollection ?? '',
        siteId: widget.siteId,
        fileName: fileName,
      );
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
                title: Text(AppLocalizations.of(context)!.app_accessDeniedTitle),
              ),
              body: Center(
                child: Text(
                  AppLocalizations.of(context)!.app_accessDeniedMessage,
                ),
              ),
            );
          }

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
                  final authorId = userId ?? 0;

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
                        AppStateAndButtons(
                          siteId: widget.siteId,
                          authorId: authorId,
                          isEditModeOn: isEditModeOn,
                          getSignedUrl: _getSignedUrl,
                        ),
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

class AppStateAndButtons extends StatelessWidget {
  const AppStateAndButtons({
    super.key,
    required this.siteId,
    required this.authorId,
    required this.isEditModeOn,
    required this.getSignedUrl,
  });

  final String siteId;
  final int authorId;
  final bool isEditModeOn;
  final Future<Uint8List> Function(String) getSignedUrl;

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
            _buildRow(
              context: context,
              label: "Text",
              value: appState.textValue,
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
            ),
            _buildRow(
              context: context,
              label: "Code",
              value: appState.codeValue,
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
            ),
            _buildRow(
              context: context,
              label: "Checkbox",
              value: appState.checkboxValue.toString(),
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
            ),
            _buildRow(
              context: context,
              label: "Dropdown",
              value: appState.dropdownValue,
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
            ),
            _buildRow(
              context: context,
              label: "List",
              buttonText: "Reorder List",
              value: appState.listItems.map((e) => e.title).join(', '),
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
            ),
            _buildPhotoRow(
              context: context,
              label: "Photo",
              value: "${appState.photoName} (v${appState.photoVersion})",
              photoVersion: appState.photoVersion,
              onPressed: () {
                final appEvent = AppEvent(
                  updatePhoto: AppEvent_UpdatePhoto(
                    name: appState.photoName,
                    version: appState.photoVersion,
                  ),
                );
                _navigateToUpdate(
                  context,
                  appEvent,
                  version,
                  email,
                  AddPhotoRoute.fullPath(siteId: siteId),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildRow({
    required BuildContext context,
    required String label,
    String? buttonText,
    required String value,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child:
                isEditModeOn
                    ? TextButton(
                      onPressed: onPressed,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        buttonText ?? "Update $label",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                    : Row(
                      children: [
                        Text(
                          "$label:",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoRow({
    required BuildContext context,
    required String label,
    required String value,
    required int photoVersion,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRow(
          context: context,
          label: label,
          value: photoVersion > 0 ? value : "No photo",
          onPressed: onPressed,
        ),
        if (photoVersion > 0 && isEditModeOn)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                const SizedBox(width: 150),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    final appReplayBloc = context.read<AppReplayBloc>();

                    final storage = HyttaHubStorageFactory.getStorage(
                      HyttaHubOptions.implementation?.storage ??
                          StorageEnum.firestore,
                    );
                    final appName =
                        HyttaHubOptions.implementation
                            ?.firebaseRootCollection ??
                        '';

                    try {
                      await storage.deleteFiles(
                        appName: appName,
                        siteId: siteId,
                        fileNames: [photoVersion.toString()],
                      );

                      final appEvent = AppEvent(
                        updatePhoto: AppEvent_UpdatePhoto(name: "", version: 0),
                      );

                      // Now base64 encode the event part
                      final siteEvent = SiteEvent(
                        version: _calculateVersion(appReplayBloc.state.events),
                        appEvent: packAppEventWrapper(
                          appEvent.writeToBuffer(),
                        ),
                        author: authorId,
                      );

                      final encodedEvent = base64Encode(
                        siteEvent.writeToBuffer(),
                      );

                      await storage.setDocument(
                        firebaseSiteEventsPath(siteId),
                        siteEvent.version.toString(),
                        {
                          fbPayload: encodedEvent,
                          fbVersion: siteEvent.version,
                          fbTimeStamp: storage.serverTimestamp,
                        },
                      );

                      scaffoldMessenger.showSnackBar(
                        const SnackBar(content: Text('Photo deleted')),
                      );
                    } catch (e) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text('Error deleting photo: $e')),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: Colors.red,
                  ),
                  child: const Text(
                    "Delete Photo",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        if (photoVersion > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 150,
                  child: FutureBuilder<Uint8List>(
                    future: getSignedUrl(photoVersion.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 100,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Icon(Icons.error, size: 50);
                      }

                      return Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                const Spacer(),
              ],
            ),
          ),
      ],
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
