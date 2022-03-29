import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:core';

class MsgBox extends StatelessWidget {
  final Map data;

  MsgBox(this.data);

  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(this.data["time"]) * 1000);

    String date_string = "${date.hour}:${date.minute}";

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        width: 100,
        child: Container(
          color: Colors.amberAccent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(this.data["user"]),
              Text(this.data["msg"]),
              Text(date_string),
            ],
          ),
        ),
      ),
    );
  }
}

class InnerChat extends StatefulWidget {
  final String code;

  const InnerChat({@required this.code = "", Key? key}) : super(key: key);

  @override
  State<InnerChat> createState() => _InnerChat();
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class _InnerChat extends State<InnerChat> {
  final fieldText = TextEditingController();
  final String UserName = getRandomString(10);
  String Msgtext = "";
  List MsgLst = [
    {
      "time": "0",
      "user": "",
      "msg": "Loading...",
    }
  ];
  int count = 0;

  void getMsg(timer) async {
    String url =
        "https://friend-in-need-553e4-default-rtdb.firebaseio.com/Chatrooms/" +
            widget.code +
            "/count.json";

    Response res = await get(Uri.parse(url));

    int new_count = json.decode(res.body) ?? 0;

    if (new_count <= count) return;

    String msgUrl =
        "https://friend-in-need-553e4-default-rtdb.firebaseio.com/Chatrooms/" +
            widget.code +
            ".json";

    res = await get(Uri.parse(msgUrl));

    Map NewMsgMap = json.decode(res.body) ?? MsgLst;
    NewMsgMap.remove("count");

    List NewMsgLst = [];

    for (var k in NewMsgMap.keys) {
      NewMsgLst.add({
        "time": k,
        "user": NewMsgMap[k]["user"],
        "msg": NewMsgMap[k]["msg"],
      });
    }

    setState(() {
      MsgLst = NewMsgLst;
      count = new_count;
    });
  }

  void sendMsg() async {
    String msgUrl =
        "https://friend-in-need-553e4-default-rtdb.firebaseio.com/Chatrooms/" +
            widget.code +
            ".json";

    Response res = await get(Uri.parse(msgUrl));

    Map NewMsgMap = json.decode(res.body) ?? MsgLst;

    NewMsgMap[(DateTime.now().millisecondsSinceEpoch / 1000)
        .floor()
        .toString()] = {"msg": Msgtext, "user": UserName};

    NewMsgMap["count"]++;

    //print(NewMsgMap);

    res = await patch(Uri.parse(msgUrl), body: json.encode(NewMsgMap));

    if (res.statusCode == 200)
      print("sent");
    else
      print("not sent ${res.statusCode}");

    fieldText.clear();
    setState(() {
      Msgtext = "";
    });
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(new Duration(seconds: 1), getMsg);
  }

  @override
  void dispose() {
    fieldText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatroom"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: MsgLst.map((e) => MsgBox(e)).toList(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 100,
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: TextField(
                      controller: fieldText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Message',
                        fillColor: Colors.amberAccent,
                        filled: true,
                      ),
                      onChanged: (text) {
                        setState(() {
                          Msgtext = text;
                        });
                      },
                      style: TextStyle(
                        backgroundColor: Colors.amberAccent,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child:
                        IconButton(onPressed: sendMsg, icon: Icon(Icons.send)),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
