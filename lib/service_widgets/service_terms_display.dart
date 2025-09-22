// Copyright (c) 2025 bjorge

import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/service_replay_bloc.pb.dart';
import 'package:hyttahub/service_blocs/service_replay_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceTermsDisplay extends StatelessWidget {
  const ServiceTermsDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = HyttaHubLocalizations.of(context)!;
    return BlocBuilder<ServiceReplayBloc, ServiceReplayBlocState>(
      builder: (context, serviceState) {
        if (serviceState.hasTerms()) {
          return Scaffold(
            appBar: AppBar(title: Text(localizations.termsOfServiceTitle)),
            body: Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  serviceState.terms,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          );
        } else {
          return Center(child: Text(localizations.noTermsAvailable));
        }
      },
    );
  }
}
