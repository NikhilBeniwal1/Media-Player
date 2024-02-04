import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioPlayer extends StatefulWidget {
  const MyAudioPlayer({super.key});

  @override
  State<MyAudioPlayer> createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer> {
  String audioUrl = "https://rr5---sn-a5mlrnek.googlevideo.com/videoplayback?expire=1707046658&ei=oiK_ZfD4O9uQvcAPoam-yAE&ip=158.62.43.63&id=o-AEG_nkUd2GaVNccqYqh8wtJI6K-0ENexk6TA1erHz-Pi&itag=599&source=youtube&requiressl=yes&xpc=EgVo2aDSNQ%3D%3D&vprv=1&svpuc=1&mime=audio%2Fmp4&gir=yes&clen=14243997&dur=3701.446&lmt=1698766895809876&keepalive=yes&fexp=24007246&c=ANDROID&txp=4532434&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cxpc%2Cvprv%2Csvpuc%2Cmime%2Cgir%2Cclen%2Cdur%2Clmt&sig=AJfQdSswRAIgezQcslvy1jxnw8kgVQqUCuKHgzNI_1ebG29trBz-RtcCIHFrF5JVXdeQ1-tOB46OlAyKJQFmd6ep0f49NIIx08NG&rm=sn-bavcx-hoaey76,sn-bavcx-hoaek7k&req_id=74fd227f829ca3ee&ipbypass=yes&redirect_counter=3&cm2rm=sn-hoaz7z&cms_redirect=yes&cmsv=e&mh=Bk&mip=150.107.9.13&mm=34&mn=sn-a5mlrnek&ms=ltu&mt=1707024783&mv=D&mvi=5&pl=0&lsparams=ipbypass,mh,mip,mm,mn,ms,mv,mvi,pl&lsig=AAO5W4owRQIhAOOz-3d33m4voOCJ6icFdUu-K-HvrldiHSpCphIDkuJbAiAf8zNNv5eVrJL-z-9LxOgxOtheePXX9dgmSSfv8r2Ozw%3D%3D";
      // "https://raag.fm/files/mp3/128/Hindi-Singles/23303/Kesariya%20(Brahmastra)%20-%20(Raag.Fm).mp3";
  AudioPlayer? player;
  Duration currPosValue = Duration.zero;
  Duration? totalPosValue = Duration.zero;
  Duration bufferedPosValue = Duration.zero;

  @override
  void initState() {
    super.initState();
    setUpMyAudioPlayer();
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
              player!.pause();
            } else {
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
      child: Image.network("https://pen.kcak11.com/music-player/assets/images/sound-effect.gif")
    );
  }

}

