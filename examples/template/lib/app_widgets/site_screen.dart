import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/app_blocs/app_replay_bloc.dart';
import 'package:template/proto/app_events.pb.dart';
import 'package:template/proto/app_replay_bloc.pb.dart';
import 'package:template/routers/app_routes.dart';
import 'package:template/utilities/handle_app_bloc_errors.dart';
import 'package:template/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/common_widgets/layout.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:hyttahub/site_widgets/site_screen_settings_button.dart';
import 'package:hyttahub/utilities/common_error_handling.dart';

class SiteScreen extends StatelessWidget {
  const SiteScreen({super.key, required this.siteId});

  final String siteId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SiteReplayBloc>(
          key: Key('SiteReplayBloc-albums-$siteId'),
          create:
              (_) =>
                  SiteReplayBloc(siteId)
                    ..add(CommonReplayBlocEvent(listen: true)),
        ),
        BlocProvider<AppReplayBloc>(
          key: Key('AppReplayBloc-albums-$siteId'),
          create:
              (_) =>
                  AppReplayBloc(siteId)
                    ..add(CommonReplayBlocEvent(listen: true)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const ScreenTitle(),
          actions: [SiteSettingsButton(siteId: siteId)],
        ),
        body: CommonListViewLayout(
          spacing: 10.0,
          children: [const AppStateDisplay(), UpdateButton(siteId: siteId)],
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

class AppStateDisplay extends StatelessWidget {
  const AppStateDisplay({super.key});

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
