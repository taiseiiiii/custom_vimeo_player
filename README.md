# custom_vimeo_player

<a href="https://flutter.dev/"><img src="https://img.shields.io/badge/-Flutter-02569B.svg?logo=flutter" alt="Flutter Website" /></a>
<a href="https://dart.dev"><img src="https://img.shields.io/badge/-Dart-%230175C2.svg?logo=dart
" alt="Dart Website"/></a>
<a href="https://developer.android.com"><img src="https://img.shields.io/badge/-android-ffffff.svg?logo=android"/></a>
<a href="https://developer.apple.com/ios/"><img src="https://img.shields.io/badge/-ios-%23000000.svg?logo=apple
"/>
</a>

A Flutter package for embedding Vimeo videos with customizable playback controls, events handling.

## Features

- Simple vimeo video integration
- Customizable player controls (autoPlay, loop, muted, etc.)
- Event handling (play, pause, end, etc.)
- Native iOS/Android support via InAppWebView
- MIT licensed

# Preview

![custom_vimeo_player](https://github.com/user-attachments/assets/d6f696c5-8057-4df7-ae5b-e9b4d8c74574)

## Usage

```dart
import 'package:custom_vimeo_player/custom_vimeo_player.dart';

CustomVimeoPlayer(
  videoId: '<your_vimeo_id>',
),
```

### Required parameters

---

| Parameter      | Description                             |
| -------------- | --------------------------------------- |
| String vimeoId | The ID of the Vimeo video to be played. |

### Optional parameters

---

| Parameter              | Description                                                |
| ---------------------- | ---------------------------------------------------------- |
| bool autoPlay          | automatically starts playback when loaded (default: false) |
| bool loop              | loops video when it ends (default: false)                  |
| bool muted             | starts video muted (default: false)                        |
| bool showTitle         | shows video title (default: false)                         |
| bool showByline        | shows video byline (default: false)                        |
| bool controls          | shows playback controls (default: true)                    |
| bool dnt               | prevents tracking (Do Not Track) (default: true)           |
| VoidCallback? onReady  | called when video is ready play                            |
| VoidCallback? onPlay   | called when video starts playing                           |
| VoidCallback? onPause  | called when video is paused                                |
| VoidCallback? onEnd    | called when video ends                                     |
| VoidCallback? onSeeked | called when video position is changed                      |

### Dependencies

- [flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview): ^6.1.5
