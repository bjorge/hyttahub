// Copyright (c) 2025 bjorge

import 'package:flutter/material.dart';
import 'package:hyttahub/proto/app_wrapper.pb.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/preferences_cubits/language_cubit.dart';

/// A function that replays an app-specific event and returns the new app state.
typedef AppReplay =
    AppReplayWrapper Function(SiteReplayBlocState siteReplay, SiteEvent event);

typedef AppEventDescriptionBuilder = String Function(
    BuildContext context, SiteEvent event);

typedef SiteRoutePath = String Function(String siteId, String encodedEvent);
typedef BaseSiteRoutePath = String Function(String siteId);

/// A class to hold global options for the HyttaHub library.
class HyttaHubOptions {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static BaseSiteRoutePath? siteScreenRoute;

  static HyttaHubImplementation? implementation;

  static AppEventDescriptionBuilder? appEventDescriptionBuilder;

  static String appTitle = '';
  static String appVersion = '';
  static int appBuildNumber = 0;

  static AppLanguage? defaultLanguage;
}
