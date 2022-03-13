// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class MusicController extends StatelessWidget {
  AudioPlayer player;
  MusicController({required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150), color: Colors.blueAccent),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              height: 300 / 2,
              width: 300 / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150),
                color: Colors.blueGrey,
              )),
          Container(
            height: 150 / 2,
            width: 150 / 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              color: Colors.green,
            ),
            // child:
          ),
          Positioned(
            top: 30,
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(Icons.circle_rounded),
            ),
          ),
          Positioned(
            left: 30,
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(Icons.circle_rounded),
            ),
          ),
          Positioned(
            right: 30,
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(Icons.circle_rounded),
            ),
          ),
          Positioned(
            bottom: 30,
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(Icons.circle_rounded),
            ),
          ),
          SleekCircularSlider(
            initialValue: 60,
            min: 0,
            max: 100,
            appearance: CircularSliderAppearance(
              customWidths: CustomSliderWidths(
                handlerSize: 5,
                trackWidth: 0,
                progressBarWidth: 5,
                shadowWidth: 0,
              ),
              customColors: CustomSliderColors(
                  trackColor: Colors.transparent, dotColor: Colors.yellow),
              size: 300,
              startAngle: 0,
              angleRange: 360,
            ),
            innerWidget: (hello) => Container(),
          ),
          StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var playerState = snapshot.data;
                  var processingState = playerState!.processingState;
                  bool playing = playerState.playing;
                  if (playing != true) {
                    return IconButton(
                        onPressed: () {
                          player.play();
                        },
                        icon: Icon(Icons.play_arrow));
                  } else if (processingState != ProcessingState.completed) {
                    return IconButton(
                        onPressed: () {
                          player.pause();
                        },
                        icon: Icon(Icons.pause));
                  } else {
                    return IconButton(
                        onPressed: () {
                          player.effectiveIndices!.first;
                        },
                        icon: Icon(Icons.replay));
                  }
                }
                return Icon(Icons.replay);
              }),
        ],
      ),
    );
  }
}
