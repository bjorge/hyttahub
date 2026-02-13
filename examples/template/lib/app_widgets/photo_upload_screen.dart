import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:protobuf/protobuf.dart';
import 'package:template/app_widgets/app_submit_button.dart';
import 'package:template/l10n/app_localizations.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:template/app_blocs/app_replay_bloc.dart';


class PhotoUploadScreen extends StatefulWidget {
  const PhotoUploadScreen({
    super.key,
    required this.event,
    required this.siteId,
  });

  final String event;
  final String siteId;

  @override
  State<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  final _formKey = GlobalKey<FormState>();

  List<PlatformFile> _files = [];
  final Set<PlatformFile> _selectedFiles = {};

  @override
  Widget build(BuildContext context) {
    final submitEvent = SubmitAppEvent.fromBuffer(
      base64Url.decode(widget.event),
    );

    return BlocProvider<AppSubmitBloc>(
      create: (_) => AppSubmitBloc(widget.siteId, submitEvent),
      child: Form(
        key: _formKey,
        child: BlocConsumer<AppSubmitBloc, BaseSubmitState<SubmitAppEvent>>(
          builder: (context, submitState) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Update Photo"),
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
      allowMultiple: false, // Only allow one photo for this template
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

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

    // For template: Clear previous photo data if a new one is selected
    updatedPayload.appEvent.updatePhoto.name = "";
    updatedPayload.appEvent.updatePhoto.version = 0;
    // updatedPayload.appEvent.updatePhoto.size = 0; // if size exists

    for (final file in _selectedFiles) {
      if (file.bytes != null) {
        final base64Data = base64Encode(file.bytes!);
        final image =
            SubmitAppEvent_Image()
              ..base64Data = base64Data
              ..name = file.name
              ..size = file.size;
        updatedPayload.images.add(image);

        // We do NOT set photoVersion here. AppSubmitBloc handles upload and sets version.
        // We set initial metadata just in case, but version is key.
        updatedPayload.appEvent.updatePhoto.name = file.name;
        updatedPayload.appEvent.updatePhoto.size = file.size;
        // The bloc will update version in the event before submitting
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
    if (submitState.submissionState.state ==
        CommonSubmitBlocState_State.submitting) {
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
                  AppLocalizations.of(context)!.app_submissionError(
                    submitState.submissionState.toProto3Json().toString(),
                  ),
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: Text(AppLocalizations.of(context)!.app_pickPhotosButton),
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
              AppLocalizations.of(context)!.app_submissionError(
                submitState.submissionState.toProto3Json().toString(),
              ),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Selected Photo",
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
                subtitle: Text('${(file.size / 1024).toStringAsFixed(2)} KB'),
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
