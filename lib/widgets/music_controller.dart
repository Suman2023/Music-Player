// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';
import 'package:audio_session/audio_session.dart';
import 'dart:math';

class MusicController extends StatefulWidget {
  AudioPlayer player;
  MusicController({required this.player});

  @override
  State<MusicController> createState() => _MusicControllerState();
}

class _MusicControllerState extends State<MusicController> {
  @override
  Widget build(BuildContext context) {
    double volume = 0.0;
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
          StreamBuilder<Duration>(
              stream: widget.player.positionStream,
              builder: (context, snapshot) {
                double totalDuration = 100;
                double currentPosition = 0;
                try {
                  print(widget.player.icyMetadata!.info);
                  totalDuration =
                      widget.player.duration!.inMilliseconds.toDouble();
                  currentPosition = snapshot.data!.inMilliseconds.toDouble();
                } catch (e) {
                  totalDuration = 100;
                  currentPosition = 0;
                }

                return SleekCircularSlider(
                    initialValue: currentPosition,
                    min: 0.0,
                    max: totalDuration,
                    appearance: CircularSliderAppearance(
                      customWidths: CustomSliderWidths(
                        handlerSize: 5,
                        trackWidth: 0,
                        progressBarWidth: 5,
                        shadowWidth: 0,
                      ),
                      customColors: CustomSliderColors(
                          trackColor: Colors.transparent,
                          dotColor: Colors.yellow),
                      size: 300,
                      startAngle: 0,
                      angleRange: 360,
                    ),
                    innerWidget: (hello) => Container(),
                    onChangeEnd: (newPos) => widget.player
                        .seek(Duration(milliseconds: newPos.toInt())));
              }),
          StreamBuilder<double>(
              stream: widget.player.volumeStream,
              builder: (context, snapshot) {
                double minVol = 0;
                double maxVol = 1;
                double currVol = 0.2;
                try {
                  currVol = snapshot.data ?? 0.0;
                } catch (e) {
                  currVol = 0.2;
                }
                return SleekCircularSlider(
                  initialValue: widget.player.volume,
                  min: Duration.zero.inMilliseconds.toDouble(),
                  max: 1.001,
                  appearance: CircularSliderAppearance(
                    customWidths: CustomSliderWidths(
                      handlerSize: 0,
                      trackWidth: 0,
                      progressBarWidth: 5,
                      shadowWidth: 0,
                    ),
                    customColors: CustomSliderColors(
                        trackColor: Colors.transparent,
                        dotColor: Colors.yellow),
                    size: 150,
                    startAngle: 0,
                    angleRange: 360,
                  ),
                  innerWidget: (hello) => Container(),
                );
              }),
          StreamBuilder<PlayerState>(
              stream: widget.player.playerStateStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var playerState = snapshot.data;
                  var processingState = playerState!.processingState;
                  bool playing = playerState.playing;
                  if (playing != true) {
                    return IconButton(
                        onPressed: () {
                          widget.player.play();
                        },
                        icon: Icon(Icons.play_arrow));
                  } else if (processingState != ProcessingState.completed) {
                    return IconButton(
                        onPressed: () {
                          widget.player.pause();
                        },
                        icon: Icon(Icons.pause));
                  } else {
                    return IconButton(
                        onPressed: () {
                          widget.player.effectiveIndices!.first;
                        },
                        icon: Icon(Icons.replay));
                  }
                }
                return Icon(Icons.replay);
              }),
          Positioned(
            top: 10,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                  onPressed: () {
                    widget.player.setVolume(widget.player.volume < 0.9
                        ? widget.player.volume + 0.1
                        : 1);
                  },
                  icon: FaIcon(FontAwesomeIcons.plus)),
            ),
          ),
          Positioned(
            left: 10,
            child: Container(
                // height: 10,
                // width: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  onPressed: () {
                    print("next");
                    widget.player.hasPrevious
                        ? widget.player.seekToPrevious()
                        : null;
                  },
                  icon: FaIcon(FontAwesomeIcons.stepBackward),
                )),
          ),
          Positioned(
            right: 10,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  onPressed: () {
                    widget.player.hasNext ? widget.player.seekToNext() : null;
                  },
                  icon: FaIcon(FontAwesomeIcons.stepForward),
                )),
          ),
          Positioned(
            bottom: 10,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                  onPressed: () {
                    widget.player.setVolume(widget.player.volume > 0.1
                        ? widget.player.volume - 0.1
                        : 0);
                  },
                  icon: FaIcon(FontAwesomeIcons.minus)),
            ),
          ),
        ],
      ),
    );
  }
}
