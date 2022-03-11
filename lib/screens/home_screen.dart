import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
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
                    onPressed: () => selectDirPath(),
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
                left: width * .075,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: height * .45,
                    width: width * .85,
                    color: Colors.green,
                  ),
                ),
              ),
              Positioned(
                top: height * .45 + 20,
                child: SizedBox(
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.loop)),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.arrow_left)),
                      StreamBuilder<PlayerState>(
                          stream: _player.playerStateStream,
                          builder: (context, snapshot) {
                            var playerState = snapshot.data;
                            var processingState = playerState?.processingState;
                            var playing = playerState?.playing;
                            if (playing != true) {
                              return IconButton(
                                  onPressed: () {
                                    _player.play();
                                  },
                                  icon: Icon(Icons.play_arrow));
                            } else if (processingState !=
                                ProcessingState.completed) {
                              return IconButton(
                                  onPressed: () {
                                    _player.pause();
                                  },
                                  icon: Icon(Icons.pause));
                            } else {
                              return IconButton(
                                  onPressed: () {
                                    _player.effectiveIndices!.first;
                                  },
                                  icon: Icon(Icons.replay));
                            }
                          }),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.arrow_right)),
                      IconButton(onPressed: () {}, icon: Icon(Icons.shuffle)),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: height * .45 + 80,
                right: width * .075,
                child: Container(
                  color: Colors.blueGrey,
                  height: height * .5,
                  width: width * .85,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: playlist.length,
                      itemBuilder: (_, index) => Container(
                              child: ListTile(
                            leading: Icon(Icons.play_arrow),
                            title: Text(
                              playlist[index],
                              maxLines: 1,
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("artist name"),
                                Text("album"),
                              ],
                            ),
                            trailing: Icon(Icons.menu),
                          ))),
                ),
              ),
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
