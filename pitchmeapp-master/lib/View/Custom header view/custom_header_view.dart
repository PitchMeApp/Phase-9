import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pitch_me_app/View/Feedback/feedback_detail.dart';
import 'package:pitch_me_app/View/Manu/manu.dart';
import 'package:pitch_me_app/View/Profile/Biography/biography.dart';
import 'package:pitch_me_app/screens/businessIdeas/Apicall.dart/noti.dart';
import 'package:pitch_me_app/screens/businessIdeas/home%20biography/home_page_biography.dart';
import 'package:pitch_me_app/utils/colors/colors.dart';
import 'package:pitch_me_app/utils/extras/extras.dart';
import 'package:pitch_me_app/utils/sizeConfig/sizeConfig.dart';
import 'package:pitch_me_app/utils/strings/strings.dart';
import 'package:pitch_me_app/utils/styles/styles.dart';
import 'package:pitch_me_app/utils/widgets/Navigation/custom_navigation.dart';
import 'package:pitch_me_app/utils/widgets/containers/containers.dart';
import 'package:provider/provider.dart';

import '../../screens/businessIdeas/home biography/Chat/Admin User/chat_list.dart';
import '../../utils/strings/images.dart';
import '../../utils/widgets/Arrow Button/back_arrow.dart';
import '../Profile/Pitches/pitches_list.dart';

class CustomHeaderView extends StatefulWidget {
  double progressPersent;

  VoidCallback? backOnTap;
  VoidCallback nextOnTap;
  dynamic checkNext;
  CustomHeaderView({
    super.key,
    required this.progressPersent,
    this.backOnTap,
    required this.nextOnTap,
    this.checkNext,
  });

  @override
  State<CustomHeaderView> createState() => _CustomHeaderViewState();
}

class _CustomHeaderViewState extends State<CustomHeaderView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _colorTween;

  Timer timer = Timer(Duration(seconds: 0), () {});
  bool _isInitialValue = false;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    _colorTween = ColorTween(begin: DynamicColor.blue, end: DynamicColor.blue
            //Colors.white.withOpacity(0.3)
            )
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.of(context).size.height;
    final sizeW = MediaQuery.of(context).size.width;
    return Container(
      child: Stack(
        children: [
          ClipPath(
            clipper: CurveClipper(),
            child: Container(
              decoration:
                  BoxDecoration(gradient: DynamicColor.gradientColorChange),
              height: MediaQuery.of(context).size.height * 0.27,
            ),
          ),
          Column(
            children: [
              iconsAndTitle(),
              iconAndProgressBar(),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                top: SizeConfig.getSize30(context: context) +
                    MediaQuery.of(context).size.height * 0.021,
                left: SizeConfig.getFontSize25(context: context),
                right: SizeConfig.getFontSize25(context: context)),
            child: Stack(
              children: [
                AnimatedBuilder(
                    animation: _colorTween,
                    builder: (context, child) {
                      return AnimatedContainer(
                        height: _isInitialValue
                            ? sizeH * 0.5
                            : SizeConfig.getSize38(context: context),
                        width: _isInitialValue
                            ? sizeW * 0.70
                            : SizeConfig.getSize38(context: context),
                        decoration: BoxDecoration(
                            borderRadius: _isInitialValue == false
                                ? BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10))
                                : BorderRadius.circular(20),
                            gradient: _isInitialValue == false
                                ? null
                                : DynamicColor.gradientColorChange,
                            color: _isInitialValue == false
                                ? DynamicColor.white
                                : null),
                        duration: Duration(milliseconds: 300),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isInitialValue = !_isInitialValue;
                            });
                          },
                          child: _isInitialValue
                              ? Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Consumer<DataClass>(builder:
                                      (BuildContext context, value,
                                          Widget? child) {
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: value.post!.result!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return value.loading
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  print(
                                                      "Click in notification");
                                                  setState(() {
                                                    _isInitialValue == true;
                                                    _isInitialValue = false;
                                                  });
                                                  if (value.post?.result![index]
                                                          .type ==
                                                      5) {
                                                    PageNavigateScreen().push(
                                                        context,
                                                        HomeBiographyPage(
                                                          type: 'Notification',
                                                          notifyID: value
                                                              .post!
                                                              .result![index]
                                                              .sId!,
                                                          userID: value
                                                              .post!
                                                              .result![index]
                                                              .senderID!,
                                                        ));
                                                  } else if (value
                                                          .post
                                                          ?.result![index]
                                                          .type ==
                                                      6) {
                                                    PageNavigateScreen().push(
                                                        context,
                                                        FeedbackPage(
                                                          type: 'home',
                                                          notifyID: value
                                                              .post!
                                                              .result![index]
                                                              .sId!,
                                                          data: value.post!
                                                              .result![index],
                                                        ));
                                                  } else if (value
                                                          .post
                                                          ?.result![index]
                                                          .type ==
                                                      7) {
                                                    PageNavigateScreen().push(
                                                        context,
                                                        PitchesListPage(
                                                            notifyID: value
                                                                .post!
                                                                .result![index]
                                                                .sId!));
                                                  } else if (value
                                                          .post
                                                          ?.result![index]
                                                          .type ==
                                                      8) {
                                                    PageNavigateScreen().push(
                                                        context,
                                                        BiographyPage(
                                                          type: '',
                                                          notifyID: value
                                                              .post!
                                                              .result![index]
                                                              .sId!,
                                                        ));
                                                  } else if (value
                                                          .post
                                                          ?.result![index]
                                                          .type ==
                                                      11) {
                                                    PageNavigateScreen().push(
                                                        context,
                                                        AdminUserChatListPage(
                                                          notifyID: value
                                                              .post!
                                                              .result![index]
                                                              .sId!,
                                                        ));
                                                  }
                                                },
                                                child: Container(
                                                  height: sizeH * 0.06,
                                                  width: sizeW * 0.65,
                                                  // color: Colors.red,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(children: [
                                                      Icon(
                                                          Icons
                                                              .notifications_active_outlined,
                                                          color: DynamicColor
                                                              .white),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: sizeW * 0.03,
                                                          // top: sizeH *
                                                          //     0.01
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              // height:
                                                              //     sizeH * 0.02,
                                                              width:
                                                                  sizeW * 0.50,
                                                              alignment: Alignment
                                                                  .centerLeft,

                                                              child: Text(
                                                                value
                                                                        .post
                                                                        ?.result?[
                                                                            index]
                                                                        .title
                                                                        .toString() ??
                                                                    "",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style: value
                                                                            .post
                                                                            ?.result?[
                                                                                index]
                                                                            .unreadFlag ==
                                                                        0
                                                                    ? TextStyle(
                                                                        color: DynamicColor
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold)
                                                                    : TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                              ),
                                                            ),
                                                            // Text(
                                                            //   value
                                                            //           .post
                                                            //           ?.result?[
                                                            //               index]
                                                            //           .text!
                                                            //           .toString() ??
                                                            //       "",
                                                            //   overflow:
                                                            //       TextOverflow
                                                            //           .ellipsis,
                                                            //   style: TextStyle(
                                                            //       color: Colors
                                                            //           .white,
                                                            //       fontWeight:
                                                            //           FontWeight
                                                            //               .bold,
                                                            //       fontSize: 10),
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
                                          padding: EdgeInsets.only(
                                              left: sizeW * 0.02,
                                              right: sizeW * 0.02),
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: loadSvg(
                                    image: 'assets/image/notifications.svg',
                                    color: DynamicColor.gredient1,
                                  ),
                                ),
                        ),
                      );
                    }),
                _isInitialValue == true
                    ? Container()
                    : Consumer<DataClass>(
                        builder: (BuildContext context, value, Widget? child) {
                        return Visibility(
                          visible: value.totalNotiCount == 0 ? false : true,
                          child: Container(
                            height: 20,
                            width: 20,
                            margin: const EdgeInsets.only(left: 35, bottom: 25),
                            padding: const EdgeInsets.only(left: 3, right: 3),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: DynamicColor.redColor,
                                borderRadius: BorderRadius.circular(50)),
                            child: FittedBox(
                              child: Text(
                                value.totalNotiCount.toString(),
                                style: TextStyle(color: DynamicColor.white),
                              ),
                            ),
                          ),
                        );
                      })
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget iconsAndTitle() {
    return Padding(
        padding: EdgeInsets.only(
            top: SizeConfig.getSize30(context: context) +
                MediaQuery.of(context).size.height * 0.021,
            left: SizeConfig.getFontSize25(context: context),
            right: SizeConfig.getFontSize25(context: context)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: SizeConfig.getSize38(context: context),
              width: SizeConfig.getSize38(context: context),
            ),
            Container(
              height: SizeConfig.getSize38(context: context),
              alignment: Alignment.center,
              child: Text(
                TextStrings.textKey['add_seles_pitch']!.toUpperCase(),
                style: white17wBold,
              ),
            ),
            AppBarIconContainer(
              onTap: () {
                PageNavigateScreen().push(
                    context,
                    ManuPage(
                      title: 'Add Sales Pitch',
                      pageIndex: 2,
                    ));
              },
              height: SizeConfig.getSize38(context: context),
              width: SizeConfig.getSize38(context: context),
              color: DynamicColor.white,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: loadSvg(
                    image: 'assets/image/menu.svg',
                    color: DynamicColor.gredient2),
              ),
            ),
          ],
        ));
  }

  Widget iconAndProgressBar() {
    return Padding(
      padding: EdgeInsets.only(
          top: 5,
          left: SizeConfig.getFontSize25(context: context),
          right: SizeConfig.getFontSize25(context: context)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        //alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.backOnTap == null
                  ? BackArrow(
                      alignment: Alignment.topLeft,
                      direction: 1,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  : BackArrow(
                      alignment: Alignment.topLeft,
                      direction: 1,
                      onPressed: () {}),
              widget.progressPersent == 0.0
                  ? Container(
                      height: 5,
                      width: MediaQuery.of(context).size.width - 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: DynamicColor.black),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            '${widget.progressPersent.toString().replaceAll('0.', '')}0%',
                            style: TextStyle(
                                fontSize: 12.0, color: DynamicColor.white),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width - 150,
                            lineHeight: 6.0,
                            percent: widget.progressPersent,
                            backgroundColor: DynamicColor.gredient1,
                            progressColor: DynamicColor.green,
                            barRadius: const Radius.circular(10),
                          ),
                        ),
                      ],
                    ),
              widget.checkNext == null
                  ? SizedBox(
                      height: SizeConfig.getSize38(context: context),
                      width: SizeConfig.getSize38(context: context),
                    )
                  : BackArrow(
                      alignment: Alignment.topRight,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      onPressed: widget.nextOnTap,
                    ),
            ],
          ),
          whiteBorderContainer(
              child: Image.asset(Assets.handshakeImage),
              color: Colors.transparent,
              height: SizeConfig.getSizeHeightBy(context: context, by: 0.11),
              width: SizeConfig.getSizeHeightBy(context: context, by: 0.11),
              cornerRadius: 25),
        ],
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
