import 'package:fin/pages/buffer_page.dart';
import 'package:fin/pages/chatRoom.dart';
import 'package:fin/pages/home_page.dart';
import 'package:fin/pages/journal.dart';
import 'package:fin/pages/login.dart';
import 'package:fin/pages/profile.dart';
import 'package:fin/pages/questionnaires.dart';
import 'package:fin/pages/recreation.dart';
import 'package:fin/pages/therapist.dart';
import 'package:fin/utils/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fin',
      initialRoute : "/login",
      routes: {
        MyRoutes.loginRoute : (context) => const LoginPage(),
        MyRoutes.bufferRoute : (context) => const BufferPage(),
        MyRoutes.profileRoute : (context) => const ProfilePage(),
        MyRoutes.homeRoute : (context) => const HomePage(),
        MyRoutes.chatRoomRoute : (context) => const ChatRoom(),
        MyRoutes.questionnairesRoute: (context) => const Questionnaires(),
        MyRoutes.therapistRoute : (context) => const Therapist(),
        MyRoutes.journalRoute : (context) => const Journal(),
        MyRoutes.recreationRoute : (context) => const Recreation(),
      },
    );
  }
}
