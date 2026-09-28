import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class PlayerScreen extends StatefulWidget {
  final String title, url;
  const PlayerScreen({super.key, required this.title, required this.url});
  @override State<PlayerScreen> createState() => _PlayerState();
}

class _PlayerState extends State<PlayerScreen> {
  late VideoPlayerController c;
  bool full=false, controls=true;
  double speed=1;

  @override
  void initState() {
    super.initState();
    c=VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if(mounted){setState((){});c.play();}
      });
  }

  String time(Duration d) =>
      '${d.inMinutes.remainder(60).toString().padLeft(2,'0')}:${d.inSeconds.remainder(60).toString().padLeft(2,'0')}';

  void toggleControls()=>setState(()=>controls=!controls);

  Future<void> fs() async {
    full=!full;
    await SystemChrome.setPreferredOrientations(
      full?[DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]:
      [DeviceOrientation.portraitUp]);
    setState((){});
  }

  @override
  void dispose(){
    c.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    if(!c.value.isInitialized){
      return const Scaffold(
        backgroundColor:Color(0xFF050A14),
        body:Center(child:CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor:Colors.black,
      appBar:full||!controls?null:AppBar(
        title:Text(widget.title),
        backgroundColor:const Color(0xFF050A14),
        foregroundColor:Colors.white),
      body:GestureDetector(
        onTap:toggleControls,
        child:Stack(
          fit:StackFit.expand,
          children:[
            Center(
              child:FittedBox(
                fit:BoxFit.contain,
                child:SizedBox(
                  width:c.value.size.width,
                  height:c.value.size.height,
                  child:VideoPlayer(c),
                ),
              ),
            ),
            if(controls)
              Center(
                child:IconButton(
                  iconSize:64,
                  onPressed:(){
                    c.value.isPlaying?c.pause():c.play();
                    setState((){});
                  },
                  icon:Icon(
                    c.value.isPlaying
                      ?Icons.pause_circle_filled
                      :Icons.play_circle_fill,
                    color:Colors.cyanAccent,
                  ),
                ),
              ),
            if(controls)
              Positioned(
                left:0,right:0,bottom:0,
                child:Container(
                  color:Colors.black54,
                  child:Column(
                    children:[
                      VideoProgressIndicator(
                        c,allowScrubbing:true,
                        colors:const VideoProgressColors(
                          playedColor:Colors.cyanAccent,
                          bufferedColor:Colors.white38,
                          backgroundColor:Colors.white12)),
                      Padding(
                        padding:const EdgeInsets.symmetric(horizontal:12),
                        child:Row(
                          children:[
                            Text(time(c.value.position),
                              style:const TextStyle(color:Colors.white70)),
                            const Spacer(),
                            Text(time(c.value.duration),
                              style:const TextStyle(color:Colors.white70)),
                          ])),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                        children:[
                          IconButton(
                            onPressed:()=>c.setVolume(
                              c.value.volume==0?1:0),
                            icon:Icon(
                              c.value.volume==0
                                ?Icons.volume_off
                                :Icons.volume_up,
                              color:Colors.white)),
                          IconButton(
                            onPressed:()async{
                              final s=await showModalBottomSheet<double>(
                                context:context,
                                backgroundColor:const Color(0xFF111827),
                                builder:(_)=>Column(
                                  mainAxisSize:MainAxisSize.min,
                                  children:[
                                    for(final v in [.5,.75,1,1.25,1.5,2])
                                      ListTile(
                                        title:Text('${v}x',
                                          style:const TextStyle(
                                            color:Colors.white)),
                                        onTap:()=>Navigator.pop(context,v))
                                  ]));
                              if(s!=null){
                                await c.setPlaybackSpeed(s);
                                setState(()=>speed=s);
                              }
                            },
                            icon:const Icon(Icons.speed,color:Colors.white)),
                          IconButton(
                            onPressed:fs,
                            icon:Icon(
                              full?Icons.fullscreen_exit:Icons.fullscreen,
                              color:Colors.white)),
                        ],
                      ),
                      if(!full)
                        Text('${speed}x',
                          style:const TextStyle(color:Colors.white54)),
                      const SizedBox(height:8),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
