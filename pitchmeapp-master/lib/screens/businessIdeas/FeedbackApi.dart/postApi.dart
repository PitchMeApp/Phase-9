import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pitch_me_app/models/FeedbackModel.dart';
import 'package:pitch_me_app/utils/colors/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/businessIdeas/postPageController.dart';
import '../../../core/urls.dart';

PostPageController _pageController = Get.put(PostPageController());

Future<FeedbackModel?> postfeedback(
    receiverid, postid, star, videoStar, description) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    var response = await http.post(
      Uri.parse("${BASE_URL}feedback/add"),
      body: jsonEncode({
        "senderid": prefs.get('user_id').toString(),
        "receiverid":
            (receiverid == null) ? prefs.get('user_id').toString() : receiverid,
        "postid": postid,
        "star": star,
        "videoStar": videoStar,
        "description": description
      }),
      headers: {'Content-Type': "application/json"},
    );

    var data = response.body;
    print("dataa ${data}");

    if (response.statusCode == 200 || response.statusCode == 202) {
      print('successfully logged');

      Fluttertoast.showToast(
          msg: "Feedback given Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: DynamicColor.black,
          textColor: Colors.white,
          fontSize: 16.0);
      // _pageController.swipableStackController
      //     .next(swipeDirection: SwipeDirection.left);
      _pageController.left.value = false;
      //  Navigator.pop(context);
      //Get.offAll(Floatbar(1));
      Get.back();
      return feedbackModelFromJson(data);
    } else {
      print('login failed');
      return null;
    }
  } catch (e) {
    print(e.toString());
  }
}
