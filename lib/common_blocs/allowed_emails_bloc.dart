import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/storage/hyttahub_storage_factory.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';

class AllowedEmailsBloc
    extends Bloc<AllowedEmailsBlocEvent, AllowedEmailsBlocState> {
  AllowedEmailsBloc(this.collectionPath)
    : super(AllowedEmailsBlocState()) {
    on<AllowedEmailsBlocEvent>(_onAllowedEmailsBlocEvent);
  }

  final String collectionPath;

  FutureOr<void> _onAllowedEmailsBlocEvent(
    AllowedEmailsBlocEvent event,
    Emitter<AllowedEmailsBlocState> emit,
  ) async {
    if (event.hasFetchNow()) {
      emit(
        AllowedEmailsBlocState(state: AllowedEmailsBlocState_State.fetching)
          ..freeze(),
      );

      final storage = HyttaHubStorageFactory.getStorage(
        HyttaHubOptions.implementation?.storage ?? StorageEnum.firestore,
      );

      await emit.onEach<Map<String, Map<String, dynamic>>>(
        storage.listenCollection(collectionPath),
        onData: (collection) {
          final Map<String, AllowedEmailsBlocState_UserInfo> emails = {};
          for (final entry in collection.entries) {
            final data = entry.value;
            if (data.containsKey(fbUserId)) {
              emails[entry.key] = AllowedEmailsBlocState_UserInfo(
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
          // Note: In a real app we might want to check the error type
          // but our abstraction currently doesn't return FirebaseException.
          emit(
            AllowedEmailsBlocState(state: AllowedEmailsBlocState_State.error),
          );
        },
      );
    }
    if (event.hasUpdateNow()) {
      emit(event.updateNow);
    }
  }
}
