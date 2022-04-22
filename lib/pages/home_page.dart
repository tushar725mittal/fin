import 'package:fin/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Friend In Need 2.0"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.vxNav.push(Uri.parse(MyRoutes.questionnairesRoute));
          },
          child: const Text("Questions"),
        ),
      ),
    );
  }
}
