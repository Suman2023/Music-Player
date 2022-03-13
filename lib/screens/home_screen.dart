import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/widgets/music_controller.dart';
import 'package:path/path.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  PlatformFile? dirPath1;

  AudioPlayer _player = AudioPlayer();
  List<AudioSource> audioSource = [];
  List<String> playlist = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var i = 0; i < 100; i++) {
      playlist.add("name of the song with index " + i.toString());
    }
  }

  void selectDirPath() async {
    //TODO: trying out with single file for now.. target: Dir
    try {
      // FilePickerResult? result = await FilePicker.platform.pickFiles(
      //   type: FileType.custom,
      //   allowedExtensions: ['mp3'],
      // );

      String? result = await FilePicker.platform.getDirectoryPath();

      List<FileSystemEntity> entities =
          await Directory(result!).list().toList();
      playlist.clear();
      audioSource.clear();
      for (var file in entities) {
        if (extension(file.path) == ".mp3") {
          audioSource.add(AudioSource.uri(Uri.file(file.path)));
          playlist.add(basenameWithoutExtension(file.path));
        }
      }
      var allsongs = ConcatenatingAudioSource(children: audioSource);
      // await _player.setFilePath(result!.files.single.path!);

      await _player.setAudioSource(allsongs, preload: true);
    } catch (e) {
      print(e);
    }
  }

  void playSound() async {
    var dur = _player.play();
  }

  int count = 1;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          drawer: Drawer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectDirPath();
                      });
                    },
                    child: Text("Select Music Location"))
              ],
            ),
          ),
          appBar: AppBar(
            title: Text("Music Player"),
          ),
          body: Stack(
            children: [
              Container(
                height: height,
                width: width,
                color: Colors.red,
              ),
              Positioned(
                top: 10,
                left: width * .175,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: height * .35,
                    width: width * .65,
                    color: Colors.green,
                  ),
                ),
              ),
              Positioned(
                top: height * .35 + 10,
                left: width * .175,
                child: Container(
                  width: width * .65,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Song Name",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                      Text("Artist"),
                    ],
                  ),
                ),
              ),

              // Positioned(
              //   top: height * .45 + 20,
              //   child: SizedBox(
              //     width: width,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceAround,
              //       children: [
              //         IconButton(onPressed: () {}, icon: Icon(Icons.loop)),
              //         IconButton(
              //             onPressed: () {}, icon: Icon(Icons.arrow_left)),
              //         StreamBuilder<PlayerState>(
              //             stream: _player.playerStateStream,
              //             builder: (context, snapshot) {
              //               var playerState = snapshot.data;
              //               var processingState = playerState?.processingState;
              //               var playing = playerState?.playing;
              //               if (playing != true) {
              //                 return IconButton(
              //                     onPressed: () {
              //                       _player.play();
              //                     },
              //                     icon: Icon(Icons.play_arrow));
              //               } else if (processingState !=
              //                   ProcessingState.completed) {
              //                 return IconButton(
              //                     onPressed: () {
              //                       _player.pause();
              //                     },
              //                     icon: Icon(Icons.pause));
              //               } else {
              //                 return IconButton(
              //                     onPressed: () {
              //                       _player.effectiveIndices!.first;
              //                     },
              //                     icon: Icon(Icons.replay));
              //               }
              //             }),
              //         IconButton(
              //             onPressed: () {}, icon: Icon(Icons.arrow_right)),
              //         IconButton(onPressed: () {}, icon: Icon(Icons.shuffle)),
              //       ],
              //     ),
              //   ),
              // ),
              // Positioned(
              //   top: height * .45 + 80,
              //   right: width * .075,
              //   child: Container(
              //     color: Colors.blueGrey,
              //     height: height * .5,
              //     width: width * .85,
              //     child: ListView.builder(
              //         shrinkWrap: true,
              //         itemCount: playlist.length,
              //         itemBuilder: (_, index) => Container(
              //                 child: ListTile(
              //               leading: Icon(Icons.play_arrow),
              //               title: Text(
              //                 playlist[index],
              //                 maxLines: 1,
              //               ),
              //               subtitle: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                 children: [
              //                   Text("artist name"),
              //                   Text("album"),
              //                 ],
              //               ),
              //               trailing: Icon(Icons.menu),
              //             ))),
              //   ),
              // ),
              Positioned(
                top: height * .45,
                child: StreamBuilder<Duration>(
                    stream: _player.positionStream,
                    builder: (context, snapshot) {
                      var seconds =
                          (snapshot.data!.inMilliseconds % (60 * 1000)) / 1000;
                      var duration =
                          (_player.duration!.inMilliseconds % (60 * 1000)) /
                              1000;
                      return Container(
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.play,
                                    size: 12,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  // var
                                  // return '${duration.inMinutes}m${seconds.toStringAsFixed(2)}s';
                                  Text(snapshot.data == null
                                      ? "00:00"
                                      : snapshot.data!.inMinutes.toString() +
                                          ":" +
                                          seconds.toStringAsFixed(0))
                                ],
                              ),
                              Text(_player.duration == null
                                  ? "00:00"
                                  : _player.duration!.inMinutes.toString() +
                                      ":" +
                                      duration.toStringAsFixed(0))
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              Positioned(
                  top: height * .5,
                  left: 0.5 * width - 150,
                  child: MusicController(
                    player: _player,
                  )),
            ],
          )),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _player.dispose();
  }
}
