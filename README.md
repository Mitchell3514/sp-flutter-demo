# sp_test

A demo application written with [flutter] showcasing speech-to-text with the [whisper_kit] package for Android.

The recording and playback functionality has been verified to work on Linux as well. Note that gcc has been pinned to version 11 in the linux `CMakeLists.txt`. Other platforms have not been tested.

## Requirements

- [Flutter]
- [Android sdk][android_sdk] (you will have to accept all licenses)
- An Android device with usb debugging enabled or an Android emulator.

## Getting started

1. Clone this repository and open in VS Code or a shell.
1. Retrieve Flutter dependencies.
   ```sh
   flutter pub get
   ```
1. Run Flutter doctor to ensure that the Android toolchain is working. If not, fix the listed issues.
   ```sh
   flutter doctor
   ```
1. If you are using VS Code with the Flutter extension, then you can start the application through the Run and Debug screen. First pick "Dart & Flutter", then choose your Android device from the list.

   You can also find your device and start the application through the command line:

   ```sh
     flutter devices -d ""
     flutter run -d "<device name>"
   ```

## Showcase
https://github.com/user-attachments/assets/8cf456e2-25e3-4ea3-be28-9c93c1d796bb

[android_sdk]: https://developer.android.com/tools/releases/platform-tools
[flutter]: https://docs.flutter.dev/
[whisper_kit]: https://pub.dev/packages/whisper_kit
