import 'dart:convert';

import 'package:template/app_blocs/app_submit_bloc.dart';
import 'package:template/app_widgets/app_submit_button.dart';
import 'package:template/l10n/app_localizations.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:template/proto/app_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';
import 'package:hyttahub/common_widgets/common_form.dart';

class TemplateFormScreen extends StatefulWidget {
  const TemplateFormScreen({
    super.key,
    required this.event,
    required this.siteId,
  });

  final String event;
  final String siteId;

  @override
  State<TemplateFormScreen> createState() => _TemplateFormScreenState();
}

class _TemplateFormScreenState extends State<TemplateFormScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final submitEvent = SubmitAppEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    if (!submitEvent.appEvent.hasTemplateForm()) {
      submitEvent.appEvent.templateForm = AppEvent_TemplateForm();
    }

    // Initialize list items if empty to show something
    if (submitEvent.appEvent.templateForm.listItems.isEmpty) {
      submitEvent.appEvent.templateForm.listItems.addAll([
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
                title: Text(
                  AppLocalizations.of(context)!.app_updateTextValueTitle,
                ),
                actions: [AppSubmitIconButton(formKey: _formKey)],
              ),
              body: _buildBody(context, submitState),
            );
          },
          listener: (
            BuildContext context,
            BaseSubmitState<SubmitAppEvent> state,
          ) {
            if (state.submissionState.state ==
                CommonSubmitBlocState_State.success) {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    BaseSubmitState<SubmitAppEvent> submitState,
  ) {
    return CommonSubmitFormLayout<SubmitAppEvent>(
      submitState: submitState,
      children: [
        TextFormFieldWidget(formKey: _formKey, labelText: "Text Value"),
        CodeFormFieldWidget(formKey: _formKey, labelText: "Code Value"),
        CheckboxFormFieldWidget(formKey: _formKey, labelText: "Checkbox Value"),
        DropdownFormFieldWidget(
          formKey: _formKey,
          labelText: "Dropdown Value",
          items: const [
            DropdownMenuItem(value: "Option 1", child: Text("Option 1")),
            DropdownMenuItem(value: "Option 2", child: Text("Option 2")),
          ],
        ),
        ReorderableFormFieldWidget(
          formKey: _formKey,
          labelText: "Reorderable List",
        ),
      ],
    );
  }
}

class TextFormFieldWidget
    extends
        BaseTextFormField<AppSubmitBloc, AppEventSubmission, SubmitAppEvent> {
  const TextFormFieldWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: appEventSubmissionFactory);

  @override
  String? validator(BuildContext context, String value) {
    return null;
  }

  @override
  String getValueFromPayload(SubmitAppEvent payload) {
    return payload.appEvent.templateForm.textValue;
  }

  @override
  SubmitAppEvent updatePayload(
    SubmitAppEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.appEvent.templateForm.textValue = newValue;
    return updatedPayload;
  }
}

class CodeFormFieldWidget
    extends
        BaseCodeFormField<AppSubmitBloc, AppEventSubmission, SubmitAppEvent> {
  const CodeFormFieldWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: appEventSubmissionFactory);

  @override
  String getValueFromPayload(SubmitAppEvent payload) {
    return payload.appEvent.templateForm.codeValue;
  }

  @override
  SubmitAppEvent updatePayload(
    SubmitAppEvent originalPayload,
    String newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.appEvent.templateForm.codeValue = newValue;
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, String value) {
    return null;
  }
}

class CheckboxFormFieldWidget
    extends
        BaseCheckboxFormField<
          AppSubmitBloc,
          AppEventSubmission,
          SubmitAppEvent
        > {
  const CheckboxFormFieldWidget({
    super.key,
    required super.formKey,
    required super.labelText,
  }) : super(eventFactory: appEventSubmissionFactory);

  @override
  bool getValueFromPayload(SubmitAppEvent payload) {
    return payload.appEvent.templateForm.checkboxValue;
  }

  @override
  SubmitAppEvent updatePayload(SubmitAppEvent originalPayload, bool newValue) {
    final updatedPayload = originalPayload.deepCopy();
    updatedPayload.appEvent.templateForm.checkboxValue = newValue;
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, bool value) {
    return null;
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
    return payload.appEvent.templateForm.dropdownValue.isEmpty
        ? null
        : payload.appEvent.templateForm.dropdownValue;
  }

  @override
  SubmitAppEvent updatePayload(
    SubmitAppEvent originalPayload,
    String? newValue,
  ) {
    final updatedPayload = originalPayload.deepCopy();
    if (newValue != null) {
      updatedPayload.appEvent.templateForm.dropdownValue = newValue;
    }
    return updatedPayload;
  }

  @override
  String? validator(BuildContext context, String? value) {
    return null;
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
    return payload.appEvent.templateForm.listItems
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
    updatedPayload.appEvent.templateForm.listItems.clear();
    updatedPayload.appEvent.templateForm.listItems.addAll(
      newItems.map((e) => AppEvent_ReorderableItem(id: e.id, title: e.title)),
    );
    return updatedPayload;
  }
}
