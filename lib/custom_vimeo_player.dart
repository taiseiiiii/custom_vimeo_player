library custom_vimeo_player;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CustomVimeoPlayer extends StatelessWidget {
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

  final String videoId;
  final bool autoPlay;
  final bool loop;
  final bool muted;
  final bool showTitle;
  final bool showByline;
  final bool controls;
  final bool dnt;
  final VoidCallback? onReady;
  final VoidCallback? onPlay;
  final VoidCallback? onPause;
  final VoidCallback? onEnd;
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
