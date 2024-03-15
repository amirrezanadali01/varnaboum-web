import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

class SamplePlayer extends StatefulWidget {
  SamplePlayer({required this.url});

  final String url;
  @override
  _SamplePlayerState createState() => _SamplePlayerState();
}

class _SamplePlayerState extends State<SamplePlayer> {
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    print(widget.url);
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.url),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
    print(widget.url);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF149694),
      ),
      body: Center(
        child: Container(
          height: 45.h,
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: FlickVideoPlayer(flickManager: flickManager),
          ),
        ),
      ),
    );
  }
}

class SampleVideoRetryProfile extends StatefulWidget {
  SampleVideoRetryProfile({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  State<SampleVideoRetryProfile> createState() =>
      _SampleVideoRetryProfileState();
}

class _SampleVideoRetryProfileState extends State<SampleVideoRetryProfile> {
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    print(widget.url);
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.url),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 45.h,
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: FlickVideoPlayer(flickManager: flickManager),
        ),
      ),
    );
  }
}
