import 'package:blocproject/constants.dart';
import 'package:blocproject/helper/show_snack_bar.dart';
import 'package:blocproject/pages/cubits/chat_cubit/chat_cubit.dart';
import 'package:blocproject/pages/cubits/login_cubit/login_cubit.dart';
import 'package:blocproject/pages/cubits/login_cubit/login_state.dart';
import 'package:blocproject/pages/resgister_page.dart';
import 'package:blocproject/widgets/custom_button.dart';
import 'package:blocproject/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'chat_page.dart';

class LoginPage extends StatelessWidget {
  static String id = 'login page';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<LoginCubit>(context);

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          cubit.isLoading = true;
        } else if (state is LoginSuccess) {
          BlocProvider.of<ChatCubit>(context).getMessages();
          Navigator.pushNamed(context, ChatPage.id, arguments: cubit.email);
          cubit.isLoading = false;
        } else if (state is LoginFailure) {
          showSnackBar(context, state.error.toString());
          cubit.isLoading = false;
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: cubit.isLoading,
          child: Scaffold(
            backgroundColor: kPrimaryColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Form(
                key: cubit.formKey,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 75,
                    ),
                    Image.asset(
                      'assets/images/scholar.png',
                      height: 100,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Scholar Chat',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontFamily: 'pacifico',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 75,
                    ),
                    const Row(
                      children: [
                        Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomFormTextField(
                      onChanged: (data) {
                        cubit.email = data;
                      },
                      hintText: 'Email',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomFormTextField(
                      obscureText: true,
                      onChanged: (data) {
                        cubit.password = data;
                      },
                      hintText: 'Password',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButon(
                      onTap: () async {
                        if (cubit.formKey.currentState!.validate()) {
                          BlocProvider.of<LoginCubit>(context).loginUser(
                              email: cubit.email!, password: cubit.password!);
                        }
                      },
                      text: 'LOGIN',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'dont\'t have an account?',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, RegisterPage.id);
                          },
                          child: const Text(
                            '  Register',
                            style: TextStyle(
                              color: Color(0xffC7EDE6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
