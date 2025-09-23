import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';
// ignore: unused_import
import 'package:protobuf/protobuf.dart';

class AllowedEmailsBloc
    extends Bloc<AllowedEmailsBlocEvent, AllowedEmailsBlocState> {
  AllowedEmailsBloc(this.collectionPath, {FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      super(AllowedEmailsBlocState()) {
    on<AllowedEmailsBlocEvent>(_onAllowedEmailsBlocEvent);
  }

  final String collectionPath;
  final FirebaseFirestore _firestore;

  FutureOr<void> _onAllowedEmailsBlocEvent(
    AllowedEmailsBlocEvent event,
    Emitter<AllowedEmailsBlocState> emit,
  ) async {
    if (event.hasFetchNow()) {
      emit(
        AllowedEmailsBlocState(state: AllowedEmailsBlocState_State.fetching)
          ..freeze(),
      );

      await emit.onEach<QuerySnapshot>(
        _firestore.collection(collectionPath).snapshots(),
        onData: (querySnapshot) {
          final Map<String, AllowedEmailsBlocState_UserInfo> emails = {};
          for (final doc in querySnapshot.docs) {
            final data = doc.data() as Map<String, dynamic>?;
            if (data != null && data.containsKey(fbUserId)) {
              emails[doc.id] = AllowedEmailsBlocState_UserInfo(
                userId: data[fbUserId] as int,
              );
            }
          }
          emit(
            AllowedEmailsBlocState(
              state: AllowedEmailsBlocState_State.success,
              emails: emails,
            ),
          );
        },
        onError: (error, stackTrace) {
          if (error is FirebaseException && error.code == 'permission-denied') {
            emit(
              AllowedEmailsBlocState(
                state: AllowedEmailsBlocState_State.permissionDenied,
              ),
            );
          } else {
            emit(
              AllowedEmailsBlocState(state: AllowedEmailsBlocState_State.error),
            );
          }
        },
      );
    }
    if (event.hasUpdateNow()) {
      emit(event.updateNow);
    }
  }
}
