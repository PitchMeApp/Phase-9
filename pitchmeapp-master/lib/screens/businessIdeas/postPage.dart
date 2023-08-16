import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitch_me_app/View/posts/model.dart';
import 'package:pitch_me_app/controller/businessIdeas/postPageController.dart';
import 'package:pitch_me_app/screens/businessIdeas/feedbackscreen.dart';
import 'package:pitch_me_app/screens/businessIdeas/interestedSwipe.dart';
import 'package:pitch_me_app/utils/sizeConfig/sizeConfig.dart';
import 'package:pitch_me_app/utils/styles/styles.dart';
import 'package:pitch_me_app/utils/widgets/Arrow%20Button/back_arrow.dart';
import 'package:pitch_me_app/utils/widgets/Navigation/custom_navigation.dart';
import 'package:pitch_me_app/utils/widgets/extras/directVideoViewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:video_viewer/video_viewer.dart';

import '../../utils/colors/colors.dart';
import '../../utils/widgets/containers/containers.dart';

class PostPageWidget extends StatefulWidget {
  const PostPageWidget({
    Key? key,
    required this.controller,
    required this.onSwipe,
    required this.postModel,
  }) : super(key: key);
  final PageController controller;
  final Function(int index, String title, bool isFinish) onSwipe;
  final SalesPitchListModel postModel;

  @override
  State<PostPageWidget> createState() => _PostPageWidgetState();
}

class _PostPageWidgetState extends State<PostPageWidget>
    with AutomaticKeepAliveClientMixin<PostPageWidget>, WidgetsBindingObserver {
  void _listenController() => setState(() {});
  PostPageController controller = Get.put(PostPageController());
  var directionn;
  String checkGuestType = '';
  String businesstype = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkGuest();

    controller.swipableStackController.addListener(_listenController);
    videoViewerControllerList.clear();

    videoViewerControllerList.addAll(List.generate(
        widget.postModel.result.docs.length,
        (index) => VideoViewerController()));
  }

  void checkGuest() async {
    SharedPreferences preferencesData = await SharedPreferences.getInstance();
    setState(() {
      checkGuestType = preferencesData.getString('guest').toString();
      businesstype = preferencesData.getString('log_type').toString();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.of(context).size.height;
    final sizeW = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned.fill(
          child: SwipableStack(
            swipeAssistDuration: Duration.zero,
            swipeAnchor: SwipeAnchor.bottom,
            dragStartDuration: Duration.zero,
            stackClipBehaviour: Clip.hardEdge,

            detectableSwipeDirections: const {
              SwipeDirection.right,
              SwipeDirection.left,
            },
            allowVerticalSwipe: false,
            controller: controller.swipableStackController,
            // stackClipBehaviour: Clip.hardEdge,
            onSwipeCompleted: (index, direction) {
              print("left123direction $index");

              if (direction == SwipeDirection.left) {
                controller.left.value = !controller.left.value;
              }
              if (direction == SwipeDirection.right) {
                controller.right.value = !controller.right.value;
              }
              if (!mounted) {
                return;
              }
              setState(() {
                directionn = direction;
                controller.updateProgressOfCard(0.0);
                controller.updateDirectionOfCard(null);
              });
              print('index is $index, direction is $direction');
              controller.label =
                  direction == SwipeDirection.right ? 'Saved' : 'Seen';

              if (direction == SwipeDirection.right) {
                PageNavigateScreen()
                    .push(
                        context,
                        interestedSwipe(
                          userID: widget.postModel.result.docs[index].userid,
                        ))
                    .then((value) {
                  setState(() {
                    if (widget.postModel.result.docs.isEmpty) {
                      widget.onSwipe(index, "", true);
                    } else {
                      widget.onSwipe(
                          index + 1,
                          widget.postModel.result.docs[index + 1].title
                              .toString(),
                          false);
                      // widget.postModel.result.docs[index + 1];
                    }
                  });
                });
                controller.savedVideo(widget.postModel.result.docs[index].id,
                    widget.postModel.result.docs[index].userid);
              } else {
                PageNavigateScreen()
                    .push(
                        context,
                        ratingScreen(
                          receiverid:
                              widget.postModel.result.docs[index].userid,
                          postid: widget.postModel.result.docs[index].id,
                        ))
                    .then((value) {
                  setState(() {
                    if (widget.postModel.result.docs.isEmpty) {
                      widget.onSwipe(index, "", true);
                    } else {
                      widget.onSwipe(
                          index + 1,
                          widget.postModel.result.docs[index + 1].title
                              .toString(),
                          false);
                      // widget.postModel.result.docs[index + 1];
                    }
                  });
                });
              }

              controller.setVisibleSeen(true);
              Future.delayed(Duration(milliseconds: 200)).then((value) {
                controller.setVisibleSeen(false);
              });
              //SEND INDEX AND TITLE
              //}
              // if (index != widget.postModel.result.docs.length) {
              //   widget.onSwipe(
              //       index + 1,
              //       widget.postModel.result.docs[index + 1].title.toString(),
              //       false);
              // } else {
              //   widget.onSwipe(index, "", true);
              // }
              if (index == widget.postModel.result.docs.length) {
                widget.onSwipe(index, "", true);
              }

              if (directionn == SwipeDirection.left &&
                  controller.left.value == true) {
                controller.swipableStackController.rewind();
              }
              if (directionn == SwipeDirection.right &&
                  controller.right.value == true) {
                controller.swipableStackController.rewind();
              }

              if (widget.postModel.result.docs[index].status == 2 &&
                  videoViewerControllerList[index].isPlaying) {
                videoViewerControllerList[index].pause();
                if (!mounted) {
                  return;
                }
                setState(() {});
              }
              controller.refreshed.value = false;
            },
            horizontalSwipeThreshold: 0.8,
            verticalSwipeThreshold: 0.8,

            itemCount: widget.postModel.result.docs.length,
            builder: (context, properties) {
              final itemIndex =
                  properties.index % widget.postModel.result.docs.length;

              if (mounted) {
                controller.updateProgressOfCard(properties.swipeProgress);
                controller.updateDirectionOfCard(properties.direction);
              }

              return Stack(
                children: [
                  controller.getSliderWidget2(
                      post: widget.postModel.result.docs[itemIndex],
                      context: context,
                      itemIndex: itemIndex),
                ],
              );
            },
          ),
        ),
        Align(
            alignment: Alignment.center,
            child: controller.progressOfCard.value.toStringAsFixed(2) == "0.00"
                ? SizedBox()
                : AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: controller.progressOfCard.value * 15,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.4,
                      color: Colors.white,
                      height: 1,
                    ),
                    child: Text(
                      controller.direction == null
                          ? ''
                          : controller.direction == SwipeDirection.left
                              ? 'Not interested'
                              : 'Interested',
                    ),
                  )),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Business details', style: gredient116bold),
            Align(
              alignment: Alignment.bottomCenter,
              child: widget.postModel.result.docs[0].id
                      .contains('6448e9494ff8f4cb69599465')
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        widget.postModel.result.docs[0].id
                                .contains('6448e9494ff8f4cb69599465')
                            ? null
                            : widget.controller.nextPage(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.linear);
                      },
                      child: Container(
                        height: SizeConfig.getSize35(context: context),
                        width: SizeConfig.getSize35(context: context),
                        margin: EdgeInsets.only(
                            top: 5,
                            bottom: SizeConfig.getSize60(context: context) +
                                SizeConfig.getSize15(context: context)),
                        child: Image.asset(
                          "assets/Phase 2 icons/ic_keyboard_arrow_down_24px.png",
                        ),
                      ),
                    ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
              top: SizeConfig.getSize30(context: context) +
                  SizeConfig.getSize55(context: context) +
                  SizeConfig.getSize5(context: context),
              left: SizeConfig.getFontSize25(context: context),
              right: SizeConfig.getFontSize25(context: context)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.postModel.result.docs[0].id
                      .contains('6448e9494ff8f4cb69599465')
                  ? Container()
                  : Align(
                      alignment: Alignment.topLeft,
                      child: AppBarIconContainer(
                        height: SizeConfig.getSize38(context: context),
                        width: SizeConfig.getSize38(context: context),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: Image.asset(
                              "assets/Phase 2 icons/ic_keyboard_arrow_down_24px.png",
                              height: 30,
                              width: 30,
                              color: DynamicColor.white,
                            ),
                          ),
                        ),
                        onTap: () {
                          controller.swipableStackController
                              .next(swipeDirection: SwipeDirection.left);
                        },
                      ),
                    ),
              // BackArrow(
              //   alignment: Alignment.topLeft,
              //   direction: 1,
              //   onPressed: () {
              //     controller.swipableStackController
              //         .next(swipeDirection: SwipeDirection.right);
              //   },
              // ),
              BackArrow(
                alignment: Alignment.topRight,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                direction: 3,
                onPressed: () {
                  controller.swipableStackController
                      .next(swipeDirection: SwipeDirection.right);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // went to Background
      controller.appIsInBackground.value = true;
    }
    if (state == AppLifecycleState.resumed) {
      debugPrint(
          "App is resumed and visibility is ${controller.videoVisibilityPercent.value}");
      controller.appIsInBackground.value = false;
      setState(() {});
    }
  }
}
