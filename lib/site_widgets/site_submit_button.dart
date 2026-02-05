// Copyright (c) 2025 bjorge

import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/site_blocs/site_replay_bloc.dart';
import 'package:hyttahub/site_blocs/site_submit_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class SiteEventSubmission extends BaseSubmitEvent<SubmitSiteEvent> {
//   SiteEventSubmission({required super.submission, super.updatedPayload});
// }

class SiteSubmitIconButton extends StatelessWidget {
  const SiteSubmitIconButton({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SiteReplayBloc, SiteReplayBlocState>(
      builder: (context, replayState) {
        return BlocBuilder<SiteSubmitBloc, BaseSubmitState<SubmitSiteEvent>>(
          builder: (context, submitState) {
            final isOutdated = submitState.payload != null &&
                replayState.lastVersion >= submitState.payload!.event.version;

            return IconButton(
              icon: Icon(isOutdated ? Icons.block : Icons.check),
              onPressed: (submitState.submissionState.state !=
                          CommonSubmitBlocState_State.canSubmit ||
                      isOutdated)
                  ? null
                  : () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        context.read<SiteSubmitBloc>().add(
                              SiteEventSubmission(
                                submission: CommonSubmitBlocEvent(
                                  submit: CommonSubmitBlocEvent_SubmitNow(),
                                )..freeze(),
                              ),
                            );
                      }
                    },
            );
          },
        );
      },
    );
  }
}
