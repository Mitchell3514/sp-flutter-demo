import 'package:whisper_kit/whisper_kit.dart';

class TranscriptionExample {
  Future<String> transcribeAudioFile(String audioPath) async {
    // Create a Whisper instance with your preferred model
    final Whisper whisper = Whisper(
      model: WhisperModel.base,
      // Optional: custom download host (defaults to HuggingFace)
      downloadHost: 'https://huggingface.co/ggerganov/whisper.cpp/resolve/main',
    );

    // Create a transcription request
    final TranscribeRequest request = TranscribeRequest(
      audio: audioPath,
      language:
          'auto', // 'auto' for detection, or specify: 'en', 'es', 'fr', etc.
    );

    try {
      final WhisperTranscribeResponse result = await whisper.transcribe(
        transcribeRequest: request,
      );
      print('Transcription: ${result.text}');

      // Access segments if available
      if (result.segments != null) {
        for (final segment in result.segments!) {
          print('[${segment.fromTs} - ${segment.toTs}]: ${segment.text}');
        }
      }

      return result.text;
    } catch (e) {
      print('Error during transcription: $e');
      return "Error during transcription";
    }
  }
}
