import 'package:blocproject/constants.dart';
import 'package:blocproject/pages/cubits/chat_cubit/chat_cubit.dart';
import 'package:blocproject/pages/cubits/chat_cubit/chat_state.dart';
import 'package:blocproject/widgets/chat_buble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatelessWidget {
  static String id = 'ChatPage';

  final _controller = ScrollController();

  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments as String?;
    var cubit = BlocProvider.of<ChatCubit>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kLogo,
              height: 50,
            ),
            const Text('chat'),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                var messagesList =
                    BlocProvider.of<ChatCubit>(context).messagesList;
                return ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == email
                          ? ChatBuble(
                              message: messagesList[index],
                            )
                          : ChatBubleForFriend(message: messagesList[index]);
                    });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: cubit.controller,
              onSubmitted: (data) {
                final messageText = data.trim();
                if (messageText.isNotEmpty && email != null) {
                  BlocProvider.of<ChatCubit>(context)
                      .sendMessage(message: messageText, email: email);
                  cubit.controller!.clear();
                  _controller.animateTo(0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                }
              },
              decoration: InputDecoration(
                hintText: 'Send Message',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final messageText = cubit.controller!.text.trim();
                    if (messageText.isNotEmpty && email != null) {
                      BlocProvider.of<ChatCubit>(context)
                          .sendMessage(message: messageText, email: email);
                      cubit.controller!.clear();
                      _controller.animateTo(0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
