import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/common_widgets/hytta_hub_button.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:get_it/get_it.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/service_blocs/cloud_functions_bloc.dart';
import 'package:hyttahub/storage/hyttahub_file_storage_factory.dart';

class ImportSiteScreen extends StatefulWidget {
  const ImportSiteScreen({super.key});

  @override
  State<ImportSiteScreen> createState() => _ImportSiteScreenState();
}

class _ImportSiteScreenState extends State<ImportSiteScreen> {
  PlatformFile? _selectedFile;
  String? _fileName;
  bool _isUploading = false;
  bool _isProcessing = false;
  double _uploadProgress = 0.0;
  int? _fileSizeInMB;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['tar'],
    );

    if (result != null) {
      final file = result.files.single;
      final sizeInMB = file.size ~/ (1024 * 1024);

      setState(() {
        _selectedFile = file;
        _fileName = file.name;
        _fileSizeInMB = sizeInMB;
        _uploadProgress = 0.0;
      });

      // Show warning for large files
      if (sizeInMB > 500 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              HyttaHubLocalizations.of(context)!.largeFileWarning(sizeInMB),
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _importSite() async {
    if (_selectedFile == null) {
      return;
    }

    final email = GetIt.instance<AuthBloc>().state.email;
    if (email.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(HyttaHubLocalizations.of(context)!.userMustBeSignedIn),
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final storageType =
          HyttaHubOptions.implementation?.storage ?? StorageEnum.firestore;
      final fileStorage = HyttaHubFileStorageFactory.getFileStorage(storageType);

      final authState = GetIt.instance<AuthBloc>().state;
      final userId = authState.uid;
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      final storagePath = 'imports/$userId/${timestamp}_$_fileName';

      // Listen to upload progress
      final progressSubscription =
          fileStorage.uploadProgress(storagePath).listen((progress) {
        setState(() {
          _uploadProgress = progress;
        });
      });

      try {
        await fileStorage.uploadFile(storagePath, _selectedFile!.bytes!);
      } finally {
        progressSubscription.cancel();
      }

      if (!mounted) return;

      setState(() {
        _isUploading = false;
        _isProcessing = true;
      });

      // Call cloud function to process the import
      final response = await context.read<CloudFunctionsBloc>().importSite(
        storagePath: storagePath,
      );

      setState(() {
        _isProcessing = false;
      });

      final siteId = response['siteId'] as String;
      final adminMembers = (response['adminMembers'] as List<dynamic>).map((
        member,
      ) {
        return member as Map<String, dynamic>;
      }).toList();

      if (!mounted) return;
      context.push(
        SelectAdminRoute.fullPath(siteId: siteId),
        extra: adminMembers,
      );
    } catch (error) {
      setState(() {
        _isUploading = false;
        _isProcessing = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            HyttaHubLocalizations.of(
              context,
            )!.errorImportingSite(error.toString()),
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _isUploading || _isProcessing;

    return Scaffold(
      appBar: AppBar(
        title: Text(HyttaHubLocalizations.of(context)!.importSiteTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            HyttaHubButton(
              onPressed: isLoading ? null : _pickFile,
              child: Text(HyttaHubLocalizations.of(context)!.selectFileButton),
            ),
            if (_fileName != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    Text(
                      HyttaHubLocalizations.of(
                        context,
                      )!.selectedFile(_fileName!),
                    ),
                    if (_fileSizeInMB != null)
                      Text(
                        HyttaHubLocalizations.of(
                          context,
                        )!.fileSizeLabel(_fileSizeInMB!),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              if (_isUploading) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      LinearProgressIndicator(value: _uploadProgress),
                      const SizedBox(height: 8),
                      Text(
                        HyttaHubLocalizations.of(context)!.uploadingProgress(
                          (_uploadProgress * 100).toStringAsFixed(0),
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
              if (_isProcessing)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 8),
                      Text(HyttaHubLocalizations.of(context)!.processingImport),
                    ],
                  ),
                ),
              if (!isLoading)
                HyttaHubButton(
                  onPressed: _importSite,
                  child: Text(HyttaHubLocalizations.of(context)!.importButton),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

