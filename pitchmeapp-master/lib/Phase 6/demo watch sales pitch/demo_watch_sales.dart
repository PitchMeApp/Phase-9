import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitch_me_app/Phase%206/demo%20watch%20sales%20pitch/controller.dart';
import 'package:pitch_me_app/utils/colors/colors.dart';
import 'package:pitch_me_app/utils/extras/extras.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_viewer/video_viewer.dart';

import '../../View/Custom header view/appbar.dart';
import '../../View/Custom header view/new_bottom_bar.dart';
import '../../View/Manu/manu.dart';
import '../../utils/sizeConfig/sizeConfig.dart';
import '../../utils/styles/styles.dart';
import '../../utils/widgets/Navigation/custom_navigation.dart';
import '../../utils/widgets/containers/containers.dart';

class DemoWatchSalesPitch extends StatefulWidget {
  const DemoWatchSalesPitch({super.key});

  @override
  State<DemoWatchSalesPitch> createState() => _DemoWatchSalesPitchState();
}

class _DemoWatchSalesPitchState extends State<DemoWatchSalesPitch> {
  VideoViewerController videoViewerController = VideoViewerController();
  DemoWatchSalesPitchController watchSalesPitchController =
      Get.put(DemoWatchSalesPitchController());
  String newUser = '';
  String businesstype = '';

  bool isCheck = false;
  bool isCheckTutorial = false;
  bool playTutorial = false;
  bool isLoading = false;

  @override
  void initState() {
    getUserType();
    super.initState();
  }

  getUserType() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      businesstype = prefs.getString('log_type').toString();
      newUser = prefs.getString('new_user').toString();
      if (prefs.getBool('watchsalestutorial') != null) {
        playTutorial = prefs.getBool('watchsalestutorial')!;
        isCheckTutorial = prefs.getBool('watchsalestutorial')!;
        // if ((businesstype == '1' ||
        //     businesstype == '2' ||
        //     businesstype != '5')) {
        isCheck = prefs.getBool('watchsalestutorial')!;
        // }
      }
      isLoading = false;
    });
  }

  void checkDontShow(bool check) async {
    SharedPreferences preferencesData = await SharedPreferences.getInstance();
    setState(() {
      preferencesData.setBool('watchsalestutorial', check).toString();
    });
  }

  removeUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove('new_user').toString();
    });
  }

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
                  video: VideoPlayerController.network(
                      'https://ciu.ody.mybluehostin.me/ringbell/watchsales.mp4'),
                )
              },
            ),
          ),
          CustomAppbar(
            title: 'Watch Sales Pitch',
            onPressad: () {
              PageNavigateScreen().push(
                  context,
                  ManuPage(
                    title: 'Watch Sales Pitch',
                    pageIndex: 1,
                    isManu: 'Manu',
                  ));
            },
            onPressadForNotify: () {},
          ),
          Padding(
            padding: EdgeInsets.only(
                top: SizeConfig.getSize30(context: context) +
                    SizeConfig.getSize55(context: context) +
                    SizeConfig.getSize5(context: context),
                left: SizeConfig.getFontSize25(context: context),
                right: SizeConfig.getFontSize25(context: context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Align(
                //   alignment: Alignment.topRight,
                //   child: AppBarIconContainer(
                //     height: SizeConfig.getSize38(context: context),
                //     width: SizeConfig.getSize38(context: context),
                //     color: DynamicColor.redColor,
                //     borderRadius: BorderRadius.only(
                //         topRight: Radius.circular(10),
                //         bottomLeft: Radius.circular(10)),
                //     child: Icon(
                //       Icons.close,
                //       color: DynamicColor.white,
                //       size: 30,
                //     ),
                //     onTap: () {},
                //   ),
                // ),
                Align(
                  alignment: Alignment.topRight,
                  child: AppBarIconContainer(
                    height: SizeConfig.getSize38(context: context),
                    width: SizeConfig.getSize38(context: context),
                    color: DynamicColor.green,
                    child: Icon(
                      Icons.check,
                      color: DynamicColor.white,
                      size: 30,
                    ),
                    onTap: () {
                      videoViewerController.pause();

                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom:
                      SizeConfig.getSizeHeightBy(context: context, by: 0.12),
                  left: SizeConfig.getSize30(context: context)),
              child: Row(
                children: [
                  Transform.scale(
                      scale: 2.5,
                      child: Checkbox(
                          activeColor: DynamicColor.white,
                          checkColor: DynamicColor.green,
                          side:
                              BorderSide(color: DynamicColor.white, width: 1.5),
                          value: isCheck,
                          onChanged: (value) {
                            setState(() {
                              isCheck = value!;
                              checkDontShow(isCheck);
                            });
                          })),
                  SizedBox(width: 10),
                  Text(
                    "Don’t show tutorial again",
                    style: white16bold,
                  ),
                ],
              ),
            ),
          ),
          NewCustomBottomBar(
            index: 1,
            isBack: true,
          )
        ],
      ),
    );
  }

  Widget video() {
    return Container(
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
            video: VideoPlayerController.network(
                'https://ciu.ody.mybluehostin.me/ringbell/watchsales.mp4'),
          )
        },
      ),
    );
  }

  @override
  void dispose() {
    videoViewerController.dispose();

    super.dispose();
  }
}
