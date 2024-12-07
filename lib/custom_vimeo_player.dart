/// A Flutter package for embedding Vimeo videos with customizable playback controls
/// and event handling capabilities.
library custom_vimeo_player;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// A widget that embeds a Vimeo video player with customizable controls and event callbacks.
///
/// This widget uses InAppWebView to embed Vimeo videos and provides various customization
/// options and event callbacks for video playback control.
///
/// Example usage:
/// ```dart
/// CustomVimeoPlayer(
///   videoId: '<your_video_id>',
///   autoPlay: true,
///   onPlay: () => print('Video started playing'),
/// )
/// ```
class CustomVimeoPlayer extends StatelessWidget {
  /// Creates a custom Vimeo player widget.
  ///
  /// The [videoId] parameter is required and must not be null.
  /// Other parameters are optional and provide various customization options.
  const CustomVimeoPlayer({
    super.key,
    required this.videoId,
    this.autoPlay = false,
    this.loop = false,
    this.muted = false,
    this.showTitle = false,
    this.showByline = false,
    this.controls = true,
    this.dnt = true,
    this.onReady,
    this.onPlay,
    this.onPause,
    this.onEnd,
    this.onSeeked,
  });

  /// The ID of the Vimeo video to be played.
  final String videoId;

  /// Whether the video should start playing automatically when loaded.
  ///
  /// Defaults to `false`.
  final bool autoPlay;

  /// Whether the video should loop after it ends.
  ///
  /// Defaults to `false`.
  final bool loop;

  /// Whether the video should start muted.
  ///
  /// Defaults to `false`.
  final bool muted;

  /// Whether to show the video title.
  ///
  /// Defaults to `false`.
  final bool showTitle;

  /// Whether to show the video byline.
  ///
  /// Defaults to `false`.
  final bool showByline;

  /// Whether to show the video playback controls.
  ///
  /// Defaults to `true`.
  final bool controls;

  /// Whether to enable Do Not Track (DNT) mode.
  ///
  /// When enabled, the player won't track viewing information.
  /// Defaults to `true`.
  final bool dnt;

  /// Callback function called when the player is ready to play.
  final VoidCallback? onReady;

  /// Callback function called when the video starts playing.
  final VoidCallback? onPlay;

  /// Callback function called when the video is paused.
  final VoidCallback? onPause;

  /// Callback function called when the video playback ends.
  final VoidCallback? onEnd;

  /// Callback function called when the video position is changed.
  final VoidCallback? onSeeked;

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialSettings: InAppWebViewSettings(
        mediaPlaybackRequiresUserGesture: false,
        allowsInlineMediaPlayback: true,
        useHybridComposition: true,
      ),
      initialUrlRequest: URLRequest(url: WebUri(_videoPage())),
      shouldOverrideUrlLoading: _shouldOverrideUrlLoading,
      onConsoleMessage: (controller, consoleMessage) {
        final message = consoleMessage.message;
        if (message.startsWith('vimeo:')) {
          _handleVimeoEvent(message.substring(6));
        }
      },
    );
  }

  /// Generates the HTML page containing the Vimeo player.
  String _videoPage() {
    final html = '''
     <html>
       <head>
         <style>
           body {
             margin: 0;
             padding: 0;
           }
           .video-container {
             position: relative;
             width: 100%;
             height: 100vh;
           }
           iframe {
             position: absolute;
             top: 0;
             left: 0;
             width: 100%;
             height: 100%;
           }
         </style>
         <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
         <meta http-equiv="Content-Security-Policy" content="default-src * gap:; script-src * 'unsafe-inline' 'unsafe-eval'; connect-src *; img-src * data: blob: android-webview-video-poster:; style-src * 'unsafe-inline';">
         <script src="https://player.vimeo.com/api/player.js"></script>
       </head>
       <body>
         <div class="video-container">
           <iframe 
             id="player"
             src="https://player.vimeo.com/video/$videoId?autoplay=$autoPlay&loop=$loop&muted=$muted&title=$showTitle&byline=$showByline&controls=$controls&dnt=$dnt"
             frameborder="0"
             allow="autoplay; fullscreen; picture-in-picture"
             allowfullscreen
             webkitallowfullscreen 
             mozallowfullscreen>
           </iframe>
         </div>
         <script>
           const player = new Vimeo.Player('player');
           
           player.ready().then(() => {
             console.log('vimeo:ready');
           });
           
           player.on('play', () => {
             console.log('vimeo:play');
           });
           
           player.on('pause', () => {
             console.log('vimeo:pause');
           });
           
           player.on('ended', () => {
             console.log('vimeo:ended');
           });
           
           player.on('seeked', () => {
             console.log('vimeo:seeked');
           });
         </script>
       </body>
     </html>
   ''';
    return 'data:text/html;base64,${base64Encode(const Utf8Encoder().convert(html))}';
  }

  /// Handles Vimeo player events received from the webview.
  void _handleVimeoEvent(String event) {
    if (event == 'ready') {
      onReady?.call();
    } else if (event == 'play') {
      onPlay?.call();
    } else if (event == 'pause') {
      onPause?.call();
    } else if (event == 'ended') {
      onEnd?.call();
    } else if (event == 'seeked') {
      onSeeked?.call();
    }
  }

  /// Handles URL loading requests in the webview.
  ///
  /// On iOS, allows loading of Vimeo player URLs and blocks other navigation.
  Future<NavigationActionPolicy?> _shouldOverrideUrlLoading(
    InAppWebViewController controller,
    NavigationAction navigationAction,
  ) async {
    final url = navigationAction.request.url?.toString();
    if (Platform.isIOS) {
      if (url?.startsWith('https://player.vimeo.com/video/$videoId') == true ||
          url == _videoPage()) {
        return NavigationActionPolicy.ALLOW;
      }
    }
    return NavigationActionPolicy.CANCEL;
  }
}
