// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:equatable/equatable.dart';
import 'package:hyttahub/hyttahub_options.dart';

part 'site_event.dart';
part 'site_state.dart';

class SiteBloc extends Bloc<SiteEvent, SiteState> {
  SiteBloc({required this.siteId}) : super(const SiteState()) {
    on<SiteTextChanged>(_onTextChanged);
    on<SiteSubmittedChanged>(_onSubmittedChanged);
    on<_SiteDocumentChanged>(_onDocumentChanged);

    _subscription = _firestore
        .collection(HyttaHubOptions.firebaseRootCollection!)
        .doc(siteId)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data.containsKey('form')) {
          final form = data['form'];
          add(_SiteDocumentChanged(FormModel(
            text: form['text'] ?? '',
            submitted: form['submitted'] ?? false,
          )));
        }
      }
    });
  }

  final String siteId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  late final StreamSubscription _subscription;

  Future<void> _onTextChanged(
    SiteTextChanged event,
    Emitter<SiteState> emit,
  ) async {
    // In a real app, this would be a protobuf message.
    final appEvent = {
      'update_text': {'text': event.text}
    };
    await _functions
        .httpsCallable('addSiteEvent')
        .call({'siteId': siteId, 'appEvent': appEvent});
  }

  Future<void> _onSubmittedChanged(
    SiteSubmittedChanged event,
    Emitter<SiteState> emit,
  ) async {
    // In a real app, this would be a protobuf message.
    final appEvent = {
      'update_submitted': {'submitted': event.submitted}
    };
    await _functions
        .httpsCallable('addSiteEvent')
        .call({'siteId': siteId, 'appEvent': appEvent});
  }

  void _onDocumentChanged(
    _SiteDocumentChanged event,
    Emitter<SiteState> emit,
  ) {
    emit(state.copyWith(form: event.form));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
