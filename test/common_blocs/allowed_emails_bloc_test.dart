import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/common_blocs/allowed_emails_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';

import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/storage/hyttahub_storage_factory.dart';
import 'package:hyttahub/storage/in_memory_hyttahub_storage.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';

void main() {
  group('AllowedEmailsBloc', () {
    late InMemoryHyttaHubStorage inMemoryStorage;
    const collectionPath = 'allowed_emails';

    setUp(() {
      inMemoryStorage = InMemoryHyttaHubStorage();
      HyttaHubOptions.implementation = HyttaHubImplementation(
        storage: StorageEnum.memory,
      );
      HyttaHubStorageFactory.setStorage(
        StorageEnum.memory,
        inMemoryStorage,
      );
    });

    AllowedEmailsBloc buildBloc() {
      return AllowedEmailsBloc(collectionPath);
    }

    test('initial state is correct', () {
      expect(buildBloc().state, AllowedEmailsBlocState());
    });

    group('FetchNow event', () {
      blocTest<AllowedEmailsBloc, AllowedEmailsBlocState>(
        'emits [fetching, success] when snapshots stream emits data',
        setUp: () async {
          // Add initial data to the in-memory storage.
          await inMemoryStorage.setDocument(collectionPath, 'test@email.com', {fbUserId: 123});
          await inMemoryStorage.setDocument(collectionPath, 'another@email.com', {fbUserId: 456});
        },
        build: buildBloc,
        act: (bloc) => bloc.add(
          AllowedEmailsBlocEvent(
            fetchNow: AllowedEmailsBlocEvent_FetchedAllowedEmails(),
          ),
        ),
        // We expect two states: the initial fetching state, and then the success state
        // which is added inside the stream listener via another event.
        expect: () => [
          AllowedEmailsBlocState(state: AllowedEmailsBlocState_State.fetching),
          AllowedEmailsBlocState(
            state: AllowedEmailsBlocState_State.success,
            emails: {
              'test@email.com': AllowedEmailsBlocState_UserInfo(userId: 123),
              'another@email.com': AllowedEmailsBlocState_UserInfo(userId: 456),
            }.entries,
          ),
        ],
      );

      // the secuirty rules for this test are not working as expected
      //       blocTest<AllowedEmailsBloc, AllowedEmailsBlocState>(
      //         'emits [fetching, permissionDenied] on permission-denied error',
      //         build: () {
      //           // Deny all reads to simulate a permission error. We must also
      //           // simulate an authenticated user for the rules to be evaluated.
      //           final erroringFirestore = FakeFirebaseFirestore(
      //             authObject: Stream.value({'uid': 'test-uid'}),
      //             securityRules: '''rules_version = '2';
      // service cloud.firestore { match /databases/{database}/documents { match /{document=**} { allow read, write: if false; } } }''',
      //           );
      //           return AllowedEmailsBloc(
      //             collectionPath,
      //             firestore: erroringFirestore,
      //           );
      //         },
      //         act: (bloc) => bloc.add(
      //           AllowedEmailsBlocEvent(
      //             fetchNow: AllowedEmailsBlocEvent_FetchedAllowedEmails(),
      //           ),
      //         ),
      //         expect: () => [
      //           AllowedEmailsBlocState(state: AllowedEmailsBlocState_State.fetching),
      //           AllowedEmailsBlocState(
      //             state: AllowedEmailsBlocState_State.permissionDenied,
      //           ),
      //         ],
      //       );

      // this test has some compilation issues
      // blocTest<AllowedEmailsBloc, AllowedEmailsBlocState>(
      //   'emits [fetching, error] on generic error',
      //   build: () {
      //     // We can simulate a generic error by creating a stream that
      //     // immediately throws an exception.
      //     final streamWithError = Stream<QuerySnapshot>.error(
      //       Exception('Generic error'),
      //     );
      //     return AllowedEmailsBloc(
      //       collectionPath,
      //       firestore: FakeFirebaseFirestore(stream: streamWithError),
      //     );
      //   },
      //   act: (bloc) => bloc.add(
      //     AllowedEmailsBlocEvent(
      //       fetchNow: AllowedEmailsBlocEvent_FetchedAllowedEmails(),
      //     ),
      //   ),
      //   skip: 1, // Skip the initial 'fetching' state
      //   expect: () => [
      //     AllowedEmailsBlocState(state: AllowedEmailsBlocState_State.error),
      //   ],
      // );
    });

    group('UpdateNow event', () {
      final updatedState = AllowedEmailsBlocState(
        state: AllowedEmailsBlocState_State.success,
        emails: {'new@email.com': AllowedEmailsBlocState_UserInfo(userId: 999)}.entries,
      );

      blocTest<AllowedEmailsBloc, AllowedEmailsBlocState>(
        'emits the state from the event',
        build: buildBloc,
        act: (bloc) =>
            bloc.add(AllowedEmailsBlocEvent(updateNow: updatedState)),
        expect: () => [updatedState],
      );
    });
  });
}
