import 'dart:math';
import 'package:bluu/pages/callscreens/videocall_screen.dart';
import 'package:bluu/pages/callscreens/voicecall_screen.dart';
import 'package:flutter/material.dart';
import 'package:bluu/models/call.dart';
import 'package:bluu/models/user.dart';
import 'package:bluu/resources/call_methods.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dialVideo({User from, User to, context, String callis}) async {
    Call call = Call(
      accepted: false,
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
    );

    bool callMade = await callMethods.makeVideoCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoCallScreen(call: call),
          ));
    }
  }

  static dialVoice({User from, User to, context, String callis}) async {
    Call call = Call(
      accepted: false,
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
    );

    bool callMade = await callMethods.makeVoiceCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VoiceCallScreen(call: call)
          ));
    }
  }
}
