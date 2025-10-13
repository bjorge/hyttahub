import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hyttahub/common_widgets/hytta_hub_button.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:hyttahub/routes/hyttahub_routes.dart';
import 'package:hyttahub/service_blocs/cloud_functions_bloc.dart';

class SelectAdminScreen extends StatefulWidget {
  const SelectAdminScreen({
    super.key,
    required this.siteId,
  });

  final String siteId;

  @override
  _SelectAdminScreenState createState() => _SelectAdminScreenState();
}

class _SelectAdminScreenState extends State<SelectAdminScreen> {
  String? _selectedMemberId;
  bool _isLoading = false;

  void _assignUser() {
    if (_selectedMemberId == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    context
        .read<CloudFunctionsBloc>()
        .assignUserToImportedSite(widget.siteId, _selectedMemberId!)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      context.go(AccountScreenRoute.fullPath);
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error assigning user: $error'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminMembers =
        GoRouterState.of(context).extra as List<Map<String, dynamic>>;

    return Scaffold(
      appBar: AppBar(
        title: Text(HyttaHubLocalizations.of(context)!.selectAdminTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(HyttaHubLocalizations.of(context)!.selectAdminInstruction),
            DropdownButton<String>(
              value: _selectedMemberId,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMemberId = newValue;
                });
              },
              items: adminMembers
                  .map<DropdownMenuItem<String>>((Map<String, dynamic> member) {
                return DropdownMenuItem<String>(
                  value: member['memberId'] as String,
                  child: Text(member['name'] as String),
                );
              }).toList(),
            ),
            HyttaHubButton(
              onPressed: _isLoading || _selectedMemberId == null
                  ? null
                  : _assignUser,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(HyttaHubLocalizations.of(context)!.assignUserButton),
            ),
          ],
        ),
      ),
    );
  }
}