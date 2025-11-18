// Copyright (c) 2025 bjorge

import 'package:formproto/app_blocs/app_submit_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:formproto/proto/app_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppSubmitIconButton extends StatelessWidget {
  const AppSubmitIconButton({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSubmitBloc, BaseSubmitState<SubmitAppEvent>>(
      builder: (context, submitState) {
        return IconButton(
          icon: const Icon(Icons.check),
          onPressed:
              (submitState.submissionState.state !=
                      CommonSubmitBlocState_State.canSubmit)
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
  }
}
