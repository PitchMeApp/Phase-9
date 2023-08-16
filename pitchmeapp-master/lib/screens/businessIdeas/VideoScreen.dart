// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitch_me_app/Phase%206/demo%20watch%20sales%20pitch/demo_watch_sales.dart';
import 'package:pitch_me_app/View/Feedback/feedback_detail.dart';
import 'package:pitch_me_app/View/Profile/Biography/biography.dart';
import 'package:pitch_me_app/controller/businessIdeas/dashBoardController.dart';
import 'package:pitch_me_app/screens/businessIdeas/Apicall.dart/noti.dart';
import 'package:pitch_me_app/screens/businessIdeas/dashBoardScreen_Two.dart';
import 'package:pitch_me_app/screens/businessIdeas/home%20biography/home_page_biography.dart';
import 'package:pitch_me_app/screens/businessIdeas/home_manu.dart';
import 'package:pitch_me_app/utils/colors/colors.dart';
import 'package:pitch_me_app/utils/sizeConfig/sizeConfig.dart';
import 'package:pitch_me_app/utils/widgets/Navigation/custom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Phase 6/Guest UI/Guest limitation pages/user_type_limitation.dart';
import '../../Phase 6/demo watch sales pitch/controller.dart';
import '../../View/Demo Video/title_tutorial.dart';
import '../../View/Profile/Pitches/pitches_list.dart';
import '../../controller/businessIdeas/postPageController.dart';
import '../../utils/extras/extras.dart';
import '../../utils/styles/styles.dart';
import '../../utils/widgets/containers/containers.dart';
import 'home biography/Chat/Admin User/chat_list.dart';

class mainHome_Two extends StatefulWidget {
  const mainHome_Two({super.key});

  @override
  State<mainHome_Two> createState() => _mainHome_TwoState();
}

class _mainHome_TwoState extends State<mainHome_Two>
    with SingleTickerProviderStateMixin {
  PostPageController postPageController = Get.put(PostPageController());
  DashboardController dashboardController = Get.put(DashboardController());
  DemoWatchSalesPitchController watchSalesPitchController =
      Get.put(DemoWatchSalesPitchController());

  late AnimationController _animationController;
  late Animation _colorTween;

  bool _isInitialValue = false;
  bool isManu = false;
  bool isCheck = false;
  bool isCheckTutorial = false;
  bool playTutorial = false;
  bool isLoading = false;

  String title = '';
  String businesstype = '';
  String newUser = '';
  String checkGuestType = '';

  int currentIndexOfDashboard = 0;
  late Widget currentScreen;
  Timer timer = Timer(Duration(seconds: 0), () {});
  @override
  void initState() {
    super.initState();
    getUserType();
    // Colors.white.withOpacity(0.3)
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    _colorTween = ColorTween(begin: DynamicColor.blue, end: DynamicColor.blue)
        .animate(_animationController);
    Future.delayed(const Duration(seconds: 0), () {
      _animationController.status == AnimationStatus.completed
          ? _animationController.reset()
          : _animationController.forward();
    });
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      final postModel = Provider.of<DataClass>(context, listen: false);
      postModel.getPostData();
    });
    currentScreen = DashBoardScreen_Two(
      userType: businesstype,
      currentPage: (int index) {
        currentIndexOfDashboard = index;
        if (!mounted) {
          return;
        }
        setState(() {});
      },
      onSwipe: (int index, String _title, bool isFinish) {
        print("index is $index and title is $title");
        title = _title;
        if (!mounted) {
          return;
        }
        setState(() {});
      },
    );
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  getUserType() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkGuestType = prefs.getString('guest').toString();
      businesstype = prefs.getString('log_type').toString();
      newUser = prefs.getString('new_user').toString();
      if (prefs.getBool('watchsalestutorial') != null) {
        playTutorial = prefs.getBool('watchsalestutorial')!;
        isCheckTutorial = prefs.getBool('watchsalestutorial')!;
        // if (businesstype != '5') {
        //   if ((businesstype == '1' || businesstype == '2')) {
        isCheck = prefs.getBool('watchsalestutorial')!;
        //   }
        // } else {
        //   log('message');
        // }
      } else {
        isCheck = false;
      }
      isLoading = false;
    });

    //log(" ADGL ${businesstype}");
  }

  void checkDontShow(bool check) async {
    SharedPreferences preferencesData = await SharedPreferences.getInstance();
    setState(() {
      preferencesData.setBool('watchsalestutorial', check).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    log(isCheck.toString());
    final sizeH = MediaQuery.of(context).size.height;
    final sizeW = MediaQuery.of(context).size.width;

    return Scaffold(
        body: isLoading
            ? CircularProgressIndicator(
                color: DynamicColor.gredient1,
              )
            : playTutorial == false
                ? TitleTutorialPage(
                    title: 'Watch Sales Pitch',
                    pageIndex: 2,
                    isCheck: isCheckTutorial,
                    onPlay: () {
                      PageNavigateScreen()
                          .push(context, DemoWatchSalesPitch())
                          .then((value) {
                        setState(() {
                          playTutorial = true;
                        });
                      });
                    },
                    onNext: () {
                      setState(() {
                        playTutorial = true;
                      });
                    },
                    onCheck: (value) {
                      setState(() {
                        isCheckTutorial = value!;
                        checkDontShow(isCheckTutorial);
                      });
                    },
                  )
                : businesstype == '1' || businesstype == '2'
                    // : businesstype == '5' ||
                    //         businesstype == '1' ||
                    //         businesstype == '2' ||
                    //         ((businesstype == '3' ||
                    //                 businesstype == '4') &&
                    //             (newUser == 'New User'))
                    ? UserTypeLimitationPage(
                        title1: 'Only Investor and',
                        title2: 'Facilitator users can',
                        title3: 'access this page.',
                      )
                    : Stack(
                        children: [
                          isManu
                              ? HomeManuPage(
                                  pageIndex: 1,
                                )
                              : currentScreen,
                          Obx(() {
                            return postPageController.right.value == true ||
                                    postPageController.left.value == true
                                ? Container()
                                : Padding(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.getSize30(
                                                context: context) +
                                            MediaQuery.of(context).size.height *
                                                0.021,
                                        bottom: SizeConfig.getSize20(
                                            context: context),
                                        left: SizeConfig.getFontSize25(
                                            context: context),
                                        right: SizeConfig.getFontSize25(
                                            context: context)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        currentIndexOfDashboard == 0
                                            ? Stack(
                                                children: [
                                                  AnimatedBuilder(
                                                      animation: _colorTween,
                                                      builder:
                                                          (context, child) {
                                                        return AnimatedContainer(
                                                          height: _isInitialValue
                                                              ? sizeH * 0.5
                                                              : SizeConfig
                                                                  .getSize38(
                                                                      context:
                                                                          context),
                                                          width: _isInitialValue
                                                              ? sizeW * 0.70
                                                              : SizeConfig
                                                                  .getSize38(
                                                                      context:
                                                                          context),
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius: _isInitialValue ==
                                                                          false
                                                                      ? BorderRadius.only(
                                                                          topRight: Radius.circular(
                                                                              10),
                                                                          bottomLeft: Radius.circular(
                                                                              10))
                                                                      : BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  gradient: isManu
                                                                      ? _isInitialValue
                                                                          ? DynamicColor.gradientColorChange
                                                                          : null
                                                                      : DynamicColor.gradientColorChange,
                                                                  color: isManu
                                                                      ? _isInitialValue
                                                                          ? null
                                                                          : DynamicColor.white
                                                                      : null
                                                                  //  _isInitialValue
                                                                  //     ? Color(0xff377eb4)
                                                                  //     : _colorTween.value

                                                                  ),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  300),
                                                          child: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                _isInitialValue =
                                                                    !_isInitialValue;
                                                              });
                                                            },
                                                            child:
                                                                _isInitialValue
                                                                    ? Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(12.0),
                                                                        child: Consumer<
                                                                            DataClass>(builder: (BuildContext
                                                                                context,
                                                                            value,
                                                                            Widget?
                                                                                child) {
                                                                          return ListView
                                                                              .separated(
                                                                            shrinkWrap:
                                                                                true,
                                                                            padding:
                                                                                EdgeInsets.zero,
                                                                            itemCount:
                                                                                value.post?.result?.length ?? 2,
                                                                            itemBuilder:
                                                                                (BuildContext context, int index) {
                                                                              return value.loading
                                                                                  ? Center(
                                                                                      child: CircularProgressIndicator(),
                                                                                    )
                                                                                  : InkWell(
                                                                                      onTap: () {
                                                                                        print("Click in notification");
                                                                                        setState(() {
                                                                                          _isInitialValue == true ? Future.delayed(Duration(milliseconds: 300), () {}) : false;

                                                                                          _isInitialValue = false;
                                                                                        });

                                                                                        if (value.post?.result![index].type == 5) {
                                                                                          PageNavigateScreen().normalpushReplesh(
                                                                                              context,
                                                                                              HomeBiographyPage(
                                                                                                type: 'watch',
                                                                                                userID: '',
                                                                                                notifyID: value.post!.result![index].sId!,
                                                                                              ));
                                                                                        } else if (value.post?.result![index].type == 6) {
                                                                                          PageNavigateScreen().push(
                                                                                              context,
                                                                                              FeedbackPage(
                                                                                                type: 'home',
                                                                                                notifyID: value.post!.result![index].sId!,
                                                                                                data: value.post!.result![index],
                                                                                              ));
                                                                                        } else if (value.post?.result![index].type == 7) {
                                                                                          PageNavigateScreen().push(context, PitchesListPage(notifyID: value.post!.result![index].sId!));
                                                                                        } else if (value.post?.result![index].type == 8) {
                                                                                          PageNavigateScreen().push(
                                                                                              context,
                                                                                              BiographyPage(
                                                                                                type: '',
                                                                                                notifyID: value.post!.result![index].sId!,
                                                                                              ));
                                                                                        } else if (value.post?.result![index].type == 11) {
                                                                                          PageNavigateScreen().push(
                                                                                              context,
                                                                                              AdminUserChatListPage(
                                                                                                notifyID: value.post!.result![index].sId!,
                                                                                              ));
                                                                                        }
                                                                                      },
                                                                                      child: Container(
                                                                                        height: sizeH * 0.06,
                                                                                        width: sizeW * 0.65,
                                                                                        // color: Colors.red,
                                                                                        child: SingleChildScrollView(
                                                                                          scrollDirection: Axis.horizontal,
                                                                                          child: Row(children: [
                                                                                            Icon(Icons.notifications_active_outlined, color: DynamicColor.white),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(
                                                                                                left: sizeW * 0.03,
                                                                                                //top: sizeH * 0.01
                                                                                              ),
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  Container(
                                                                                                    //height: sizeH * 0.02,
                                                                                                    width: sizeW * 0.50,
                                                                                                    alignment: Alignment.centerLeft,

                                                                                                    child: Text(
                                                                                                      value.post?.result?[index].title.toString() ?? "",
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                      maxLines: 2,
                                                                                                      style: value.post?.result?[index].unreadFlag == 0
                                                                                                          ? TextStyle(color: DynamicColor.white, fontWeight: FontWeight.bold)
                                                                                                          : TextStyle(
                                                                                                              color: Colors.white,
                                                                                                              fontSize: 13,
                                                                                                              fontWeight: FontWeight.normal,
                                                                                                            ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  // Text(
                                                                                                  //   value.post?.result?[index].text.toString() ?? "",
                                                                                                  //   overflow: TextOverflow.ellipsis,
                                                                                                  //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                                                                                  // ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ]),
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                            },
                                                                            separatorBuilder:
                                                                                (BuildContext context, int index) {
                                                                              return Padding(
                                                                                padding: EdgeInsets.only(left: sizeW * 0.02, right: sizeW * 0.02),
                                                                                child: Divider(
                                                                                  height: 2,
                                                                                  color: DynamicColor.white,
                                                                                ),
                                                                              );
                                                                            },
                                                                          );
                                                                        }),
                                                                      )
                                                                    : Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child: loadSvg(
                                                                            image:
                                                                                'assets/image/notifications.svg',
                                                                            color: isManu
                                                                                ? DynamicColor.gredient1
                                                                                : null),
                                                                      ),
                                                          ),
                                                        );
                                                      }),
                                                  _isInitialValue == false
                                                      ? Consumer<DataClass>(
                                                          builder: (BuildContext
                                                                  context,
                                                              value,
                                                              Widget? child) {
                                                          return Visibility(
                                                            visible:
                                                                value.totalNotiCount ==
                                                                        0
                                                                    ? false
                                                                    : true,
                                                            child: Container(
                                                              height: 20,
                                                              width: 20,
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 35,
                                                                      bottom:
                                                                          25),
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 3,
                                                                      right: 3),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration: BoxDecoration(
                                                                  color: DynamicColor
                                                                      .redColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50)),
                                                              child: FittedBox(
                                                                child: Text(
                                                                  value
                                                                      .totalNotiCount
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: DynamicColor
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        })
                                                      : Container()
                                                ],
                                              )
                                            : Container(),
                                        currentIndexOfDashboard == 0
                                            ? _isInitialValue == true
                                                ? Container()
                                                : Container(
                                                    alignment: Alignment.center,
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    height: sizeH * 0.04,
                                                    width: sizeW * 0.35,
                                                    child: isManu
                                                        ? Center(
                                                            child: Text(
                                                              'MENU',
                                                              style:
                                                                  white17wBold,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          )
                                                        : Center(
                                                            child: businesstype == '5' ||
                                                                    businesstype ==
                                                                        '1' ||
                                                                    businesstype ==
                                                                        '2' ||
                                                                    ((businesstype ==
                                                                                '3' ||
                                                                            businesstype ==
                                                                                '4') &&
                                                                        (newUser ==
                                                                            'New User'))
                                                                ? Text(
                                                                    'Watch Sales Pitch',
                                                                    style:
                                                                        gredient116bold,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  )
                                                                : Text(
                                                                    dashboardController.salespitch !=
                                                                            null
                                                                        ? dashboardController.salespitch!.result.docs.isNotEmpty
                                                                            ? dashboardController.salespitch!.result.docs[postPageController.swipableStackController.currentIndex].title
                                                                            : 'No Title'
                                                                        : 'No Title',
                                                                    style: TextStyle(
                                                                        color: DynamicColor
                                                                            .gredient1,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            16),
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                          ),
                                                  )
                                            : Container(),
                                        Column(
                                          children: [
                                            currentIndexOfDashboard == 0
                                                ? AppBarIconContainer(
                                                    height:
                                                        SizeConfig.getSize38(
                                                            context: context),
                                                    width: SizeConfig.getSize38(
                                                        context: context),
                                                    color: isManu
                                                        ? DynamicColor.white
                                                        : null,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: loadSvg(
                                                          image:
                                                              'assets/image/menu.svg',
                                                          color: isManu == true
                                                              ? DynamicColor
                                                                  .darkBlue
                                                              : null),
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        isManu = !isManu;
                                                        watchSalesPitchController
                                                                .isMenuCheck
                                                                .value !=
                                                            watchSalesPitchController
                                                                .isMenuCheck
                                                                .value;
                                                      });
                                                    },
                                                  )
                                                : Container(),
                                            currentIndexOfDashboard == 0
                                                ? spaceHeight(5)
                                                : spaceHeight(0),
                                            // currentIndexOfDashboard == 0
                                            //     ? businesstype == '1' ||
                                            //             businesstype == '2' ||
                                            //             ((businesstype == '3' ||
                                            //                     businesstype == '4') &&
                                            //                 (newUser == 'New User'))
                                            //         ? Container()
                                            //         : backButton()
                                            //     : Container(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                          }),
                        ],
                      ));
  }

  Widget backButton() {
    return AppBarIconContainer(
      height: SizeConfig.getSize38(context: context),
      width: SizeConfig.getSize38(context: context),
      color: isManu ? DynamicColor.white : DynamicColor.green,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RotatedBox(
          quarterTurns: 3,
          child: Image.asset(
            "assets/Phase 2 icons/ic_keyboard_arrow_down_24px.png",
            height: 30,
            width: 30,
            color: isManu == true ? DynamicColor.gredient1 : DynamicColor.white,
          ),
        ),
      ),
      onTap: () {},
    );
  }

  @override
  void dispose() {
    timer.cancel();
    _animationController.dispose();
    super.dispose();
  }
}
