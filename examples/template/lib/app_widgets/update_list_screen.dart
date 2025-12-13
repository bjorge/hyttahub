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

class UpdateListScreen extends StatefulWidget {
  const UpdateListScreen({
    super.key,
    required this.event,
    required this.siteId,
  });

  final String event;
  final String siteId;

  @override
  State<UpdateListScreen> createState() => _UpdateListScreenState();
}

class _UpdateListScreenState extends State<UpdateListScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final submitEvent = SubmitAppEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    if (!submitEvent.appEvent.hasUpdateList()) {
      submitEvent.appEvent.updateList = AppEvent_UpdateList();
    }

    // Initialize list with some default items if empty, just so there's something to reorder
    if (submitEvent.appEvent.updateList.items.isEmpty) {
      submitEvent.appEvent.updateList.items.addAll([
        AppEvent_ReorderableItem(id: 1, title: 'Item 1'),
        AppEvent_ReorderableItem(id: 2, title: 'Item 2'),
        AppEvent_ReorderableItem(id: 3, title: 'Item 3'),
      ]);
    }

    return BlocProvider(
      create: (_) => AppSubmitBloc(widget.siteId, submitEvent),
      child: Form(
        key: _formKey,
        child: BlocConsumer<AppSubmitBloc, BaseSubmitState<SubmitAppEvent>>(
          builder: (context, submitState) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Update List"),
                actions: [AppSubmitIconButton(formKey: _formKey)],
              ),
              body: CommonSubmitFormLayout<SubmitAppEvent>(
                submitState: submitState,
                children: [
                  ReorderableFormFieldWidget(
                    formKey: _formKey,
                    labelText: "Reorderable List",
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

class ReorderableFormFieldWidget
    extends
        BaseReorderableFormField<
          AppSubmitBloc,
          AppEventSubmission,
          SubmitAppEvent
        > {
  const ReorderableFormFieldWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: appEventSubmissionFactory);

  @override
  List<ReorderableItem> getItemsFromPayload(
    BuildContext context,
    SubmitAppEvent payload,
  ) {
    return payload.appEvent.updateList.items
        .map(
          (e) => ReorderableItem(
            id: e.id,
            title: e.title,
            leading: const Icon(Icons.list),
          ),
        )
        .toList();
  }

  @override
  SubmitAppEvent updatePayload(
    SubmitAppEvent originalPayload,
    List<ReorderableItem> newItems,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.appEvent.updateList.items.clear();
    updatedPayload.appEvent.updateList.items.addAll(
      newItems.map((e) => AppEvent_ReorderableItem(id: e.id, title: e.title)),
    );
    return updatedPayload;
  }
}
