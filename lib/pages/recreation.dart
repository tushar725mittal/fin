import 'dart:convert';

import 'package:fin/models/yt_video_model.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

class Recreation extends StatefulWidget {
  const Recreation({Key? key}) : super(key: key);

  @override
  State<Recreation> createState() => _RecreationState();
}

class _RecreationState extends State<Recreation> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  bool _isPlayerReady = false;

  static List<String> _ids = ["inpok4MKVLM"];
  static int id_index = 0;
  static int _selected = 0;

  @override
  void initState() {
    super.initState();
    loadData();
    _controller = YoutubePlayerController(
      initialVideoId: _ids[0],
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: true,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  loadData() async {
    final response = await http
        .get(Uri.parse("https://tushar725mittal.github.io/yt_fin.json"));
    final catalogJSON = response.body;
    final decodedData = jsonDecode(catalogJSON);

    YtvidList.vidlist = List.from(decodedData)
        .map<Ytvid>((item) => Ytvid.fromMap(item))
        .toList();

    if (YtvidList.vidlist != null) {
      _ids = [];
      for (var item in YtvidList.vidlist!) {
        _ids.add(item.id!);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return (_ids.isNotEmpty)
        ? YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
              onReady: () {
                _isPlayerReady = true;
              },
              onEnded: (data) {
                _controller
                    .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
              },
            ),
            builder: (context, player) => Scaffold(
                body: SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: Column(
                children: [
                  player,
                  YtvidList.vidlist != null && YtvidList.vidlist!.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: YtvidList.vidlist!.length,
                          itemBuilder: (context, index) => Container(
                              color: const Color(0xCCCBE6F2),
                              child: Card(
                                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                elevation: 50,
                                child: ListTile(
                                  contentPadding: (_selected != index)?null : const EdgeInsets.all(20.0),
                                    trailing: SizedBox(
                                      width: MediaQuery.of(context).size.width*0.73,
                                      child: Text(
                                        YtvidList.vidlist![index].title!,
                                        style: (_selected != index)?const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ): const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.red
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                    title: (_selected != index)?const Icon(
                                      Icons.play_circle_outline_outlined,
                                    ): const Icon( 
                                      Icons.pause_circle_outline,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                    dense: true,
                                    subtitle:  (_selected != index)?null : const Text("PLAYING", style: TextStyle(color: Colors.red),),
                                    isThreeLine:  (_selected != index)?false : true,
                                    onTap: () {
                                      _selected = index;
                                      _controller.load(_ids[index]);
                                    }),
                              )))
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ],
              ),
            )),
          )
        : Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
