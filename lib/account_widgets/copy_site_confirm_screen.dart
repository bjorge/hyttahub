// Copyright (c) 2025 bjorge

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/service_blocs/cloud_functions_bloc.dart';

class CopySiteConfirmScreen extends StatefulWidget {
  const CopySiteConfirmScreen({super.key, required this.siteId});

  final String siteId;

  @override
  State<CopySiteConfirmScreen> createState() => _CopySiteConfirmScreenState();
}

class _CopySiteConfirmScreenState extends State<CopySiteConfirmScreen> {
  bool _isProcessing = false;

  void _copySite() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      await context.read<CloudFunctionsBloc>().copySite(
        widget.siteId,
      );

      if (!mounted) return;
      
      setState(() {
        _isProcessing = false;
      });
      
      // Navigate back out of conform and sites loops
      Navigator.pop(context);
      Navigator.pop(context);
      
    } catch (error) {
      setState(() {
        _isProcessing = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error copying site: $error"),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          HyttaHubLocalizations.of(context)!.copySiteConfirmTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(HyttaHubLocalizations.of(context)!.copySiteConfirmMessage),
            const SizedBox(height: 24),
            if (_isProcessing)
              const CircularProgressIndicator()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(HyttaHubLocalizations.of(context)!.cancelButton),
                  ),
                  ElevatedButton(
                    onPressed: _copySite,
                    child: Text(HyttaHubLocalizations.of(context)!.copySiteTitle),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
