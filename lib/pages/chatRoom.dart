import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fin/utils/routes.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoom();
}

class _ChatRoom extends State<ChatRoom> {
  String code = "";

  void handleCodeSubmission() async {
    print(code);

    bool state = false;
    String url =
        "https://friend-in-need-553e4-default-rtdb.firebaseio.com/Chatrooms/" +
            code +
            ".json";

    Response res = await get(Uri.parse(url));

    Map data = json.decode(res.body) ?? {};

    if (res.statusCode != 200 || data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Invalid code'),
      ));

      return;
    }

    print(data);
    print(url);

    context.vxNav
        .push(Uri.parse(MyRoutes.innerchatroomRoute), params: {"code": code});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatroom"),
        centerTitle: true,
      ),
      body: Container(
          child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Code',
            ),
            onChanged: (text) {
              setState(() {
                code = text;
              });
            },
          ),
          ElevatedButton(
              onPressed: handleCodeSubmission, child: Text("Submit")),
        ],
      )),
    );
  }
}
