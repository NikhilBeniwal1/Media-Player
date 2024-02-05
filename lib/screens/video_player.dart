import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:mediaplayer/model/media_data.dart';
import 'package:video_player/video_player.dart';

import '../model/media_model.dart';

class MyVideoPlayer extends StatefulWidget {

  int index;
  MyVideoPlayer({this.index = 0});

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  double opacity = 1.0;
  bool isVisble = true;
  // var videos = VideoData.videos;
  VideoPlayerController? mVideoController;
  Future<void>? initialized;
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    var url = mediaData.categories![0].videos![widget.index].sources!; // videos[widget.index]["sources"];
    mVideoController = VideoPlayerController.networkUrl(Uri.parse(url!));
    initialized = mVideoController!.initialize();
    mVideoController!.addListener(() {setState(() {
    });});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("VideoPlayer"),centerTitle: true,),

      body: SingleChildScrollView(

        child: Column(
          children: [
            /// video player
            videoPlayer(),
        
            /// video info
            videoInfo(),
            /// list of videos
            listOfVideos(),
           /// Gride of videos
            // gridOfVideos(),
          ],
        ),
      ),

    );

  }

  Widget videoPlayer (){
    return FutureBuilder(
        future: initialized,
        builder: (_,snapshot){
          if(snapshot.connectionState== ConnectionState.waiting){
            return Container(height:300,width: double.infinity, child: Center(child: CircularProgressIndicator(),));
          } else if (snapshot.connectionState == ConnectionState.done)
          {return Container(
            width: double.maxFinite,
            height: 300,
            child: AspectRatio(
                aspectRatio: mVideoController!.value.aspectRatio,
                child: Stack(
                  children: [

                    VideoPlayer(mVideoController!),

                    /// pause play button for video
                    Center(
                      child: InkWell(
                        onTap: (){
                          if(mVideoController!.value.isPlaying ){
                            mVideoController!.pause();
                            isVisble = true;
                            opacity = 1.0;
                            setState(() {

                            });
                          } else { mVideoController!.play();
                          opacity = 0.0;
                          isVisble = false;
                          setState(() {

                          });
                          }

                          setState(() {

                          });
                        } ,
                        child: AnimatedOpacity(
                          opacity: opacity,
                          duration: isVisble ? Duration(seconds: 0) : Duration(seconds: 3),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle
                            ),
                            child: Center(
                              child: mVideoController!.value.isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                            ),
                          ),
                        ),
                      ),
                    ),



                   /// invisble container for pause and play of video.
                    Positioned(
                        bottom: 30,
                        child: InkWell(
                      onTap: (){
                      if(mVideoController!.value.isPlaying){
                        mVideoController!.pause();
                        isVisble = true;
                        opacity = 1.0;
setState(() {

});
                      }
                      else if(mVideoController!.value.isPlaying == false){
                        mVideoController!.play();
                        opacity = 0.0;
                        isVisble = false;
                        }
                      },
                      child: Container(
                        height: 200,
                        width: double.maxFinite,

                      ),
                    )),

                    /// slider of video
                    Positioned(
                      bottom: 5,
                      width: 500,
                      child: AnimatedOpacity(
                       duration: isVisble == false ? Duration(seconds: 3) : Duration(seconds: 0),
                        opacity: opacity,
                        child:   Column(
                          children: [

                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(

                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [

                                  Text(getCurrentTime(),style: TextStyle(color: Colors.white),),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.74,),
                                  Text(getTotalDuration(),style: TextStyle(color: Colors.white),),
                                ],
                              ),
                            ),
                            Slider(

                                value: mVideoController!.value.position.inSeconds.toDouble(),
                                activeColor: Colors.white,
                                inactiveColor: Colors.black,
                                min: 0,
                                max: mVideoController!.value.duration.inSeconds.toDouble(),

                                onChanged: (seekTo){
                                  if(isVisble){
                                      mVideoController!.seekTo(
                                          Duration(seconds: seekTo.toInt()));
                                      setState(() {});
                                    }
                                  }
                            ),
                          ],
                        ) ,
                      ),
                    ),




                    
                  ],
                )),
          );}

          return Container();
        });
  }

  Widget gridOfVideos(){
    return Expanded(
      child: GridView.builder(
        itemCount:    mediaData.categories![0].videos!.length  ,//videos.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) => GridTile(child: Column(
          children: [
            /// Movie thumb
            InkWell(
                onTap: (){
                  mVideoController!.pause();
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                   return MyVideoPlayer(index: index,);
                 },));
                },
                child: Image.network('https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/${mediaData.categories![0].videos![widget.index].thumb!/*videos[index]["thumb"]*/}',height: 200,width: 200,fit: BoxFit.scaleDown,)),

            /// Movie name
            Text(mediaData.categories![0].videos![6].title!/*videos[index]["title"]*/),
          ],
          )),
      ),
    );
  }

  Widget listOfVideos(){
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount:  mediaData.categories![0].videos!.length,  // videos.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              mVideoController!.pause();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return MyVideoPlayer(index: index,);
              },));
            },
            child: SizedBox(height: 150,child: Row(children: [
              Image.network('https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/${mediaData.categories![0].videos![index].thumb/*videos[index]["thumb"]*/}',height: 200,width: 200,fit: BoxFit.scaleDown,),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text(mediaData.categories![0].videos![index].title!/*videos[index]["title"]*/,style: TextStyle(fontSize: 18),softWrap: true,),
                    Text(mediaData.categories![0].videos![index].subtitle!/*videos[index]["subtitle"]*/,style: TextStyle(fontSize: 14),softWrap: true,),
                   // Text(videos[index]["description"],style: TextStyle(fontSize: 15),),

                  ],
                ),
              ),
            ],)),
          );
        },);
  }

  Widget videoInfo(){
    return ListTile(
      title: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(mediaData.categories![0].videos![widget.index].title!/*videos[widget.index]["title"]*/,style: TextStyle(fontSize: 25),),
          Text(mediaData.categories![0].videos![widget.index].subtitle!/*videos[widget.index]["subtitle"]*/,style: TextStyle(fontSize: 20),),


        ],
      ),
      subtitle: Text(mediaData.categories![0].videos![widget.index].description!/*videos[widget.index]["description"],*/),

    );
  }


  String getCurrentTime(){


    var min = mVideoController!.value.position.inSeconds.toInt()~/60;
    var sec = mVideoController!.value.position.inSeconds.toInt()%60;

    return "$min : $sec";

  }

  String getTotalDuration(){


    var min = mVideoController!.value.duration.inSeconds.toInt()~/60;
    var sec = mVideoController!.value.duration.inSeconds.toInt()%60;
if(sec== 0 ){
  sec = sec + 10; return "$min : $sec";
}else if( sec == 1){sec = sec + 9; return "$min : $sec";}
else if( sec == 2){sec = sec + 8; return "$min : $sec";}
else if( sec == 3){sec = sec + 7; return "$min : $sec";}
else if( sec == 4){sec = sec + 6; return "$min : $sec";}
else if( sec == 5){sec = sec + 5; return "$min : $sec";}
else{return "$min : $sec";}

  }

}




