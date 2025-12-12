import 'dart:convert';

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
import 'package:hyttahub/common_widgets/layout.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
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
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const ScreenTitle(),
          actions: [SiteSettingsButton(siteId: widget.siteId)],
        ),
        body: CommonListViewLayout(
          spacing: 10.0,
          children: [
            AppStateDisplay(getSignedUrl: _getSignedUrl),
            UpdateButton(siteId: widget.siteId),
            UpdatePhotoButton(siteId: widget.siteId),
          ],
        ),
      ),
    );
  }
}

class UpdateButton extends StatelessWidget {
  const UpdateButton({super.key, required this.siteId});

  final String siteId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppReplayBloc, AppReplayBlocState>(
      builder: (context, appState) {
        final errorWidget = handleAppReplayState(context, appState);
        if (errorWidget != null) {
          return errorWidget;
        }

        final version =
            appState.events.isEmpty
                ? 1
                : appState.events.keys.fold<int>(0, (p, e) => e > p ? e : p) +
                    1;

        final templateForm = AppEvent_TemplateForm();
        if (appState.hasTextValue()) {
          templateForm.textValue = appState.textValue;
        }
        if (appState.hasCodeValue()) {
          templateForm.codeValue = appState.codeValue;
        }
        if (appState.hasCheckboxValue()) {
          templateForm.checkboxValue = appState.checkboxValue;
        }
        if (appState.hasDropdownValue()) {
          templateForm.dropdownValue = appState.dropdownValue;
        }
        if (appState.listItems.isNotEmpty) {
          templateForm.listItems.addAll(appState.listItems);
        }
        // Preserve photo when updating other fields
        if (appState.photoVersion > 0) {
          templateForm.photoVersion = appState.photoVersion;
          templateForm.photoName = appState.photoName;
        }

        return ElevatedButton(
          onPressed: () {
            final submmitValue = SubmitAppEvent(
              authorEmail: GetIt.instance<AuthBloc>().state.email,
              appEvent: AppEvent(templateForm: templateForm),
              siteEvent: SubmitAppEvent_SiteEvent(version: version),
            );
            final encodedSubmitValue = base64UrlEncode(
              submmitValue.writeToBuffer(),
            );
            context.push(
              '${SiteScreenFormRoute.fullPath(siteId)}?event=$encodedSubmitValue',
            );
          },
          child: Text("Update Values"),
        );
      },
    );
  }
}

class UpdatePhotoButton extends StatelessWidget {
  const UpdatePhotoButton({super.key, required this.siteId});

  final String siteId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppReplayBloc, AppReplayBlocState>(
      builder: (context, appState) {
        final errorWidget = handleAppReplayState(context, appState);
        if (errorWidget != null) {
          return errorWidget;
        }

        final version =
            appState.events.isEmpty
                ? 1
                : appState.events.keys.fold<int>(0, (p, e) => e > p ? e : p) +
                    1;

        final templateForm = AppEvent_TemplateForm();
        // Preserve all existing fields when updating photo
        if (appState.hasTextValue()) {
          templateForm.textValue = appState.textValue;
        }
        if (appState.hasCodeValue()) {
          templateForm.codeValue = appState.codeValue;
        }
        if (appState.hasCheckboxValue()) {
          templateForm.checkboxValue = appState.checkboxValue;
        }
        if (appState.hasDropdownValue()) {
          templateForm.dropdownValue = appState.dropdownValue;
        }
        if (appState.listItems.isNotEmpty) {
          templateForm.listItems.addAll(appState.listItems);
        }

        return ElevatedButton.icon(
          onPressed: () {
            final submmitValue = SubmitAppEvent(
              authorEmail: GetIt.instance<AuthBloc>().state.email,
              appEvent: AppEvent(templateForm: templateForm),
              siteEvent: SubmitAppEvent_SiteEvent(version: version),
            );
            final encodedSubmitValue = base64UrlEncode(
              submmitValue.writeToBuffer(),
            );
            context.push(
              '${AddPhotoRoute.fullPath(siteId: siteId)}?event=$encodedSubmitValue',
            );
          },
          icon: Icon(Icons.photo_camera),
          label: Text("Update Photo"),
        );
      },
    );
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
