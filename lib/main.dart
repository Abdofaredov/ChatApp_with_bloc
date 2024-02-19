import 'package:blocproject/pages/chat_page.dart';
import 'package:blocproject/pages/cubits/chat_cubit/chat_cubit.dart';
import 'package:blocproject/pages/cubits/login_cubit/login_cubit.dart';
import 'package:blocproject/pages/cubits/register_cubit/register_cubit.dart';
import 'package:blocproject/pages/login_page.dart';
import 'package:blocproject/pages/resgister_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
        BlocProvider(
          create: (context) => ChatCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: false),
        routes: {
          LoginPage.id: (context) => const LoginPage(),
          RegisterPage.id: (context) => const RegisterPage(),
          ChatPage.id: (context) => ChatPage()
        },
        initialRoute: LoginPage.id,
      ),
    );
  }
}
