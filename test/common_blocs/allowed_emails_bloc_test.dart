import 'package:bloc_test/bloc_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/common_blocs/allowed_emails_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';

void main() {
  group('AllowedEmailsBloc', () {
    late FakeFirebaseFirestore fakeFirestore;
    const collectionPath = 'allowed_emails';

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
    });

    AllowedEmailsBloc buildBloc() {
      return AllowedEmailsBloc(collectionPath, firestore: fakeFirestore);
    }

    test('initial state is correct', () {
      expect(buildBloc().state, AllowedEmailsBlocState());
    });

    group('FetchNow event', () {
      blocTest<AllowedEmailsBloc, AllowedEmailsBlocState>(
        'emits [fetching, success] when snapshots stream emits data',
        setUp: () async {
          // Add initial data to the fake collection.
          await fakeFirestore
              .collection(collectionPath)
              .doc('test@email.com')
              .set({fbUserId: 123});
          await fakeFirestore
              .collection(collectionPath)
              .doc('another@email.com')
              .set({fbUserId: 456});
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
            },
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
        emails: {'new@email.com': AllowedEmailsBlocState_UserInfo(userId: 999)},
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
