// Copyright (c) 2025 bjorge

import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/proto/service_events.pb.dart';
import 'package:hyttahub/service_blocs/service_submit_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceSubmitIconButton extends StatelessWidget {
  const ServiceSubmitIconButton({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    // BaseSubmitBloc
    return BlocBuilder<ServiceSubmitBloc, BaseSubmitState<SubmitServiceEvent>>(
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
                    context.read<ServiceSubmitBloc>().add(
                      ServiceEventSubmission(
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
