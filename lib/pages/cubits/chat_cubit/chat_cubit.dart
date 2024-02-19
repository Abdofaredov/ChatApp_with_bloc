import 'package:bloc/bloc.dart';
import 'package:blocproject/constants.dart';
import 'package:blocproject/models/message.dart';
import 'package:blocproject/pages/cubits/chat_cubit/chat_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollections);
  List<Message> messagesList = [];
  TextEditingController? controller = TextEditingController();

  void sendMessage({required String message, required String email}) {
    try {
      messages.add(
        {kMessage: message, kCreatedAt: DateTime.now(), 'id': email},
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  void getMessages() {
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event) {
      messagesList.clear();
      for (var doc in event.docs) {
        messagesList.add(Message.fromJson(doc));
      }
      emit(ChatSuccess(messages: messagesList));
    });
  }
}
