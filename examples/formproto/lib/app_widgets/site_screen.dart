// Copyright (c) 2025 bjorge

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formproto/app_blocs/site_bloc.dart';

class SiteScreen extends StatelessWidget {
  const SiteScreen({super.key, required this.siteId});

  final String siteId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SiteBloc(siteId: siteId),
      child: const FormView(),
    );
  }
}

class FormView extends StatefulWidget {
  const FormView({super.key});

  @override
  State<FormView> createState() => _FormViewState();
}

class _FormViewState extends State<FormView> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form'),
        actions: [
          BlocBuilder<SiteBloc, SiteState>(
            builder: (context, state) {
              return Checkbox(
                value: state.form.submitted,
                onChanged: (value) {
                  context.read<SiteBloc>().add(SiteSubmittedChanged(value!));
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocConsumer<SiteBloc, SiteState>(
              listener: (context, state) {
                if (_textController.text != state.form.text) {
                  _textController.text = state.form.text;
                }
              },
              builder: (context, state) {
                return TextField(
                  controller: _textController,
                  onChanged: (text) {
                    context.read<SiteBloc>().add(SiteTextChanged(text));
                  },
                  decoration: const InputDecoration(
                    labelText: 'Enter text',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
