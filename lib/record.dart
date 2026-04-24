import 'package:flutter/material.dart';
import 'package:record/record.dart';

/* -------------------------------------------------------------------------- */
/*                                  Recorder                                  */
/* -------------------------------------------------------------------------- */

var permString = "uninitialized";

final recorder = AudioRecorder();

final recordConfig = RecordConfig(
  encoder: AudioEncoder.wav,
  sampleRate: 16000,
  numChannels: 1,
  autoGain: true,
  echoCancel: true,
  noiseSuppress: true,
);

void initializeRecorder() async {
  if (await recorder.hasPermission()) {
    permString = "Microphone permission granted!";
  } else {
    permString = "No permission to use the microphone :(";
  }
}

/* -------------------------------------------------------------------------- */
/*                                   Widget                                   */
/* -------------------------------------------------------------------------- */

enum Status { started, stopped }

class RecordButton extends StatefulWidget {
  const RecordButton({
    super.key,
    required this.audioFilePath,
    required this.onStateChanged,
  });

  final String audioFilePath;
  final void Function(Status) onStateChanged;

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  Status status = Status.stopped;

  void _handlePress() async {
    switch (status) {
      case Status.started:
        await recorder.stop();

        setState(() {
          status = Status.stopped;
        });

        break;
      case Status.stopped:
        await recorder.start(recordConfig, path: widget.audioFilePath);

        setState(() {
          status = Status.started;
        });

        break;
    }

    widget.onStateChanged(status);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          status == Status.started ? "Recording..." : "Record to transcribe",
        ),
        IconButton(
          key: Key("record"),
          onPressed: _handlePress,
          tooltip: 'Record',
          color: status == Status.started
              ? Color.fromRGBO(120, 10, 20, 1.0)
              : Color.fromRGBO(100, 100, 100, 1.0),
          icon: Icon(
            status == Status.started ? Icons.square : Icons.circle,
            color: Color.fromRGBO(200, 20, 40, 1.0),
          ),
        ),
      ],
    );
  }
}
