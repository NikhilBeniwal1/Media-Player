import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioPlayer extends StatefulWidget {
  const MyAudioPlayer({super.key});

  @override
  State<MyAudioPlayer> createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer> {
  String audioUrl = "https://firebasestorage.googleapis.com/v0/b/my-first-project-66ff6.appspot.com/o/music%2Fjta%20jti%20da%20crush.m4a?alt=media&token=a120708d-50fb-4a7f-b23e-c086478457bf";
bool? musicPlaying ;
  AudioPlayer? player;
  Duration currPosValue = Duration.zero;
  Duration? totalPosValue = Duration.zero;
  Duration bufferedPosValue = Duration.zero;

  @override
  void initState() {
    super.initState();

    setUpMyAudioPlayer();
    if(player!.playing){
      musicPlaying = true;
    } else {musicPlaying = false; }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// music play or pause gif
              musicPlayGif(),

             /// Progress bar for audio player
              progressBar(),
              /// Audio player controllers
              audioControllers(),
            ],
          ),
        ),
      ),
    );
  }
  /// Audio player progress bar
  Widget progressBar(){
    return  ProgressBar(
      thumbColor: Colors.amber,
      thumbGlowColor: Colors.amber.withOpacity(0.1),
      progress: currPosValue,
      total: totalPosValue!,
      buffered: bufferedPosValue,
      onSeek: (newSeekValue){
        player!.seek(newSeekValue);
        setState(() {

        });
      },
      progressBarColor: Colors.amber,
      bufferedBarColor: Colors.grey,
      baseBarColor: Colors.black.withOpacity(0.5),
    );
  }


  /// Audio player controllers
  Widget audioControllers(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: (){

          },
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle
            ),
            child: Center(
              child: Icon(Icons.skip_previous),
            ),
          ),
        ),
        InkWell(
          onTap: (){
            if(player!.playing){
              musicPlaying = false ;
              player!.pause();
            } else {
              musicPlaying = true ;
              player!.play();
            }
            setState(() {

            });
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle
            ),
            child: Center(
              child: player!.playing ? Icon(Icons.pause) : Icon(Icons.play_arrow),
            ),
          ),
        ),
        InkWell(
          onTap: (){

          },
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle
            ),
            child: Center(
              child: Icon(Icons.skip_next),
            ),
          ),
        ),
      ],
    );
  }

/// audio player set up
  void setUpMyAudioPlayer() async{
    player = AudioPlayer();
    totalPosValue = await player!.setUrl(audioUrl);
    player!.play();

    player!.positionStream.listen((event) {
      currPosValue = event;
      setState(() {

      });
    });

    /// audio playee buffered position
    player!.bufferedPositionStream.listen((event) {
      bufferedPosValue = event;
      setState(() {

      });
    });
  }

  Widget musicPlayGif (){
    return Card(
      margin: EdgeInsets.all(100),
      child: musicPlaying! ?
      Image.network("https://pen.kcak11.com/music-player/assets/images/sound-effect.gif",height: 200,width: 300,)
     : Image.network("https://media.giphy.com/avatars/mediaresidents/FskdPYum0rus.png",height: 200,width: 300,)

    );
  }



}

