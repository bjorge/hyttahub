// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:hyttahub/proto/auth_bloc.pb.dart';
import 'package:bloc/bloc.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:protobuf/protobuf.dart';

const debugAwaitDelayMilliseconds = 500;

class AuthBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  AuthBloc() : super(AuthBlocState(authState: AuthState.initializing)) {
    on<AuthBlocEvent>(_onAuthBlockEvent);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  var _onErrorMessage = "";

  Future<Map<bool, User?>> _checkAndUseToken() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return {false: null};
    }

    try {
      String? token = await user.getIdToken(true);

      if (token == null) {
        return {false: null};
      }

      return {true: user};
    } catch (e) {
      return {false: null};
    }
  }

  bool _emailVerified(User user) {
    final email = user.email ?? 'unknown';
    if (email == 'unknown') {
      return false;
    }
    return user.emailVerified;
  }

  FutureOr<void> _onAuthBlockEvent(
    AuthBlocEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    if (event.hasStartup()) {
      try {
        /********* startingState ***********/
        final startingState = state.deepCopy();
        startingState.authState = AuthState.initializing;
        startingState.clearEmail();
        _user = null;

        startingState.clearErrorMessage();
        _onErrorMessage = "";
        emit(startingState..freeze());

        /********* authenticatingState ***********/
        final authenticatingState = state.deepCopy();
        authenticatingState.authState = AuthState.authenticating;
        emit(authenticatingState..freeze());
        _onErrorMessage = '''
Could not fetch the terms of service.
Please check that your internet connection is strong.
''';
        final result = await _checkAndUseToken();
        final stillLoggedIn = result.keys.first;

        if (!stillLoggedIn) {
          /********* loggedOutState ***********/
          final loggedOutState = state.deepCopy();
          loggedOutState.authState = AuthState.unauthenticated;
          emit(loggedOutState..freeze());
          return;
        } else {
          _user = result.values.first!;
          await _finishAuthentication(event, emit);
        }
      } on FirebaseAuthException catch (e) {
        final authErrorState = state.deepCopy();
        authErrorState.authState = AuthState.authenticationError;
        authErrorState.errorMessage =
            e.message ??
            '''
$_onErrorMessage\n
Info: $e
''';
        emit(authErrorState..freeze());
        return;
      } catch (e) {
        final authErrorState = state.deepCopy();
        authErrorState.authState = AuthState.authenticationError;
        authErrorState.errorMessage =
            '''
$_onErrorMessage\n
Info: $e
''';
        emit(authErrorState..freeze());
        return;
      }
    }

    if (event.hasEmailSignup()) {
      try {
        /********* validate that the user is actually a service admin  ***********/
        if (event.emailSignup.hasServiceAdmin() &&
            event.emailSignup.serviceAdmin) {}
        /********* registeringState ***********/

        final registeringState = state.deepCopy();
        registeringState.authState = AuthState.registering;
        registeringState.isServiceAdmin = event.emailSignup.serviceAdmin;
        registeringState.clearEmail();
        registeringState.clearErrorMessage();
        _onErrorMessage = "";
        emit(registeringState..freeze());

        /********* registeringState ***********/
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: event.emailSignup.email,
          password: event.emailSignup.password,
        );

        _user = userCredential.user!;
        await _finishAuthentication(event, emit);
      } on FirebaseAuthException catch (e) {
        final authErrorState = state.deepCopy();
        authErrorState.authState = AuthState.authenticationError;
        authErrorState.errorMessage =
            e.message ??
            '''
$_onErrorMessage\n
Info: $e
''';
        emit(authErrorState..freeze());
        return;
      } catch (e) {
        final authErrorState = state.deepCopy();
        authErrorState.authState = AuthState.authenticationError;
        authErrorState.errorMessage =
            '''
$_onErrorMessage\n
Info: $e
''';
        emit(authErrorState..freeze());
        return;
      }
    }

    if (event.hasEmailLogin()) {
      try {
        /********* loggingInState ***********/
        final loggingInState = state.deepCopy();
        loggingInState.authState = AuthState.authenticating;
        loggingInState.isServiceAdmin = event.emailLogin.serviceAdmin;
        loggingInState.clearEmail();
        _user = null;

        loggingInState.clearErrorMessage();
        _onErrorMessage = "";
        emit(loggingInState..freeze());
        /********* authenticatingState ***********/
        UserCredential? userCredential;
        emit(loggingInState);
        _onErrorMessage = '''
Login was not successful. Please try again.
''';
        userCredential = await _auth.signInWithEmailAndPassword(
          email: event.emailLogin.email,
          password: event.emailLogin.password,
        );

        _user = userCredential.user;
        await _finishAuthentication(event, emit);
      } on FirebaseAuthException catch (e) {
        final authErrorState = state.deepCopy();
        authErrorState.authState = AuthState.authenticationError;
        authErrorState.errorMessage =
            e.message ??
            '''
$_onErrorMessage\n
Info: $e
''';
        emit(authErrorState..freeze());
        return;
      } catch (e) {
        final authErrorState = state.deepCopy();
        authErrorState.authState = AuthState.authenticationError;
        if (_user != null && _user!.email != null) {
          // add the email so that the sys admin can make changes in the error screen
          authErrorState.email = _user!.email!;
        }
        authErrorState.errorMessage =
            '''
$_onErrorMessage\n
Info: $e
''';
        emit(authErrorState..freeze());
        return;
      }
    }
    if (event.hasEmailForgotPassword()) {
      try {
        /********* submittingForgottenPasswordRequest ***********/
        final submittingForgottenPasswordRequest = state.deepCopy();
        submittingForgottenPasswordRequest.authState =
            AuthState.submittingForgottenPasswordRequest;
        submittingForgottenPasswordRequest.clearEmail();
        _user = null;

        submittingForgottenPasswordRequest.clearErrorMessage();
        _onErrorMessage = '''
Reset password was not successful. Please try again.
''';
        emit(submittingForgottenPasswordRequest..freeze());
        await _auth.sendPasswordResetEmail(
          email: event.emailForgotPassword.email,
        );
        final forgottenPasswordEmailSent = state.deepCopy();
        forgottenPasswordEmailSent.authState =
            AuthState.forgottenPasswordEmailSent;
        emit(forgottenPasswordEmailSent..freeze());
      } on FirebaseAuthException catch (e) {
        final authErrorState = state.deepCopy();
        authErrorState.authState = AuthState.authenticationError;
        authErrorState.errorMessage =
            e.message ??
            '''
$_onErrorMessage\n
Info: $e
''';
        emit(authErrorState..freeze());
        return;
      } catch (e) {
        final authErrorState = state.deepCopy();
        if (_user != null && _user!.email != null) {
          // add the email so that the sys admin can make changes in the error screen
          authErrorState.email = _user!.email!;
        }
        authErrorState.authState = AuthState.authenticationError;
        authErrorState.errorMessage =
            '''
$_onErrorMessage\n
Info: $e
''';
        emit(authErrorState..freeze());
        return;
      }
    }

    if (event.hasRemoveAccount()) {
      try {
        // check for this corner case...
        if (_user == null || _user!.email == null) {
          /********* authErrorState ***********/
          final unexpectedAuthErrorState = state.deepCopy();
          unexpectedAuthErrorState.authState = AuthState.authenticationError;
          unexpectedAuthErrorState.errorMessage = '''
Unexpected error removing account. Please login and try agin.
''';
          emit(unexpectedAuthErrorState..freeze());
          return;
        }

        /********* submittingRemoveAccountRequest ***********/
        final submittingRemoveAccountRequest = state.deepCopy();
        submittingRemoveAccountRequest.authState =
            AuthState.submittingRemoveAccountRequest;
        submittingRemoveAccountRequest.clearEmail();
        submittingRemoveAccountRequest.clearErrorMessage();
        _onErrorMessage = '''
Account removal complete.
''';
        emit(submittingRemoveAccountRequest..freeze());

        await _user!.delete();

        /********* unauthenticatedState ***********/
        final unauthenticatedState = state.deepCopy();
        unauthenticatedState.authState = AuthState.unauthenticated;
        unauthenticatedState.clearEmail();
        _user = null;
        unauthenticatedState.clearErrorMessage();
        _onErrorMessage = "";
        emit(unauthenticatedState..freeze());
      } on FirebaseAuthException catch (e) {
        final authErrorState = state.deepCopy();
        authErrorState.authState = AuthState.authenticationError;
        authErrorState.errorMessage =
            e.message ??
            '''
$_onErrorMessage\n
Info: $e
''';
        emit(authErrorState..freeze());
        return;
      } catch (e) {
        final authErrorState = state.deepCopy();
        if (_user != null && _user!.email != null) {
          // add the email so that the sys admin can make changes in the error screen
          authErrorState.email = _user!.email!;
        }
        authErrorState.authState = AuthState.authenticationError;
        authErrorState.errorMessage =
            '''
$_onErrorMessage\n
Info: $e
''';
        emit(authErrorState..freeze());
        return;
      }
    }

    if (event.hasLogout()) {
      /********* submittingSignOutRequest ***********/

      final submittingSignOutRequest = state.deepCopy();
      submittingSignOutRequest.authState = AuthState.submittingSignOutRequest;
      submittingSignOutRequest.clearEmail();
      submittingSignOutRequest.clearErrorMessage();
      _onErrorMessage = '''
Error logging out.
Check your internet connection.
''';
      emit(submittingSignOutRequest..freeze());
      try {
        await _auth.signOut();

        final unauthenticated = state.deepCopy();
        unauthenticated.authState = AuthState.unauthenticated;
        unauthenticated.clearEmail();
        _user = null;
        unauthenticated.clearErrorMessage();
        _onErrorMessage = "";
        emit(unauthenticated..freeze());
      } on FirebaseAuthException catch (e) {
        final authErrorState = state.deepCopy();
        authErrorState.authState = AuthState.authenticationError;
        authErrorState.errorMessage =
            e.message ??
            '''
$_onErrorMessage\n
Info: $e
''';
        emit(authErrorState..freeze());
        return;
      } catch (e) {
        final authErrorState = state.deepCopy();
        authErrorState.authState = AuthState.authenticationError;
        authErrorState.errorMessage =
            '''
$_onErrorMessage\n
Info: $e
''';
        emit(authErrorState..freeze());
        return;
      }
    }
  }

  FutureOr<void> _finishAuthentication(
    AuthBlocEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    // shouldn't happen - but just in case...
    if (_user == null || _user!.email == null) {
      _onErrorMessage = "Unauthenticated login is not allowed";
      throw StateError(_onErrorMessage);
    }

    if (!_emailVerified(_user!)) {
      /********* emailVerificationSendingState ***********/
      final emailVerificationSendingState = state.deepCopy();
      emailVerificationSendingState.authState =
          AuthState.submittingEmailVerificationRequest;
      emit(emailVerificationSendingState..freeze());
      _onErrorMessage = '''
Error sending verification email. Please try again.
Please also check that your internet connection is strong.''';
      await _user!.sendEmailVerification();
      /********* emailVerificationSentState ***********/
      final emailVerificationSentState = state.deepCopy();
      emailVerificationSentState.authState = AuthState.emailVerificationSent;
      emit(emailVerificationSentState..freeze());

      return null;
    }

    /********* loggedInState ***********/
    // give the login screen a chance to update the UI
    final loginSuccess = state.deepCopy();
    loginSuccess.authState = AuthState.loginSuccess;
    loginSuccess.email = _user!.email!;
    emit(loginSuccess..freeze());
    await Future.delayed(const Duration(seconds: 1));

    final authenticatedState = state.deepCopy();
    authenticatedState.authState = AuthState.authenticated;
    authenticatedState.email = _user!.email!;
    emit(authenticatedState..freeze());

    return null;
  }
}
