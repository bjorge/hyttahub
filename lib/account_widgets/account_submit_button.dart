// Copyright (c) 2025 bjorge

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
    return BlocBuilder<AccountSubmitBloc, BaseSubmitState<SubmitAccountEvent>>(
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
  }
}
