import 'package:flutter/material.dart';
import 'package:pitch_me_app/utils/colors/colors.dart';
import 'package:pitch_me_app/utils/extras/extras.dart';
import 'package:pitch_me_app/utils/styles/styles.dart';
import 'package:video_viewer/video_viewer.dart';

import '../../../utils/sizeConfig/sizeConfig.dart';
import '../../../utils/widgets/Arrow Button/back_arrow.dart';

class ShowFullVideoPage extends StatefulWidget {
  String url;
  dynamic arrowCheck;
  VoidCallback? onPressad;
  ShowFullVideoPage(
      {super.key, required this.url, this.arrowCheck, this.onPressad});

  @override
  State<ShowFullVideoPage> createState() => _ShowFullVideoPageState();
}

class _ShowFullVideoPageState extends State<ShowFullVideoPage> {
  VideoViewerController videoViewerController = VideoViewerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: width(context),
            height: height(context),
            color: Color.fromARGB(255, 254, 254, 254),
            child: VideoViewer(
              controller: videoViewerController,
              autoPlay: true,
              enableHorizontalSwapingGesture: false,
              enableVerticalSwapingGesture: false,
              volumeManager: VideoViewerVolumeManager.device,
              onFullscreenFixLandscape: false,
              forwardAmount: 5,
              defaultAspectRatio: 9 / 16,
              rewindAmount: -5,
              looping: true,
              enableShowReplayIconAtVideoEnd: false,
              style: VideoViewerStyle(
                  playAndPauseStyle: PlayAndPauseWidgetStyle(
                    background: Colors.transparent,
                    circleRadius: 80.0,
                    play: Center(
                      child: Icon(
                        Icons.play_arrow,
                        size: 80,
                        color: DynamicColor.white,
                      ),
                    ),
                    pause: Center(
                      child: Icon(
                        Icons.pause,
                        size: 80,
                        color: DynamicColor.white,
                      ),
                    ),
                  ),
                  thumbnail: Image.network(''),
                  loading: CircularProgressIndicator(
                    color: DynamicColor.gredient1,
                  )),
              source: {
                "Source": VideoSource(
                  video: widget.url.contains('https://api.salespitchapp.com')
                      ? VideoPlayerController.network(Uri.encodeFull(widget.url
                          .replaceAll('https://api.salespitchapp.com',
                              'http://191.101.229.245:9070')))
                      : VideoPlayerController.network(widget.url),
                )
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.getSize30(context: context) +
                  MediaQuery.of(context).size.height * 0.021,
              left: SizeConfig.getFontSize25(context: context),
            ),
            child: BackArrow(
              onPressed: () {
                Navigator.of(context).pop();
              },
              direction: 1,
              alignment: Alignment.topLeft,
            ),
          ),
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: InkWell(
          //     onTap: () {
          //       Navigator.of(context).pop();
          //     },
          //     child: Padding(
          //       padding: EdgeInsets.all(8.0),
          //       child: RotatedBox(
          //         quarterTurns: 1,
          //         child: Image.asset(
          //           "assets/Phase 2 icons/ic_keyboard_arrow_down_24px.png",
          //           height: 30,
          //           width: 30,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          widget.arrowCheck != null
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Pitch details', style: gredient116bold),
                      GestureDetector(
                        onTap: widget.onPressad,
                        child: Padding(
                            padding: EdgeInsets.only(bottom: 5, right: 7),
                            child: RotatedBox(
                              quarterTurns: 4,
                              child: Image.asset(
                                "assets/Phase 2 icons/ic_keyboard_arrow_down_24px.png",
                                height: 30,
                                width: 30,
                              ),
                            )),
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  @override
  void dispose() {
    videoViewerController.pause();
    super.dispose();
  }
}
