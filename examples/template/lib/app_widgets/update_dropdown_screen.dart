import 'dart:convert';
import 'package:protobuf/protobuf.dart';
import 'package:template/app_blocs/app_submit_bloc.dart';
import 'package:template/app_widgets/app_submit_button.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:template/proto/app_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/common_widgets/common_form.dart';

class UpdateDropdownScreen extends StatefulWidget {
  const UpdateDropdownScreen({
    super.key,
    required this.event,
    required this.siteId,
  });

  final String event;
  final String siteId;

  @override
  State<UpdateDropdownScreen> createState() => _UpdateDropdownScreenState();
}

class _UpdateDropdownScreenState extends State<UpdateDropdownScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final submitEvent = SubmitAppEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    if (!submitEvent.appEvent.hasUpdateDropdown()) {
      submitEvent.appEvent.updateDropdown = AppEvent_UpdateDropdown();
    }

    return BlocProvider(
      create: (_) => AppSubmitBloc(widget.siteId, submitEvent),
      child: Form(
        key: _formKey,
        child: BlocConsumer<AppSubmitBloc, BaseSubmitState<SubmitAppEvent>>(
          builder: (context, submitState) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Update Dropdown"),
                actions: [AppSubmitIconButton(formKey: _formKey)],
              ),
              body: CommonSubmitFormLayout<SubmitAppEvent>(
                submitState: submitState,
                children: [
                  DropdownFormFieldWidget(
                    formKey: _formKey,
                    labelText: "Dropdown Value",
                    items: const [
                      DropdownMenuItem(
                        value: "Option 1",
                        child: Text("Option 1"),
                      ),
                      DropdownMenuItem(
                        value: "Option 2",
                        child: Text("Option 2"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          listener: (context, state) {
            if (state.submissionState.state ==
                CommonSubmitBlocState_State.success) {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}

class DropdownFormFieldWidget
    extends
        BaseDropdownFormField<
          AppSubmitBloc,
          AppEventSubmission,
          SubmitAppEvent,
          String
        > {
  const DropdownFormFieldWidget({
    super.key,
    required super.formKey,
    required super.labelText,
    required super.items,
  }) : super(eventFactory: appEventSubmissionFactory);

  @override
  String? getValueFromPayload(SubmitAppEvent payload) {
    return payload.appEvent.updateDropdown.value.isEmpty
        ? null
        : payload.appEvent.updateDropdown.value;
  }

  @override
  SubmitAppEvent updatePayload(
    SubmitAppEvent originalPayload,
    String? newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    if (newValue != null) {
      updatedPayload.appEvent.updateDropdown.value = newValue;
    }
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, String? value) => null;
}
