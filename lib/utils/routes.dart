import 'package:flutter/material.dart';
import 'package:music_player/views/all_songs_view/all_music_screen.dart';
import 'package:music_player/views/home_view/home_screen.dart';
import 'package:music_player/views/settings_view/settings_screen.dart';

class AllRoutes {
  static Route<dynamic> generateRutes(RouteSettings setting) {
    switch (setting.name) {
      case 'home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case 'allmusic':
        return MaterialPageRoute(builder: (_) => const AllMusicScreen());
      case 'settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
