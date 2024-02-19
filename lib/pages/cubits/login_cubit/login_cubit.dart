import 'package:bloc/bloc.dart';
import 'package:blocproject/pages/cubits/login_cubit/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
  String? email, password;

  Future<void> loginUser(
      {required String email, required String password}) async {
    emit(LoginLoading());
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure(error: 'Failed to sign in'));
      }
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'user-not-found') {
        emit(LoginFailure(error: 'User not found'));
      } else if (ex.code == 'wrong-password') {
        emit(LoginFailure(error: 'Wrong password'));
      } else {
        emit(LoginFailure(error: 'Something went wrong'));
      }
    } catch (e) {
      emit(LoginFailure(error: 'Something went wrong'));
    }
  }
}
