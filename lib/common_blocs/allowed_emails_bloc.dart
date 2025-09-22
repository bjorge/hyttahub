import 'dart:async';

import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:protobuf/protobuf.dart';

class AllowedEmailsBloc
    extends Bloc<AllowedEmailsBlocEvent, AllowedEmailsBlocState> {
  AllowedEmailsBloc(this.collectionPath) : super(AllowedEmailsBlocState()) {
    on<AllowedEmailsBlocEvent>(_onAllowedEmailsBlocEvent);
  }

  final String collectionPath;
  StreamSubscription<QuerySnapshot>? _subscription;

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  FutureOr<void> _onAllowedEmailsBlocEvent(
    AllowedEmailsBlocEvent event,
    Emitter<AllowedEmailsBlocState> emit,
  ) async {
    if (event.hasFetchNow()) {
      emit(
        AllowedEmailsBlocState(state: AllowedEmailsBlocState_State.fetching)
          ..freeze(),
      );

      await _subscription?.cancel();
      final usersCollection = FirebaseFirestore.instance.collection(
        collectionPath,
      );

      _subscription = usersCollection.snapshots().listen(
        (querySnapshot) {
          final fetchedState = state.deepCopy();
          fetchedState.state = AllowedEmailsBlocState_State.success;
          fetchedState.emails.clear();
          for (final doc in querySnapshot.docs) {
            final data = doc.data();
            if (data.containsKey(fbUserId)) {
              fetchedState.emails[doc.id] = AllowedEmailsBlocState_UserInfo(
                userId: data[fbUserId] as int,
              );
            }
          }
          if (!isClosed) {
            add(AllowedEmailsBlocEvent(updateNow: fetchedState));
          }
        },
        onError: (e) {
          final errorState = state.deepCopy();
          if (e is FirebaseException && e.code == 'permission-denied') {
            errorState.state = AllowedEmailsBlocState_State.permissionDenied;
          } else {
            errorState.state = AllowedEmailsBlocState_State.error;
          }
          errorState.emails.clear();
          if (!isClosed) {
            add(AllowedEmailsBlocEvent(updateNow: errorState));
          }
        },
      );
    }
    if (event.hasUpdateNow()) {
      emit(event.updateNow);
    }
  }
}
