// Copyright (c) 2025 bjorge

import 'package:hyttahub/proto/any.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';

/// A function that replays an app-specific event and returns the new app state.
typedef AppReplay =
    Any Function(SiteReplayBlocState siteReplay, SiteEvent event);

typedef SiteRoutePath = String Function(String siteId, String encodedEvent);
typedef BaseSiteRoutePath = String Function(String siteId);

/// A class to hold global options for the HyttaHub library.
class HyttaHubOptions {
  /// The app-specific replay function.
  /// This must be set by the application using the library before any site replay logic is run.
  static AppReplay? appReplay;

  static int? appBuildNumber;

  static BaseSiteRoutePath? siteScreenRoute;

  static String? firebaseRootCollection;
}
