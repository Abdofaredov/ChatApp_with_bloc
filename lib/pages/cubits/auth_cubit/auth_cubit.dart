import 'package:blocproject/pages/cubits/auth_cubit/auth_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  bool isLoading = false;
  GlobalKey<FormState> formKeyLogin = GlobalKey();
  GlobalKey<FormState> formKeyRegister = GlobalKey();

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

  Future<void> registerUser(
      {required String email, required String password}) async {
    emit(RegisterLoading());
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // التأكد من عدم قيمة `null` لمعرف المستخدم
      if (userCredential.user != null) {
        // إضافة بيانات المستخدم إلى Firestore
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'email': email,
            // يمكنك إضافة المزيد من البيانات هنا مثل اسم المستخدم وما إلى ذلك
          });
        } catch (e) {
          emit(RegisterFailure(error: 'Error adding user data to Firestore'));
          return;
        }

        emit(RegisterSuccess());
      } else {
        emit(RegisterFailure(error: 'Failed to sign in'));
      }
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'weak-password') {
        emit(RegisterFailure(error: 'weak password'));
      } else if (ex.code == 'email-already-in-use') {
        emit(RegisterFailure(error: 'email already exists'));
      } else {
        emit(RegisterFailure(error: 'there was an error'));
      }
    } catch (e) {
      emit(RegisterFailure(error: 'there was an error'));
    }
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPasswordShow = true;

  void changePasswordVisibility() {
    isPasswordShow = !isPasswordShow;

    suffix = isPasswordShow
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(ChangePaswordVisibilityState());
  }
}
