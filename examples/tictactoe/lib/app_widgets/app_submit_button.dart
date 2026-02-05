// Copyright (c) 2025 bjorge

import 'package:tictactoe/app_blocs/app_replay_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppSubmitIconButton extends StatelessWidget {
  const AppSubmitIconButton({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppReplayBloc, AppReplayBlocState>(
      builder: (context, replayState) {
        return BlocBuilder<AppSubmitBloc, BaseSubmitState<SubmitAppEvent>>(
          builder: (context, submitState) {
            final isOutdated = submitState.payload != null &&
                replayState.lastVersion >= submitState.payload!.siteEvent.version;

            return IconButton(
              icon: Icon(isOutdated ? Icons.block : Icons.check),
              onPressed: (submitState.submissionState.state !=
                          CommonSubmitBlocState_State.canSubmit ||
                      isOutdated)
                  ? null
                  : () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        context.read<AppSubmitBloc>().add(
                              AppEventSubmission(
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
