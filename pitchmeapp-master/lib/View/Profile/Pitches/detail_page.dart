import 'package:flutter/material.dart';
import 'package:pitch_me_app/View/Profile/Likes/detail_page.dart';
import 'package:pitch_me_app/View/posts/detail_page.dart';

class PitcheShowFullVideoPage extends StatefulWidget {
  String url;
  dynamic data;
  PitcheShowFullVideoPage({super.key, required this.url, required this.data});

  @override
  State<PitcheShowFullVideoPage> createState() =>
      _PitcheShowFullVideoPageState();
}

class _PitcheShowFullVideoPageState extends State<PitcheShowFullVideoPage> {
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
      controller: pageController,
      scrollDirection: Axis.vertical,
      physics: widget.data.id.contains('6448e9494ff8f4cb69599465')
          ? NeverScrollableScrollPhysics()
          : ClampingScrollPhysics(),
      children: [
        ShowFullVideoPage(
          url: widget.url,
          arrowCheck: true,
          onPressad: () {
            if (widget.data.id.contains('6448e9494ff8f4cb69599465') == false) {
              pageController.nextPage(
                  duration: Duration(milliseconds: 200), curve: Curves.linear);
            }
          },
        ),
        PostDetailPage(
          data: widget.data,
          arrowCheck: true,
          userID: widget.data.userid,
          onPressad: () {
            pageController.previousPage(
                duration: Duration(milliseconds: 200), curve: Curves.linear);
          },
        )
      ],
    ));
  }
}
