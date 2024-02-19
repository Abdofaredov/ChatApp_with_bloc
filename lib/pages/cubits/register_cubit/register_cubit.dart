import 'package:bloc/bloc.dart';
import 'package:blocproject/pages/cubits/register_cubit/register_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  String? email, password;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();

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
}
