import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/providers/widget_animations_controller.dart';

class TestMyWidget extends StatefulWidget {
  TestMyWidget({Key? key}) : super(key: key);

  @override
  _TestMyWidgetState createState() => _TestMyWidgetState();
}

class _TestMyWidgetState extends State<TestMyWidget>
    with TickerProviderStateMixin {
  late AnimationController _playPauseController;
  @override
  void initState() {
    super.initState();
    _playPauseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text("Widget Test Screen")),
        body: Center(child: Consumer(builder: (context, ref, child) {
          final _isPlayeing = ref.watch(isPlayingStateProvider.state);
          return IconButton(
            onPressed: () {
              print("pressed");
              _isPlayeing.state
                  ? {
                      _playPauseController.forward(),
                      _isPlayeing.state = !_isPlayeing.state,
                      print("Hello"),
                    }
                  : {
                      _playPauseController.reverse(),
                      _isPlayeing.state = !_isPlayeing.state,
                      print("hi"),
                    };
            },
            icon: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: _playPauseController,
              size: 24,
              color: Colors.blue,
            ),
          );
        })),
      ),
    );
  }

  @override
  void dispose() {
    _playPauseController.dispose();
    super.dispose();
  }
}
