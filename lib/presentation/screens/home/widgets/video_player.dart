import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({Key? key, required this.videoId}) : super(key: key);
  final String videoId;

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: YoutubePlayerController(
        initialVideoId: videoId.toString(),
        flags: YoutubePlayerFlags(
          autoPlay: true,
          // mute: true,
        ),
      ),
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.blueAccent,
      progressColors: ProgressBarColors(
        playedColor: Colors.blueAccent,
        handleColor: Colors.blueAccent,
      ),
      onReady: () {
        print('Player is ready.');
      },
    );
  }
}
