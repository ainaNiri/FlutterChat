// // import 'package:flutter/material.dart';
// // import 'package:flutter_webrtc/flutter_webrtc.dart';
// // import 'package:flutter_ion/flutter_ion.dart';
// // import 'package:myapp/utilities/function.dart';
// // import 'package:uuid/uuid.dart';

// // class VideoCall extends StatefulWidget {
// //   @override
// //   _VideoCallState createState() => _VideoCallState();
// // }

// // class _VideoCallState extends State<VideoCall> {
// //   final _localRenderer = RTCVideoRenderer();
// //   final List<RTCVideoRenderer> _remoteRenderers = <RTCVideoRenderer>[];
// //   final Connector _connector = Connector('http://127.0.0.1:7000');
// //   final _room = 'ion';
// //   final _uid = Uuid().v4();
// //   late RTC _rtc;
  
// //   @override
// //   void initState() {
// //     super.initState();
// //     connect();
// //     requestPermission();
// //   }

// //   void connect() async {
// //     _rtc = RTC(_connector);
// //     _rtc.onspeaker = (Map<String, dynamic> list) {
// //       print('onspeaker: $list');
// //     };

// //     _rtc.ontrack = (track, RemoteStream remoteStream) async {
// //       print('onTrack: remote stream => ${remoteStream.id}');
// //       if (track.kind == 'video') {
// //         var renderer = RTCVideoRenderer();
// //         await renderer.initialize();
// //         renderer.srcObject = remoteStream.stream;
// //         setState(() {
// //           _remoteRenderers.add(renderer);
// //         });
// //       }
// //     };

// //     _rtc.ontrackevent = (TrackEvent event) {
// //       print(
// //         'ontrackevent state = ${event.state},  uid = ${event.uid},  tracks = ${event.tracks}');
// //       if (event.state == TrackState.REMOVE) {
// //         setState(() {
// //           _remoteRenderers.removeWhere(
// //             (element) => element.srcObject?.id == event.tracks[0].stream_id);
// //         });
// //       }
// //     };

// //     await _rtc.connect();
// //     print("ok");
// //     await _rtc.join(_room, _uid, JoinConfig());

// //     await _localRenderer.initialize();
// //     // publish LocalStream
// //     var localStream =
// //       await LocalStream.getUserMedia(constraints: Constraints.defaults);
// //     await _rtc.publish(localStream);
// //     setState(() {
// //       _localRenderer.srcObject = localStream.stream;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         appBar: AppBar(
// //           title: Text('ion-sfu'),
// //         ),
// //         body: OrientationBuilder(builder: (context, orientation) {
// //           return Column(
// //             children: [
// //               Row(
// //                 children: [Text('Local Video')],
// //               ),
// //               Row(
// //                 children: [
// //                   SizedBox(
// //                     width: 260,
// //                     height: 220,
// //                     child: RTCVideoView(_localRenderer, mirror: true)
// //                   )
// //                 ],
// //               ),
// //               Row(
// //                 children: [Text('Remote Video')],
// //               ),
// //               Row(
// //                 children: [
// //                   ..._remoteRenderers.map((remoteRenderer) {
// //                     return SizedBox(
// //                       width: 260,
// //                       height: 220,
// //                       child: RTCVideoView(remoteRenderer));
// //                   }).toList(),
// //                 ],
// //               ),
// //             ],
// //           );
// //         })
// //       ),
// //     );
// //   }
// // }
// P2PClient callClient = P2PClient.instance; // returns instance of P2PClient

// callClient.init(); // starts listening of incoming calls
// callClient.destroy(); // stops listening incoming calls and clears callbacks

// // calls when P2PClient receives new incoming call
// callClient.onReceiveNewSession = (incomingCallSession) {

// };

// // calls when any callSession closed
// callClient.onSessionClosed = (closedCallSession) {

// };

// // creates new P2PSession 
// callClient.createCallSession(callType, opponentsIds);