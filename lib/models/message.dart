import 'package:blocproject/constants.dart';

class Message {
  final String message;
  final String id;

  Message(this.message, this.id);

  factory Message.fromJson(jsonData) {
    final String message = jsonData[kMessage] ??
        ''; // التحقق من عدم الإفراط في قيمة 'Null' واستخدام قيمة افتراضية ''
    final String id = jsonData['id'] ??
        ''; // التحقق من عدم الإفراط في قيمة 'Null' واستخدام قيمة افتراضية ''

    return Message(message, id);
  }
}
