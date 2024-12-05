import 'package:custom_vimeo_player/custom_vimeo_player.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CustomVimeoPlayer is initialized correctly', (tester) async {
    const videoId = '123456';

    const player = CustomVimeoPlayer(
      videoId: videoId,
      autoPlay: true,
      loop: true,
      muted: true,
      showTitle: true,
      showByline: true,
      controls: true,
      dnt: false,
    );

    expect(player.videoId, videoId);
    expect(player.autoPlay, true);
    expect(player.loop, true);
    expect(player.muted, true);
    expect(player.showTitle, true);
    expect(player.showByline, true);
    expect(player.controls, true);
    expect(player.dnt, false);
  });
}
