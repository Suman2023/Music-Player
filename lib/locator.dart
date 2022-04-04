import 'package:get_it/get_it.dart';
import 'package:music_player/color_pallete/all_colors.dart';
import 'package:music_player/services/local_file_service.dart';

import 'services/audio_player_service.dart';

final locator = GetIt.instance;

void setUp() {
  locator.registerLazySingleton<AudioPlayerService>(() => AudioPlayerService());
  locator.registerLazySingleton<LocalFileService>(() => LocalFileService());
  locator.registerLazySingleton<AppColorsScheme>(() => AppColorsScheme());
}
