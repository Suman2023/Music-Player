import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/providers/local_files_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localFiles = ref.watch(filesLocatorProvider);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: Center(
            child: IconButton(
                onPressed: () => Navigator.pushNamed(context, "allmusic"),
                icon: const FaIcon(FontAwesomeIcons.chevronLeft)),
          ),
          title: const Center(child: Text("Settings")),
          actions: [
            Center(
              child: IconButton(
                  onPressed: () => Navigator.pushNamed(context, "home"),
                  icon: const FaIcon(FontAwesomeIcons.chevronRight)),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Text(
                        "Currently Selected: " + localFiles.directoryPath)),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  String? picked = await localFiles.pickFolder();
                  if (picked != null) {
                    Navigator.pushNamed(context, '/');
                  }
                },
                child: const Text("Select Dir")),
          ],
        ));
  }
}
