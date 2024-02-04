import 'package:flutter/material.dart';
import 'package:mediaplayer/screens/audioplayer.dart';
import 'package:mediaplayer/screens/video_player.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {


   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  MyAudioPlayer()// MyVideoPlayer(),
    );
  }
}
