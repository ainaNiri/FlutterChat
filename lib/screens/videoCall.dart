import 'package:flutter/material.dart';
import 'package:flutter_ion/flutter_ion.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class VideoConference extends StatefulWidget {
  String roomId;
  VideoConference({required this.roomId});

  @override
  _VideoConferenceState createState() => _VideoConferenceState();
}

class _VideoConferenceState extends State<VideoConference> {  

  final _localRenderer = RTCVideoRenderer();
  final List<RTCVideoRenderer> _remoteRenderers = <RTCVideoRenderer>[];
  final Connector _connector = Connector('http://192.168.0.133:50051');
  final _room = 'ion';
  final _uid = Uuid().v4();
  bool _mute = false;
  late RTC _rtc;
  @override
  void initState() {
    super.initState();
    connect();
  }

  @override
  void deactivate(){
    close();
    super.deactivate();
  }

  void close() async{
    await _localRenderer.srcObject!.dispose();
    await _localRenderer.dispose();
    _rtc.close();
  }

  void connect() async {
    _rtc = RTC(_connector);
    _rtc.onspeaker = (Map<String, dynamic> list) {
      print('onspeaker: $list');
    };

    _rtc.ontrack = (track, RemoteStream remoteStream) async {
      print('onTrack: remote stream => ${remoteStream.id}');
      if (track.kind == 'video') {
        var renderer = RTCVideoRenderer();
        await renderer.initialize();
        renderer.srcObject = remoteStream.stream;
        setState(() {
          _remoteRenderers.add(renderer);
        });
      }
    };

    _rtc.ontrackevent = (TrackEvent event) {
      print(
          'ontrackevent state = ${event.state},  uid = ${event.uid},  tracks = ${event.tracks}');
      if (event.state == TrackState.REMOVE) {
        setState(() {
          _remoteRenderers.removeWhere(
              (element) => element.srcObject?.id == event.tracks[0].stream_id);
        });
      }
    };

    await _rtc.connect();
    await _rtc.join(_room, _uid, JoinConfig());

    await _localRenderer.initialize();
    // publish LocalStream
    var localStream =
        await LocalStream.getUserMedia(constraints: Constraints.defaults);
    await _rtc.publish(localStream);
    setState(() {
      _localRenderer.srcObject = localStream.stream;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ion-sfu',
      home: Scaffold(
        backgroundColor: Colors.black54,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 3,
            title: Text('Video Call', style: TextStyle(color: Colors.white)),
            centerTitle: true,
          ),
          body: OrientationBuilder(builder: (context, orientation) {
            return Stack(
              children: [
                Container(                 
                  child: Center(
                    child: SizedBox(
                      child: RTCVideoView(_localRenderer, mirror: true,)
                    ),
                  )
                ),
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: Container(
                    width: (1.4 * MediaQuery.of(context).size.width)/2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                            backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 72, 70, 70)),
                            minimumSize: MaterialStateProperty.all(Size(60, 60)),
                          ),
                          onPressed:() async{
                            try{
                              await Helper.switchCamera(_localRenderer.srcObject!.getVideoTracks()[0]);
                              /*setState(() {
                                _mirror = !_mirror;
                              });*/
                            }catch(e){
                              print(e.toString());
                            }
                          },
                          child: Icon(Icons.switch_camera, color: Colors.white,),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                            backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 72, 70, 70)),
                            minimumSize: MaterialStateProperty.all(Size(60, 60)),
                          ),
                          onPressed:(){
                            bool enabled = _localRenderer.muted;
                            MediaStream mediaStream = _localRenderer.srcObject!;
                            mediaStream.getAudioTracks()[0].enabled = !enabled;
                            setState((){
                              _localRenderer.srcObject = mediaStream;
                              _mute = !_mute;
                            });
                          },
                          child: _mute ? Icon(Icons.mic_off) : Icon(Icons.mic, color: Colors.white,),
                        ),
                         ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                            backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 72, 70, 70)),
                            minimumSize: MaterialStateProperty.all(Size(60, 60)),
                          ),
                          onPressed:() async{
                            final mediaConstraints = <String, dynamic>{'audio': true, 'video': true};
                            try {
                              var stream = await navigator.mediaDevices.getDisplayMedia(mediaConstraints);

                              _localRenderer.srcObject = stream;
                              setState(() {
                                
                              });
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                          child: Icon(Icons.screen_share, color: Colors.white,),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                            backgroundColor: MaterialStateProperty.all(Colors.red),
                            minimumSize: MaterialStateProperty.all(Size(60, 60)),
                          ),
                          child: Icon(Icons.call_end, color: Colors.white),
                          onPressed: ()async{
                            await Future.delayed(Duration(seconds: 2));
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  )
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Row(
                    children: [
                      ..._remoteRenderers.map((remoteRenderer) {
                        return SizedBox(
                          width: 160,
                          height: 120,
                          child: RTCVideoView(remoteRenderer,));
                      }).toList(),
                    ],
                  ),
                ),
              ],
            );
          }
        )
      )
    );
  }
}
