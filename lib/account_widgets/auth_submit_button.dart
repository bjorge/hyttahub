// Copyright (c) 2025 bjorge

import 'package:hyttahub/auth_bloc/auth_submit_bloc.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/proto/auth_bloc.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthSubmitIconButton extends StatelessWidget {
  const AuthSubmitIconButton({super.key, required this.formKey});
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    // BaseSubmitBloc
    return BlocBuilder<AuthSubmitBloc, BaseSubmitState<AuthBlocEvent>>(
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
                    context.read<AuthSubmitBloc>().add(
                      AuthEventSubmission(
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

  // @override
  // Widget build1(BuildContext context) {
  //   return SubmitIconButton<AuthSubmitBloc, AuthEventSubmission, AuthBlocEvent>(
  //     formKey: formKey,
  //     eventFactory: authEventSubmissionFactory,
  //   );
  // }
}
