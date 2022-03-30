import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/locator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/utils/routes.dart';

void main() async {
  setUp();
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
  @override
  void initState() {
    // TODO: implement initState
    box.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: AllRoutes.generateRutes,
      initialRoute: '/',
      // home: Testing(),
    );
  }
}
