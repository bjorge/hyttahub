// Copyright (c) 2025 bjorge

import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/common_widgets/layout.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:protobuf/protobuf.dart';

class CommonSubmitFormLayout<T extends GeneratedMessage>
    extends StatelessWidget {
  const CommonSubmitFormLayout({
    super.key,
    required this.submitState,
    required this.children,
    this.progressWidget,
    this.errorWidget,
    this.singleChildScrollView = false,
  });

  final BaseSubmitState<T> submitState;
  final List<Widget> children;
  final Widget? progressWidget;
  final Widget? errorWidget;
  final bool singleChildScrollView;

  Widget _buildProgressWidget(BuildContext context) {
    return progressWidget ?? const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorWidget(BuildContext context) {
    if (errorWidget != null) {
      return errorWidget!;
    }
    if (submitState.submissionState.errorCode ==
        CommonSubmitBlocState_ErrorCode.permissionDenied) {
      return Text(
        HyttaHubLocalizations.of(context)!.permissionDenied,
        style: const TextStyle(color: Colors.red),
      );
    }
    return Text(
      HyttaHubLocalizations.of(context)!.formSubmissionError,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (submitState.submissionState.state ==
        CommonSubmitBlocState_State.error) {
      children.insert(0, _buildErrorWidget(context));
    }

    if (submitState.submissionState.state ==
        CommonSubmitBlocState_State.submitting) {
      children.insert(0, _buildProgressWidget(context));
    }

    return singleChildScrollView
        ? children[0]
        : CommonListViewLayout(
            spacing: 10.0,
            children: children,

            // [
            //   if (submitState.submissionState.state ==
            //       CommonSubmitBlocState_State.error)
            //     _buildErrorWidget(context),
            //   ...children,
            //   if (submitState.submissionState.state ==
            //       CommonSubmitBlocState_State.submitting)
            //     _buildProgressWidget(context),
            // ],
          );
  }
}
