import 'package:fin/pages/buffer_page.dart';
import 'package:fin/pages/chatRoom.dart';
import 'package:fin/pages/home_page.dart';
import 'package:fin/pages/journal.dart';
import 'package:fin/pages/login.dart';
import 'package:fin/pages/profile.dart';
import 'package:fin/pages/questionnaire/questionnaire.dart';
import 'package:fin/pages/recreation.dart';
import 'package:fin/pages/password_reset.dart';
import 'package:fin/pages/signup.dart';
import 'package:fin/pages/therapist.dart';
import 'package:fin/pages/verify_page.dart';
import 'package:fin/utils/routes.dart';
import 'package:fin/pages/innerchatroom.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routeInformationParser: VxInformationParser(),
          routerDelegate: VxNavigator(
            routes: {
              "/": (_, __) => const MaterialPage(child: LoginPage()),      //CHANGE THIS TO HOMEPAGE LATER
              MyRoutes.loginRoute: (_, __) =>
                  const MaterialPage(child: LoginPage()),
              MyRoutes.resetRoute: (_, __) =>
                  const MaterialPage(child: ResetPage()),
              MyRoutes.signupRoute: (_, params) => MaterialPage(
                      child: SignUp(
                    email: params["email"],
                  )),
              MyRoutes.verifyRoute: (_, __) =>
                  const MaterialPage(child: VerifyScreen()),
              MyRoutes.bufferRoute: (_, __) =>
                  const MaterialPage(child: BufferPage()),
              MyRoutes.profileRoute: (_, __) =>
                  const MaterialPage(child: ProfilePage()),
              MyRoutes.homeRoute: (_, __) =>
                  const MaterialPage(child: HomePage()),
              MyRoutes.chatRoomRoute: (_, __) =>
                  const MaterialPage(child: ChatRoom()),
              MyRoutes.questionnairesRoute: (_, __) =>
                  const MaterialPage(child: Questionnaire()),
              MyRoutes.therapistRoute: (_, __) =>
                  const MaterialPage(child: Therapist()),
              MyRoutes.journalRoute: (_, __) =>
                  const MaterialPage(child: Journal()),
              MyRoutes.recreationRoute: (_, __) =>
                  const MaterialPage(child: Recreation()),
              MyRoutes.innerchatroomRoute: (_, params) => MaterialPage(
                      child: InnerChat(
                    code: params['code'],
                  )),
            },
          ),
        );
      },
    );
  }
}
