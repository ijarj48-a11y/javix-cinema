import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class PlayerScreen extends StatefulWidget {
  final String title,url;
  const PlayerScreen({super.key,required this.title,required this.url});
  @override State<PlayerScreen> createState()=>_PlayerState();
}

class _PlayerState extends State<PlayerScreen>{
  late VideoPlayerController c;
  double speed=1;
  bool full=false;

  @override void initState(){
    super.initState();
    c=VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_){if(mounted){setState((){});c.play();}});
  }

  String time(Duration d){
    return '${d.inMinutes.remainder(60).toString().padLeft(2,'0')}:${d.inSeconds.remainder(60).toString().padLeft(2,'0')}';
  }

  void fs()async{
    full=!full;
    await SystemChrome.setPreferredOrientations(
      full?[DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]:
      [DeviceOrientation.portraitUp]);
    setState((){});
  }

  @override void dispose(){c.dispose();super.dispose();}

  @override Widget build(BuildContext x){
    if(!c.value.isInitialized)return const Scaffold(
      backgroundColor:Color(0xFF050A14),
      body:Center(child:CircularProgressIndicator()));
    return Scaffold(
      backgroundColor:const Color(0xFF050A14),
      appBar:full?null:AppBar(
        title:Text(widget.title),
        backgroundColor:const Color(0xFF050A14),
        foregroundColor:Colors.white),
      body:Column(children:[
        Expanded(child:Center(child:AspectRatio(
          aspectRatio:c.value.aspectRatio,child:VideoPlayer(c)))),
        VideoProgressIndicator(c,allowScrubbing:true,
          colors:const VideoProgressColors(
            playedColor:Colors.cyanAccent,
            bufferedColor:Colors.white38,
            backgroundColor:Colors.white12)),
        Padding(padding:const EdgeInsets.symmetric(horizontal:12),
          child:Row(children:[
            Text(time(c.value.position),style:const TextStyle(color:Colors.white70)),
            const Spacer(),
            Text(time(c.value.duration),style:const TextStyle(color:Colors.white70))])),
        Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[
          IconButton(onPressed:()=>c.setVolume(c.value.volume==0?1:0),
            icon:Icon(c.value.volume==0?Icons.volume_off:Icons.volume_up,color:Colors.white)),
          IconButton(onPressed:()async{
            final s=await showModalBottomSheet<double>(
              context:x,backgroundColor:const Color(0xFF111827),
              builder:(_)=>Column(mainAxisSize:MainAxisSize.min,
                children:[for(final v in [.5,.75,1,1.25,1.5,2])
                  ListTile(title:Text('${v}x',style:const TextStyle(color:Colors.white)),
                    onTap:()=>Navigator.pop(x,v))]));
            if(s!=null){await c.setPlaybackSpeed(s);setState((){speed=s;});}
          },icon:const Icon(Icons.speed,color:Colors.white)),
          IconButton(iconSize:52,onPressed:(){
            c.value.isPlaying?c.pause():c.play();setState((){});
          },icon:Icon(c.value.isPlaying?Icons.pause_circle:Icons.play_circle,
            color:Colors.cyanAccent)),
          IconButton(onPressed:fs,
            icon:Icon(full?Icons.fullscreen_exit:Icons.fullscreen,color:Colors.white)),
        ]),
        if(!full)Text('${speed}x',style:const TextStyle(color:Colors.white54)),
        const SizedBox(height:12)
      ]));
  }
}
