// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formproto/proto/app_events.pb.dart';
import 'package:formproto/proto/app_replay_bloc.pb.dart';
import 'package:formproto/routers/app_routes.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/common_widgets/layout.dart';
import 'package:hyttahub/proto/app_wrapper.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:protobuf/protobuf.dart';

class SiteScreen extends StatelessWidget {
  const SiteScreen({super.key, required this.siteId});

  final String siteId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Proto')),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<SiteReplayBloc>(
            key: Key('SiteReplayBloc-albums-$siteId'),
            create:
                (_) =>
                    SiteReplayBloc(siteId)
                      ..add(CommonReplayBlocEvent(listen: true)),
          ),
        ],
        child: CommonListViewLayout(
          spacing: 10.0,
          children: [
            Text('Site ID: $siteId'),
            TextValue(),
            UpdateButton(siteId: siteId),
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
    return BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
      builder: (context, siteState) {
        if (!siteState.hasState() ||
            siteState.state == CommonReplayStateEnum.fetchingConfig) {
          return const Center(child: CircularProgressIndicator());
        } else if (siteState.state == CommonReplayStateEnum.uninitialized) {
          throw UnimplementedError('Site state is uninitialized');
        }

        final appReplay =
            siteState.hasAppBlocState() && siteState.appBlocState.hasPayload()
                ? unpackAppReplayWrapper(
                  siteState.appBlocState,
                  AppReplayBlocState.create,
                )
                : AppReplayBlocState();
        final textValue = appReplay.hasText() ? appReplay.text : '';

        final version =
            siteState.events.isEmpty
                ? 1
                : siteState.events.keys.fold<int>(0, (p, e) => e > p ? e : p) +
                    1;

        return ElevatedButton(
          onPressed: () {
            final submmitValue = SubmitAppEvent(
              authorEmail: GetIt.instance<AuthBloc>().state.email,
              appEvent: AppEvent(
                updateText: AppEvent_UpdateText(text: textValue),
              ),
              siteEvent: SubmitAppEvent_SiteEvent(version: version),
            );
            final encodedSubmitValue = base64UrlEncode(
              submmitValue.writeToBuffer(),
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
        if (!siteState.hasState() ||
            siteState.state == CommonReplayStateEnum.fetchingConfig) {
          return const Center(child: CircularProgressIndicator());
        } else if (siteState.state == CommonReplayStateEnum.uninitialized) {
          throw UnimplementedError('Site state is uninitialized');
        }

        final appReplay =
            siteState.hasAppBlocState() && siteState.appBlocState.hasPayload()
                ? unpackAppReplayWrapper(
                  siteState.appBlocState,
                  AppReplayBlocState.create,
                )
                : AppReplayBlocState();
        final textValue = appReplay.hasText() ? appReplay.text : '';

        return Text("Text Value: $textValue ");
      },
    );
  }
}

T unpackAppReplayWrapper<T extends GeneratedMessage>(
  AppReplayWrapper any,
  T Function() create,
) {
  final message = create();
  message.mergeFromBuffer(any.payload);
  return message;
}
