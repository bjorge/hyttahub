// Copyright (c) 2025 bjorge

import 'package:flutter/material.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';

Widget commonAlertDialog(BuildContext context, String title, Widget content) {
  final dialogTheme = Theme.of(context).dialogTheme; // Get theme

  return AlertDialog(
    // backgroundColor: dialogTheme.backgroundColor ?? Colors.white,
    shape:
        dialogTheme.shape ??
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    title: Text(
      title,
      style:
          dialogTheme.titleTextStyle ??
          const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    ),
    content: content,
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(HyttaHubLocalizations.of(context)!.okButton),
      ),
    ],
  );
}

class CommonListViewLayout extends StatelessWidget {
  const CommonListViewLayout({super.key, required this.children, this.spacing});

  final List<Widget> children;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final leftRightPadding = maxWidth <= 500 ? 8.0 : (maxWidth - 500) / 4;

        return Padding(
          padding: EdgeInsets.only(
            left: leftRightPadding,
            right: leftRightPadding,
          ),
          child: SingleChildScrollView(
            child: Column(
              spacing: spacing ?? 0.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        );
      },
    );
  }
}
