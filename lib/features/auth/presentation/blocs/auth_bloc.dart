import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:document_scanner/features/auth/core/exceptions/auth_execptions.dart';
import 'package:document_scanner/features/auth/core/services/firebase_services.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  AuthBloc() : super(AuthInitial()) {
    on<SignUpUserStarted>(_signUpUser);
    on<SignInUserStarted>(_signInUser);
    on<SignOutUserStarted>(_signOutUser);
  }

  void _signOutUser(
    SignOutUserStarted event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _auth.signOut();

      emit(AuthInitial());
    } on AuthException catch (e) {
      emit(AuthFail(exception: e));
    }
  }

  void _signInUser(
    SignInUserStarted event,
    Emitter<AuthState> emit,
  ) async {
    try {
      User? user = await _auth.signInWithEmailAndPassword(
        event.email,
        event.password,
      );

      if (user != null) {
        emit(AuthSuccess(
          message: "Successfully sign in user",
          user: user,
        ));
      } else {
        throw Exception('Unable to create user');
      }
    } on AuthException catch (e) {
      emit(AuthFail(exception: e));
    }
  }

  void _signUpUser(
    SignUpUserStarted event,
    Emitter<AuthState> emit,
  ) async {
    try {
      if (event.confirmPassword != event.password) {
        throw AuthException("Confirm password and password doesn't match");
      }

      emit(AuthInProgress());

      User? user = await _auth.signUpWithEmailAndPassword(
        event.email,
        event.password,
      );

      PlatformFile? profileImage = event.profileImage;
      UploadTask? uploadTask;
      String? urlDownloadLink;

      if (profileImage != null) {
        final profileImagePath = 'images/profile/${profileImage.name}';
        final file = File(profileImage.path!);
        final ref = FirebaseStorage.instance.ref().child(profileImagePath);

        uploadTask = ref.putFile(file);

        uploadTask.snapshotEvents.listen((event) {
          double progress =
              event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
          EasyLoading.showProgress(progress,
              status: '${(progress * 100).round()}%');
        }).onError((error) {
          throw Exception('Something went wrong uploading image.');
        });

        final snapshot = await uploadTask.whenComplete(() => {
              EasyLoading.dismiss(),
            });

        urlDownloadLink = await snapshot.ref.getDownloadURL();
      }

      if (user != null) {
        await user.updateDisplayName("${event.firstName} ${event.lastName}");

        if (urlDownloadLink != null) {
          await user.updatePhotoURL(urlDownloadLink);
        }

        emit(AuthSuccess(
          message: "Successfully sign in user",
          user: user,
        ));
      } else {
        throw Exception('Unable to create user');
      }
    } on AuthException catch (e) {
      emit(AuthFail(exception: e));
    }
  }
}
