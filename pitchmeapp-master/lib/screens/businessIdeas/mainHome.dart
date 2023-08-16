import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitch_me_app/Phase%206/Guest%20UI/Guest%20limitation%20pages/login_limitation.dart';
import 'package:pitch_me_app/Phase%206/Guest%20UI/Profile/manu.dart';
import 'package:pitch_me_app/View/Feedback/feedback_detail.dart';
import 'package:pitch_me_app/screens/businessIdeas/Apicall.dart/noti.dart';
import 'package:pitch_me_app/screens/businessIdeas/dashBoardScreen.dart';
import 'package:pitch_me_app/screens/businessIdeas/home%20biography/Chat/Admin%20User/chat_list.dart';
import 'package:pitch_me_app/screens/businessIdeas/home%20biography/home_page_biography.dart';
import 'package:pitch_me_app/screens/businessIdeas/home%20tutorial/home_tutorial.dart';
import 'package:pitch_me_app/screens/businessIdeas/home_filter.dart';
import 'package:pitch_me_app/screens/businessIdeas/home_manu.dart';
import 'package:pitch_me_app/utils/colors/colors.dart';
import 'package:pitch_me_app/utils/extras/extras.dart';
import 'package:pitch_me_app/utils/sizeConfig/sizeConfig.dart';
import 'package:pitch_me_app/utils/widgets/Navigation/custom_navigation.dart';
import 'package:pitch_me_app/utils/widgets/containers/containers.dart';
import 'package:pitch_me_app/utils/widgets/text/text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../View/Demo Video/title_tutorial.dart';
import '../../View/Profile/Biography/biography.dart';
import '../../View/Profile/Pitches/pitches_list.dart';
import '../../utils/styles/styles.dart';

class MainHomeScreen extends StatefulWidget {
  MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _colorTween;

  String title = '';
  int currentIndexOfDashboard = 0;
  //int totalNotiCount = 0;
  late Widget currentScreen;

  int selectIndex = 0;

  Timer timer = Timer(Duration(seconds: 0), () {});

  bool colorChnage = false;

  String newUser = '';
  String businesstype = '';

  bool isCheck = false;
  bool isCheckTutorial = false;
  bool playTutorial = false;
  bool isLoading = false;

  @override
  void initState() {
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
    Future.delayed(Duration(seconds: 4), () {
      //  setState(() {
      selectIndex;

      //  });
      timer = Timer.periodic(Duration(seconds: 3), (timer) {
        final postModel = Provider.of<DataClass>(context, listen: false);
        postModel.getPostData();
      });
    });

    super.initState();
    currentScreen = DashBoardScreen(
      currentPage: (int index) {
        currentIndexOfDashboard = index;
        setState(() {});
      },
      onSwipe: (int index, String _title, bool isFinish) {
        print("index is $index and title is $title");
        title = _title;
        //setState(() {});
      },
    );
    //setState(() {});
  }

  bool _isInitialValue = false;
  bool isFilter = false;
  bool isManu = false;

  String checkGuestType = '';
  int swipeCount = 0;

  getUserType() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    setState(() {
      checkGuestType = prefs.getString('guest').toString();
      if (prefs.getBool('hometutorial') != null) {
        playTutorial = prefs.getBool('hometutorial')!;
        isCheckTutorial = prefs.getBool('hometutorial')!;
      }
      isLoading = false;
    });
  }

  void checkDontShow(bool check) async {
    SharedPreferences preferencesData = await SharedPreferences.getInstance();
    setState(() {
      preferencesData.setBool('hometutorial', check).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.of(context).size.height;
    final sizeW = MediaQuery.of(context).size.width;
    return Material(
      child: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          body: isLoading
              ? CircularProgressIndicator(
                  color: DynamicColor.gredient1,
                )
              : playTutorial == false
                  ? TitleTutorialPage(
                      title: 'Home',
                      pageIndex: 0,
                      isCheck: isCheckTutorial,
                      onPlay: () {
                        PageNavigateScreen()
                            .push(context, HomeTutorialPage())
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
                  : Stack(
                      children: [
                        InkWell(
                            onTap: () {
                              setState(() {
                                _isInitialValue == true;
                                _isInitialValue = false;
                              });
                            },
                            child: isManu
                                ? checkGuestType.isNotEmpty &&
                                        checkGuestType != 'null'
                                    ? HomeManuPage(
                                        pageIndex: 0,
                                      )
                                    : GuestManuPage(title: '', pageIndex: 0)
                                : isFilter
                                    ? HomePageFilter()
                                    : currentScreen),
                        Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.getSize50(context: context)),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              child: isManu
                                  ? Text(
                                      'MENU',
                                      style: white17wBold,
                                    )
                                  : isFilter
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0),
                                          child: Text(
                                            'FILTER',
                                            style: white17wBold,
                                          ))
                                      : roboto(
                                          size: SizeConfig.getFontSize25(
                                              context: context),
                                          text: currentIndexOfDashboard == 0
                                              ? ''
                                              : "App Statistics",
                                          fontWeight: FontWeight.w700,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.getSize30(context: context) +
                                  MediaQuery.of(context).size.height * 0.021,
                              bottom: SizeConfig.getSize20(context: context),
                              left: SizeConfig.getFontSize25(context: context),
                              right:
                                  SizeConfig.getFontSize25(context: context)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              currentIndexOfDashboard == 0
                                  ? Stack(
                                      children: [
                                        AnimatedBuilder(
                                            animation: _colorTween,
                                            builder: (context, child) {
                                              return AnimatedContainer(
                                                height: _isInitialValue
                                                    ? sizeH * 0.5
                                                    : SizeConfig.getSize38(
                                                        context: context),
                                                width: _isInitialValue
                                                    ? sizeW * 0.70
                                                    : SizeConfig.getSize38(
                                                        context: context),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        _isInitialValue == false
                                                            ? BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10))
                                                            : BorderRadius
                                                                .circular(10),
                                                    gradient: isManu || isFilter
                                                        ? _isInitialValue
                                                            ? DynamicColor
                                                                .gradientColorChange
                                                            : null
                                                        : DynamicColor
                                                            .gradientColorChange,
                                                    color: isManu || isFilter
                                                        ? _isInitialValue
                                                            ? null
                                                            : DynamicColor.white
                                                        : null
                                                    //  _isInitialValue
                                                    //     ? Color(0xff377eb4)
                                                    //     : _colorTween.value,
                                                    ),
                                                duration:
                                                    Duration(milliseconds: 300),
                                                child: InkWell(
                                                  onTap: () {
                                                    if (checkGuestType
                                                            .isNotEmpty &&
                                                        checkGuestType !=
                                                            'null') {
                                                      setState(() {
                                                        _isInitialValue =
                                                            !_isInitialValue;
                                                      });
                                                    } else {
                                                      Get.to(() =>
                                                          LoginLimitationPage());
                                                    }
                                                  },
                                                  child: _isInitialValue
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12.0),
                                                          child: Consumer<
                                                                  DataClass>(
                                                              builder: (BuildContext
                                                                      context,
                                                                  value,
                                                                  Widget?
                                                                      child) {
                                                            return ListView
                                                                .separated(
                                                              shrinkWrap: true,
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              itemCount: value
                                                                  .post!
                                                                  .result!
                                                                  .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                return value
                                                                        .loading
                                                                    ? Center(
                                                                        child:
                                                                            CircularProgressIndicator(),
                                                                      )
                                                                    : InkWell(
                                                                        onTap:
                                                                            () {
                                                                          print(
                                                                              "Click in notification");
                                                                          setState(
                                                                              () {
                                                                            _isInitialValue ==
                                                                                true;
                                                                            _isInitialValue =
                                                                                false;
                                                                          });
                                                                          if (value.post?.result![index].type ==
                                                                              5) {
                                                                            PageNavigateScreen().push(
                                                                                context,
                                                                                HomeBiographyPage(
                                                                                  type: 'Notification',
                                                                                  notifyID: value.post!.result![index].sId!,
                                                                                  userID: value.post!.result![index].senderID!,
                                                                                ));
                                                                          } else if (value.post?.result![index].type ==
                                                                              6) {
                                                                            PageNavigateScreen().push(
                                                                                context,
                                                                                FeedbackPage(
                                                                                  type: 'home',
                                                                                  notifyID: value.post!.result![index].sId!,
                                                                                  data: value.post!.result![index],
                                                                                ));
                                                                          } else if (value.post?.result![index].type ==
                                                                              7) {
                                                                            PageNavigateScreen().push(context,
                                                                                PitchesListPage(notifyID: value.post!.result![index].sId!));
                                                                          } else if (value.post?.result![index].type ==
                                                                              8) {
                                                                            PageNavigateScreen().push(
                                                                                context,
                                                                                BiographyPage(
                                                                                  type: '',
                                                                                  notifyID: value.post!.result![index].sId!,
                                                                                ));
                                                                          } else if (value.post?.result![index].type ==
                                                                              11) {
                                                                            PageNavigateScreen().push(
                                                                                context,
                                                                                AdminUserChatListPage(
                                                                                  notifyID: value.post!.result![index].sId!,
                                                                                ));
                                                                          }
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              sizeH * 0.06,
                                                                          width:
                                                                              sizeW * 0.65,
                                                                          // color: Colors.red,
                                                                          child:
                                                                              SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child:
                                                                                Row(children: [
                                                                              Icon(Icons.notifications_active_outlined, color: DynamicColor.white),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(
                                                                                  left: sizeW * 0.03,
                                                                                  // top: sizeH * 0.01,
                                                                                ),
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Container(
                                                                                      // height: sizeH * 0.02,
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
                                                                                    //   value.post?.result?[index].text!.toString() ?? "",
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
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                return Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: sizeW *
                                                                          0.02,
                                                                      right: sizeW *
                                                                          0.02),
                                                                  child:
                                                                      Divider(
                                                                    height: 2,
                                                                    color: DynamicColor
                                                                        .white,
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          }),
                                                        )
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: loadSvg(
                                                              image:
                                                                  'assets/image/notifications.svg',
                                                              color: isManu ||
                                                                      isFilter
                                                                  ? DynamicColor
                                                                      .gredient1
                                                                  : null),
                                                        ),
                                                ),
                                              );
                                            }),
                                        _isInitialValue == false
                                            ? Consumer<DataClass>(builder:
                                                (BuildContext context, value,
                                                    Widget? child) {
                                                return Visibility(
                                                  visible:
                                                      value.totalNotiCount == 0
                                                          ? false
                                                          : true,
                                                  child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 35,
                                                            bottom: 25),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 3, right: 3),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: DynamicColor
                                                            .redColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
                                                    child: FittedBox(
                                                      child: Text(
                                                        value.totalNotiCount
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
                              Column(
                                children: [
                                  currentIndexOfDashboard == 0
                                      ? AppBarIconContainer(
                                          height: SizeConfig.getSize38(
                                              context: context),
                                          width: SizeConfig.getSize38(
                                              context: context),
                                          color: isManu || isFilter
                                              ? DynamicColor.white
                                              : null,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: loadSvg(
                                                image: 'assets/image/menu.svg',
                                                color: isManu
                                                    ? DynamicColor.darkBlue
                                                    : isFilter
                                                        ? DynamicColor.gredient2
                                                        : null),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              isManu = !isManu;
                                              isFilter = false;
                                            });
                                          },
                                        )
                                      : Container(),
                                  spaceHeight(5),
                                  if (currentIndexOfDashboard == 0)
                                    Align(
                                        alignment: Alignment.bottomRight,
                                        child: AppBarIconContainer(
                                          height: SizeConfig.getSize38(
                                              context: context),
                                          width: SizeConfig.getSize38(
                                              context: context),
                                          color: isManu || isFilter
                                              ? DynamicColor.white
                                              : null,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: loadSvg(
                                                image:
                                                    'assets/image/setting.svg',
                                                color: isFilter == true
                                                    ? DynamicColor.darkBlue
                                                    : isManu
                                                        ? DynamicColor.gredient2
                                                        : null),
                                          ),
                                          onTap: () {
                                            if (checkGuestType.isNotEmpty &&
                                                checkGuestType != 'null') {
                                              setState(() {
                                                isFilter = !isFilter;
                                                isManu = false;
                                              });
                                            } else {
                                              Get.to(
                                                  () => LoginLimitationPage());
                                            }
                                          },
                                        )),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    _animationController.dispose();
    super.dispose();
  }
}
