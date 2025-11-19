// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formjson/app_widgets/site_screen_settings_button.dart';
import 'package:formjson/models/app_events.dart';
import 'package:formjson/models/app_replay_bloc.dart';
import 'package:formjson/routers/app_routes.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/common_widgets/layout.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
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
          create: (_) =>
              SiteReplayBloc(siteId)..add(CommonReplayBlocEvent(listen: true)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const ScreenTitle(),
          actions: [SiteSettingsButton(siteId: siteId)],
        ),
        body: CommonListViewLayout(
          spacing: 10.0,
          children: [TextValue(), UpdateButton(siteId: siteId)],
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
    return BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
      builder: (context, siteState) {
        final errorWidget = handleSiteReplayState(context, siteState);
        if (errorWidget != null) {
          return errorWidget;
        }

        final appReplay = siteState.hasAppBlocState() &&
                siteState.appBlocState.hasPayload()
            ? AppReplayBlocState.fromJson(
                jsonDecode(
                  utf8.decode(siteState.appBlocState.payload),
                ),
              )
            : const AppReplayBlocState();

        final textValue = appReplay.text ?? '';

        final version = siteState.events.isEmpty
            ? 1
            : siteState.events.keys.fold<int>(0, (p, e) => e > p ? e : p) + 1;

        return ElevatedButton(
          onPressed: () {
            final submmitValue = SubmitAppEvent(
              authorEmail: GetIt.instance<AuthBloc>().state.email,
              appEvent: AppEvent.updateText(text: textValue),
              siteEvent: SubmitAppEventSiteEvent(version: version),
            );
            final encodedSubmitValue = base64UrlEncode(
              utf8.encode(
                jsonEncode(
                  submmitValue.toJson(),
                ),
              ),
            );
            context.push(
              '${SiteScreenFormRoute.fullPath(siteId)}?event=$encodedSubmitValue',
            );
          },
          child: const Text('Update Text'),
        );
      },
    );
  }
}

class TextValue extends StatelessWidget {
  const TextValue({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
      builder: (context, siteState) {
        final errorWidget = handleSiteReplayState(context, siteState);
        if (errorWidget != null) {
          return errorWidget;
        }

        final appReplay = siteState.hasAppBlocState() &&
                siteState.appBlocState.hasPayload()
            ? AppReplayBlocState.fromJson(
                jsonDecode(
                  utf8.decode(siteState.appBlocState.payload),
                ),
              )
            : const AppReplayBlocState();
        final textValue = appReplay.text ?? '';

        return Text("Text Value: $textValue ");
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
