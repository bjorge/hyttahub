import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/common_widgets/hytta_hub_button.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/service_blocs/cloud_functions_bloc.dart';

class ImportSiteScreen extends StatefulWidget {
  const ImportSiteScreen({super.key});

  @override
  _ImportSiteScreenState createState() => _ImportSiteScreenState();
}

class _ImportSiteScreenState extends State<ImportSiteScreen> {
  Uint8List? _zipFileBytes;
  String? _fileName;
  bool _isLoading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result != null) {
      setState(() {
        _zipFileBytes = result.files.single.bytes;
        _fileName = result.files.single.name;
      });
    }
  }

  void _importSite() {
    if (_zipFileBytes == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final base64Data = base64Encode(_zipFileBytes!);
    context.read<CloudFunctionsBloc>().importSite(base64Data).then((response) {
      setState(() {
        _isLoading = false;
      });
      final siteId = response['siteId'] as String;
      final adminMembers =
          (response['adminMembers'] as List<dynamic>).map((member) {
        return member as Map<String, dynamic>;
      }).toList();

      if (!mounted) return;
      context.push(SelectAdminRoute.fullPath(siteId: siteId),
          extra: adminMembers);
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error importing site: $error'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(HyttaHubLocalizations.of(context)!.importSiteTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            HyttaHubButton(
              onPressed: _pickFile,
              child: Text(HyttaHubLocalizations.of(context)!.selectFileButton),
            ),
            if (_fileName != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Selected file: $_fileName'),
              ),
            if (_zipFileBytes != null)
              HyttaHubButton(
                onPressed: _isLoading ? null : _importSite,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(HyttaHubLocalizations.of(context)!.importButton),
              ),
          ],
        ),
      ),
    );
  }
}