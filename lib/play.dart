import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

void initializeAudio() async {
  await SoLoud.instance.init();
}

enum Status { started, stopped }

class PlayButton extends StatelessWidget {
  const PlayButton({
    super.key,
    required this.audioFilePath,
    required this.onStateChanged,
  });

  final String audioFilePath;
  final void Function(Status) onStateChanged;

  void _handlePlay() async {
    final sound = await SoLoud.instance.loadFile(audioFilePath);
    SoLoud.instance.play(sound);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: Key("play"),
      onPressed: _handlePlay,
      tooltip: "Play",
      icon: Icon(Icons.play_arrow),
    );
  }
}
