import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/color_pallete/all_colors.dart';
import 'package:music_player/locator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/services/background_service.dart';
import 'package:music_player/services/local_file_service.dart';
import 'package:music_player/utils/routes.dart';

void main() async {
  setUp();
  await AudioService.init(
    builder: () => BackgroundAudioController(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
      androidNotificationChannelName: 'Music playback',
    ),
  );
  await Hive.initFlutter();
  await Hive.openBox("musicplayerdata");
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Box box = Hive.box("musicplayerdata");
  final _fileLocator = locator<LocalFileService>();
  @override
  void initState() {
    // box.clear();
    if (box.get("directory") == null || box.get("directory") == "") {
      box.put("currentFiles", <String>[]);
      _fileLocator.pickFolder();
    } else if (box.get("directory") != "") {
      _fileLocator.getMusicFiles();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _colorsScheme = locator<AppColorsScheme>();
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: _colorsScheme.scaffoldColor,
          appBarTheme: AppBarTheme(backgroundColor: _colorsScheme.appBarColor),
          popupMenuTheme: PopupMenuThemeData(
              color: _colorsScheme.scaffoldColor,
              textStyle: TextStyle(color: _colorsScheme.searchColor))),

      onGenerateRoute: AllRoutes.generateRutes,
      initialRoute: 'home',
      // home: Testing(),
    );
  }
}
