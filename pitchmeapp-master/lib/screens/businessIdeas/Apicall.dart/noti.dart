import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:pitch_me_app/screens/businessIdeas/Apicall.dart/api_Integration.dart';
import 'package:pitch_me_app/screens/businessIdeas/Apicall.dart/notification_Model.dart';

class DataClass extends ChangeNotifier {
  notification? post;
  int totalNotiCount = 0;
  bool loading = false;

  getPostData() async {
    loading = false;
    post = (await getSinglePostData())!;
    if (post!.unreadNotification! > totalNotiCount) {
      if (Platform.isAndroid) {
        FlutterBeep.playSysSound(AndroidSoundIDs.TONE_SUP_RADIO_NOTAVAIL);
      } else {
        FlutterBeep.playSysSound(iOSSoundIDs.SMSReceived_Alert1);
      }
    }
    totalNotiCount = post!.unreadNotification!;

    loading = false;

    notifyListeners();
  }
}
