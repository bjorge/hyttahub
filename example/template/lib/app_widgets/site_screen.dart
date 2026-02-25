import 'dart:convert';
import 'dart:typed_data';

import 'package:template/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/app_blocs/app_replay_bloc.dart';
import 'package:template/routers/app_routes.dart';
import 'package:template/utilities/handle_app_bloc_errors.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/common_blocs/allowed_emails_bloc.dart';
import 'package:hyttahub/common_widgets/layout.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:hyttahub/site_widgets/site_edit_mode_cubit.dart';
import 'package:hyttahub/site_widgets/site_screen_settings_button.dart';
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
        HyttaHubOptions.implementation?.storage ?? StorageEnum.cloud,
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
    return BlocBuilder<SiteAllowedEmailsBloc, AllowedEmailsBlocState>(
      key: Key('AllowedEmailsBloc-site-screen-${widget.siteId}'),
      builder: (context, allowedEmailsState) {
        final userId =
            allowedEmailsState.emails[context.read<AuthBloc>().state.email]
                ?.userId;

        return BlocBuilder<SiteEditModeCubit, bool?>(
          builder: (context, editModeState) {
            return BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
              builder: (context, siteState) {

                final isAdmin = siteState.members[userId]?.admin ?? false;

                if (isAdmin && editModeState == null) {
                  return Scaffold(
                    appBar: AppBar(
                      leading: context.canPop() ? BackButton(onPressed: () => context.pop()) : null,
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
                          Text(AppLocalizations.of(context)!.app_howToProceed),
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
                    leading: context.canPop() ? BackButton(onPressed: () => context.pop()) : null,
                    title: const ScreenTitle(),
                    actions:
                        isEditModeOn
                            ? [
                              SiteSettingsButton(
                                siteId: widget.siteId,
                                appOptions: [
                                  SimpleDialogOption(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
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
    );
  }
}

class AppStateAndButtons extends StatefulWidget {
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

  @override
  State<AppStateAndButtons> createState() => _AppStateAndButtonsState();
}

class _AppStateAndButtonsState extends State<AppStateAndButtons> {
  String? _generatedUrl;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppReplayBloc, AppReplayBlocState>(
      builder: (context, appState) {
        final errorWidget = handleAppReplayState(context, appState);
        if (errorWidget != null) {
          return errorWidget;
        }

        final version = appState.nextVersion;
        final email = context.read<AuthBloc>().state.email;

        return Column(
          children: [
            _buildRow(
              context: context,
              label: AppLocalizations.of(context)!.app_labelText,
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
                  UpdateTextRoute.fullPath(widget.siteId),
                );
              },
            ),
            _buildRow(
              context: context,
              label: AppLocalizations.of(context)!.app_labelCode,
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
                  UpdateCodeRoute.fullPath(widget.siteId),
                );
              },
            ),
            _buildRow(
              context: context,
              label: AppLocalizations.of(context)!.app_labelCheckbox,
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
                  UpdateCheckboxRoute.fullPath(widget.siteId),
                );
              },
            ),
            _buildRow(
              context: context,
              label: AppLocalizations.of(context)!.app_labelDropdown,
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
                  UpdateDropdownRoute.fullPath(widget.siteId),
                );
              },
            ),
            _buildRow(
              context: context,
              label: AppLocalizations.of(context)!.app_labelList,
              buttonText: AppLocalizations.of(context)!.app_reorderList,
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
                  UpdateListRoute.fullPath(widget.siteId),
                );
              },
            ),
            _buildPhotoRow(
              context: context,
              label: AppLocalizations.of(context)!.app_labelPhoto,
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
                  AddPhotoRoute.fullPath(siteId: widget.siteId),
                );
              },
            ),
            if (_generatedUrl != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.app_generatedUrlLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      _generatedUrl!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
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
                widget.isEditModeOn
                    ? TextButton(
                      onPressed: onPressed,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        buttonText ?? AppLocalizations.of(context)!.app_updateLabel(label),
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
          value: photoVersion > 0 ? value : AppLocalizations.of(context)!.app_noPhoto,
          onPressed: onPressed,
        ),
        if (photoVersion > 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                const SizedBox(width: 150),
                const SizedBox(width: 16),
                if (widget.isEditModeOn)
                  TextButton(
                    onPressed: () async {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      final appReplayBloc = context.read<AppReplayBloc>();
                      final l10n = AppLocalizations.of(context)!;

                      final storage = HyttaHubStorageFactory.getStorage(
                        HyttaHubOptions.implementation?.storage ??
                            StorageEnum.cloud,
                      );
                      final appName =
                          HyttaHubOptions.implementation
                              ?.firebaseRootCollection ??
                          '';

                      try {
                        await storage.deleteFiles(
                          appName: appName,
                          siteId: widget.siteId,
                          fileNames: [photoVersion.toString()],
                        );

                        final appEvent = AppEvent(
                          updatePhoto:
                              AppEvent_UpdatePhoto(name: "", version: 0),
                        );

                        // Now base64 encode the event part
                        final siteEvent = SiteEvent(
                          version: appReplayBloc.state.nextVersion,
                          appEvent: packAppEventWrapper(
                            appEvent.writeToBuffer(),
                          ),
                          author: widget.authorId,
                        );

                        final encodedEvent = base64Encode(
                          siteEvent.writeToBuffer(),
                        );

                        await storage.setDocument(
                          firebaseSiteEventsPath(widget.siteId),
                          siteEvent.version.toString(),
                          {
                            fbPayload: encodedEvent,
                            fbVersion: siteEvent.version,
                            fbTimeStamp: storage.serverTimestamp,
                          },
                        );

                        setState(() {
                          _generatedUrl = null;
                        });

                        scaffoldMessenger.showSnackBar(
                          SnackBar(content: Text(l10n.app_photoDeleted)),
                        );
                      } catch (e) {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(content: Text(l10n.app_errorDeletingPhoto(e.toString()))),
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
                    child: Text(
                      AppLocalizations.of(context)!.app_deletePhoto,
                      style: const TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                if (widget.isEditModeOn) const SizedBox(width: 16),
                TextButton(
                  onPressed: () async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    final l10n = AppLocalizations.of(context)!;
                    final storage = HyttaHubStorageFactory.getStorage(
                      HyttaHubOptions.implementation?.storage ??
                          StorageEnum.cloud,
                    );
                    final appName =
                        HyttaHubOptions.implementation
                            ?.firebaseRootCollection ??
                        '';

                    try {
                      final url = await storage.getFileUrl(
                        appName: appName,
                        siteId: widget.siteId,
                        fileName: photoVersion.toString(),
                        expirationDays: 7,
                      );
                      setState(() {
                        _generatedUrl = url;
                      });
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text(l10n.app_urlGenerated)),
                      );
                    } catch (e) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text(l10n.app_errorGettingUrl(e.toString()))),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.app_getShareableUrl,
                    style: const TextStyle(decoration: TextDecoration.underline),
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
                    future: widget.getSignedUrl(photoVersion.toString()),
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
        final siteName = siteState.name;

        return Text(siteName);
      },
    );
  }
}
