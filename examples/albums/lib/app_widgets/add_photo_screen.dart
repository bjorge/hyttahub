// Copyright (c) 2025 bjorge

import 'dart:convert';

import 'package:albums/app_blocs/app_submit_bloc.dart';
import 'package:albums/app_widgets/app_submit_button.dart';
import 'package:albums/l10n/app_localizations.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:albums/proto/app_events.pb.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';
import 'package:file_picker/file_picker.dart';

class AddPhotoScreen extends StatefulWidget {
  const AddPhotoScreen({super.key, required this.event, required this.siteId});

  final String event;
  final String siteId;

  @override
  State<AddPhotoScreen> createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  final _formKey = GlobalKey<FormState>();

  List<PlatformFile> _files = [];
  final Set<PlatformFile> _selectedFiles = {};

  @override
  Widget build(BuildContext context) {
    final submitEvent = SubmitAppEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    if (kDebugMode) {
      print("AddPhotoScreen: Initial event: ${submitEvent.toProto3Json()}");
    }

    return BlocProvider(
      create: (_) => AppSubmitBloc(widget.siteId, submitEvent),
      child: Form(
        key: _formKey,
        child: BlocConsumer<AppSubmitBloc, BaseSubmitState<SubmitAppEvent>>(
          builder: (context, submitState) {
            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.app_addPhotosTitle),
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

  Future<void> _pickAndUploadPhoto(BuildContext context) async {
    final submitBloc = context.read<AppSubmitBloc>();

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
      allowMultiple: true,
    );

    if (kDebugMode) {
      print("AddPhotoScreen: Picked ${result?.files.length ?? 0} files.");
    }

    if (result == null || result.files.isEmpty) {
      return;
    }

    result.files.sort((a, b) => a.name.compareTo(b.name));

    setState(() {
      _files = result.files;
      _selectedFiles.clear();
      _selectedFiles.addAll(_files);
    });
    _updateBlocWithSelection(submitBloc);
  }

  void _updateBlocWithSelection(AppSubmitBloc submitBloc) {
    final payload = submitBloc.state.payload!;
    final updatedPayload = payload.deepCopy();
    updatedPayload.images.clear();

    for (final file in _selectedFiles) {
      if (file.bytes != null) {
        final image =
            SubmitAppEvent_Image()
              ..base64Data = base64Encode(file.bytes!)
              ..name = file.name
              ..size = file.size;
        updatedPayload.images.add(image);
      }
    }
    final isFormValid = updatedPayload.images.isNotEmpty;
    _formKey.currentState?.validate();

    submitBloc.add(
      AppEventSubmission(
        updatedPayload: updatedPayload,
        submission: CommonSubmitBlocEvent(isFormValid: isFormValid),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    BaseSubmitState<SubmitAppEvent> submitState,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (submitState.submissionState.state ==
        CommonSubmitBlocState_State.submitting) {
      if (submitState.submissionState.hasProgress()) {
        final progress = submitState.submissionState.progress;
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.app_uploadingPhotosProgress(
                  progress.count,
                  progress.total,
                ),
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
            ],
          ),
        );
      }
      return const Center(child: CircularProgressIndicator());
    }

    if (_files.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (submitState.submissionState.state ==
                CommonSubmitBlocState_State.error)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  l10n.app_submissionError(
                    submitState.submissionState.toProto3Json().toString(),
                  ),
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: Text(l10n.app_pickPhotosButton),
              onPressed: () => _pickAndUploadPhoto(context),
            ),
          ],
        ),
      );
    }
    final submitBloc = context.read<AppSubmitBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (submitState.submissionState.state ==
            CommonSubmitBlocState_State.error)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.app_submissionError(
                submitState.submissionState.toProto3Json().toString(),
              ),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            l10n.app_selectPhotosToUpload,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _files.length,
            itemBuilder: (context, index) {
              final file = _files[index];
              final isSelected = _selectedFiles.contains(file);
              return CheckboxListTile(
                secondary: SizedBox(
                  width: 50,
                  height: 50,
                  child:
                      file.bytes != null
                          ? Image.memory(
                            file.bytes!,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.error),
                          )
                          : const Icon(Icons.image_not_supported),
                ),
                title: Text(file.name),
                subtitle: Text(
                  AppLocalizations.of(context)!.app_photoSizeInKB(
                    (file.size / 1024).toStringAsFixed(2),
                  ),
                ),
                value: isSelected,
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedFiles.add(file);
                    } else {
                      _selectedFiles.remove(file);
                    }
                  });
                  _updateBlocWithSelection(submitBloc);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
