// Copyright (c) 2025 bjorge

import 'package:hyttahub/account_blocs/account_replay_bloc.dart';
import 'package:hyttahub/account_blocs/account_submit_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/proto/account_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountSubmitIconButton extends StatelessWidget {
  const AccountSubmitIconButton({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    // BaseSubmitBloc
    return BlocBuilder<AccountReplayBloc, AccountReplayBlocState>(
      builder: (context, replayState) {
        return BlocBuilder<AccountSubmitBloc,
            BaseSubmitState<SubmitAccountEvent>>(
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
                        context.read<AccountSubmitBloc>().add(
                              AccountEventSubmission(
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
