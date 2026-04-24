import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'record.dart' as record;
import 'play.dart' as play;
import 'whisper.dart' as whisper;

Future<String> get _audioPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

final audioFileName = 'flutter_whisper_demo.wav';
Future<String> get _audioFilePath async {
  return _audioPath.then((path) => '$path/$audioFileName');
}

final transcription = whisper.TranscriptionExample();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  record.initializeRecorder();
  print("done initializing recorder!");
  play.initializeAudio();
  print("done initializing audio!");

  final String audioFilePath = await _audioFilePath;

  runApp(MyApp(audioFilePath: audioFilePath));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.audioFilePath});

  final String audioFilePath;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Whisper Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: MyHomePage(
        title: "Flutter Whisper Demo",
        audioFilePath: audioFilePath,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.audioFilePath,
  });

  final String title;
  final String audioFilePath;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum Livecycle { uninitialized, recording, transcribing, playback, finished }

class _MyHomePageState extends State<MyHomePage> {
  Livecycle status = Livecycle.uninitialized;
  String transcriptionResult = "";

  void _handleRecord(record.Status update) {
    switch (update) {
      case record.Status.started:
        if (![Livecycle.uninitialized, Livecycle.finished].contains(status)) {
          print("Call to start recording whilst status: $status");
          return;
        }

        setState(() {
          status = Livecycle.recording;
        });
      case record.Status.stopped:
        if (status != Livecycle.recording) {
          print("Call to stop recording whilst status: $status");
          return;
        }

        setState(() {
          status = Livecycle.transcribing;
        });

        transcription
            .transcribeAudioFile(widget.audioFilePath)
            .then(
              (text) => {
                setState(() {
                  transcriptionResult = text;
                  status = Livecycle.finished;
                }),
              },
            );
    }
  }

  void _handlePlay(play.Status update) {
    switch (update) {
      case play.Status.started:
        if (status != Livecycle.finished) {
          print("Call to start playback whilst status: $status");
          return;
        }
        setState(() {
          status = Livecycle.playback;
        });
        break;
      case play.Status.stopped:
        if (status != Livecycle.playback) {
          print(
            "Status update that playback has completed whilst status: $status",
          );
          return;
        }
        setState(() {
          status = Livecycle.finished;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Spacer(flex: 4),
            if (![Livecycle.transcribing, Livecycle.playback].contains(status))
              record.RecordButton(
                audioFilePath: widget.audioFilePath,
                onStateChanged: _handleRecord,
              ),
            if (status == Livecycle.finished)
              play.PlayButton(
                audioFilePath: widget.audioFilePath,
                onStateChanged: _handlePlay,
              ),
            if (![
              Livecycle.uninitialized,
              Livecycle.recording,
            ].contains(status)) ...[
              Spacer(flex: 1),
              Text(
                "Transcription:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: kDefaultFontSize + 2.0,
                ),
              ),
              if (status == Livecycle.transcribing)
                Text("Transcription loading...")
              else
                Text(transcriptionResult),
            ],
            Spacer(flex: 4),
          ],
        ),
      ),
      // persistentFooterButtons: [record.RecordButton()],
    );
  }
}
