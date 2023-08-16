import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitch_me_app/Phase%206/Guest%20UI/Guest%20limitation%20pages/login_limitation.dart';
import 'package:pitch_me_app/Phase%206/Guest%20UI/Profile/manu.dart';
import 'package:pitch_me_app/utils/colors/colors.dart';
import 'package:pitch_me_app/utils/extras/extras.dart';
import 'package:pitch_me_app/utils/sizeConfig/sizeConfig.dart';
import 'package:pitch_me_app/utils/widgets/Navigation/custom_navigation.dart';
import 'package:pitch_me_app/utils/widgets/containers/containers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_viewer/video_viewer.dart';

import '../../View/Demo Video/title_tutorial.dart';
import '../../utils/styles/styles.dart';

class WatchSalesPitch extends StatefulWidget {
  const WatchSalesPitch({super.key});

  @override
  State<WatchSalesPitch> createState() => _WatchSalesPitchState();
}

class _WatchSalesPitchState extends State<WatchSalesPitch> {
  VideoViewerController videoViewerController = VideoViewerController();
  bool isCheck = false;
  bool isCheckTutorial = false;
  bool playTutorial = false;
  bool isLoading = false;

  @override
  void initState() {
    checkGuest();

    super.initState();
  }

  void checkGuest() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences preferencesData = await SharedPreferences.getInstance();
    setState(() {
      if (preferencesData.getBool('addsalestutorial') != null) {
        playTutorial = preferencesData.getBool('addsalestutorial')!;
        isCheckTutorial = preferencesData.getBool('addsalestutorial')!;
        isCheck = preferencesData.getBool('addsalestutorial')!;
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  void checkDontShow(bool check) async {
    SharedPreferences preferencesData = await SharedPreferences.getInstance();
    setState(() {
      preferencesData.setBool('addsalestutorial', check).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: playTutorial == false
          ? TitleTutorialPage(
              title: 'Watch Sales Pitch',
              pageIndex: 2,
              isCheck: isCheck,
              onPlay: () {
                setState(() {
                  playTutorial = true;
                });
              },
              onNext: () {
                videoViewerController.pause();

                Get.to(() => LoginLimitationPage());
              },
              onCheck: (value) {
                setState(() {
                  isCheckTutorial = value!;
                });
              })
          : Stack(
              children: [
                video(),
                header(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: SizeConfig.getSizeHeightBy(
                            context: context, by: 0.12),
                        left: SizeConfig.getSize30(context: context)),
                    child: Row(
                      children: [
                        Transform.scale(
                            scale: 2.5,
                            child: Checkbox(
                                activeColor: DynamicColor.white,
                                checkColor: DynamicColor.green,
                                side: BorderSide(
                                    color: DynamicColor.white, width: 1.5),
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
                child: InkWell(
                  onTap: () {
                    videoViewerController.pause();
                  },
                  child: Icon(
                    Icons.pause,
                    size: 80,
                    color: DynamicColor.white,
                  ),
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

  Widget header() {
    return Padding(
        padding: EdgeInsets.only(
            top: SizeConfig.getSize30(context: context) +
                SizeConfig.getSize20(context: context),
            bottom: SizeConfig.getSize20(context: context),
            left: SizeConfig.getFontSize25(context: context),
            right: SizeConfig.getFontSize25(context: context)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                AppBarIconContainer(
                  height: SizeConfig.getSize38(context: context),
                  width: SizeConfig.getSize38(context: context),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: loadSvg(
                      image: 'assets/image/notifications.svg',
                    ),
                  ),
                  onTap: () {
                    videoViewerController.pause();
                    PageNavigateScreen()
                        .push(context, LoginLimitationPage())
                        .then((value) {
                      setState(() {
                        videoViewerController.play();
                      });
                    });
                  },
                ),
                SizedBox(height: 5),
                // AppBarIconContainer(
                //   height: SizeConfig.getSize38(context: context),
                //   width: SizeConfig.getSize38(context: context),
                //   borderRadius: BorderRadius.only(
                //       topRight: Radius.circular(10),
                //       bottomLeft: Radius.circular(10)),
                //   color: DynamicColor.redColor,
                //   child: Icon(Icons.close, size: 35, color: DynamicColor.white),
                //   onTap: () {},
                // )
              ],
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 8),

              height: MediaQuery.of(context).size.height * 0.04,
              // width: MediaQuery.of(context).size.width * 0.35,
              child: Center(
                child: Text(
                  'Sales Pitch Tutorial',
                  style: TextStyle(
                      color: DynamicColor.gredient1,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Column(
              children: [
                AppBarIconContainer(
                  height: SizeConfig.getSize38(context: context),
                  width: SizeConfig.getSize38(context: context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: loadSvg(
                      image: 'assets/image/menu.svg',
                    ),
                  ),
                  onTap: () {
                    videoViewerController.pause();
                    PageNavigateScreen()
                        .push(
                            context,
                            GuestManuPage(
                              title: 'Watch Sales Pitch',
                              pageIndex: 1,
                            ))
                        .then((value) {
                      setState(() {
                        videoViewerController.play();
                      });
                    });
                  },
                ),
                SizedBox(height: 5),
                AppBarIconContainer(
                  height: SizeConfig.getSize38(context: context),
                  width: SizeConfig.getSize38(context: context),
                  color: DynamicColor.green,
                  child: Icon(Icons.check, size: 35, color: DynamicColor.white),
                  onTap: () {
                    videoViewerController.pause();
                    PageNavigateScreen()
                        .push(context, LoginLimitationPage())
                        .then((value) {
                      setState(() {
                        videoViewerController.play();
                      });
                    });
                  },
                )
              ],
            )
          ],
        ));
  }

  @override
  void dispose() {
    videoViewerController.pause();

    super.dispose();
  }
}
