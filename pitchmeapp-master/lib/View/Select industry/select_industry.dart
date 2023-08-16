import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pitch_me_app/View/Demo%20Video/demo_video.dart';
import 'package:pitch_me_app/View/Location%20Page/location_page.dart';
import 'package:pitch_me_app/View/Select%20industry/industry_controller.dart';
import 'package:pitch_me_app/View/navigation_controller.dart';
import 'package:pitch_me_app/utils/sizeConfig/sizeConfig.dart';
import 'package:pitch_me_app/utils/strings/images.dart';
import 'package:pitch_me_app/utils/widgets/Navigation/custom_navigation.dart';
import 'package:pitch_me_app/utils/widgets/extras/backgroundWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Phase 6/Guest UI/Guest limitation pages/user_type_limitation.dart';
import '../../utils/colors/colors.dart';
import '../../utils/extras/extras.dart';
import '../../utils/strings/strings.dart';
import '../../utils/styles/styles.dart';
import '../Custom header view/custom_header_view.dart';
import '../Custom header view/new_bottom_bar.dart';
import '../Demo Video/title_tutorial.dart';

class SelectIndustryPage extends StatefulWidget {
  bool bottombarCheck;
  dynamic isCheck;
  SelectIndustryPage({
    super.key,
    required this.bottombarCheck,
    this.isCheck,
  });

  @override
  State<SelectIndustryPage> createState() => _SelectIndustryPageState();
}

class _SelectIndustryPageState extends State<SelectIndustryPage> {
  final scrollController = FixedExtentScrollController(initialItem: 5);

  final InsdustryController insdustryController =
      Get.put(InsdustryController());
  final NavigationController _navigationController =
      Get.put(NavigationController());

  GlobalKey<FormState> _abcKey = GlobalKey<FormState>();

  int chengeIndexColor = 5;
  bool isKeyboardOpen = false;
  bool isCheck = false;
  bool isCheckTutorial = false;
  bool playTutorial = false;
  bool isLoading = false;

  String checkGuestType = '';
  String businesstype = '';

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
      checkGuestType = preferencesData.getString('guest').toString();
      businesstype = preferencesData.getString('log_type').toString();
      if (preferencesData.getBool('addsalestutorial') != null) {
        playTutorial = preferencesData.getBool('addsalestutorial')!;
        isCheckTutorial = preferencesData.getBool('addsalestutorial')!;
        if (checkGuestType.isNotEmpty && checkGuestType != 'null') {
          if (businesstype == '3' || businesstype == '4') {
            setState(() {
              isCheck = preferencesData.getBool('addsalestutorial')!;
            });
          }
        }
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
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? CircularProgressIndicator(
              color: DynamicColor.gredient1,
            )
          : playTutorial == false
              ? TitleTutorialPage(
                  title: 'Add Sales Pitch',
                  pageIndex: 2,
                  isCheck: isCheckTutorial,
                  onPlay: () {
                    PageNavigateScreen()
                        .push(context, DemoVideoPage())
                        .then((value) {
                      setState(() {
                        _navigationController.navigationType.value = 'Post';
                        playTutorial = true;
                      });
                    });
                  },
                  onNext: () {
                    setState(() {
                      _navigationController.navigationType.value = 'Post';
                      playTutorial = true;
                    });
                    // PageNavigateScreen()
                    //     .pushRemovUntil(context, DemoVideoPage());
                  },
                  onCheck: (value) {
                    setState(() {
                      isCheckTutorial = value!;
                      checkDontShow(isCheckTutorial);
                    });
                  },
                )
              : businesstype == '3' || businesstype == '4'
                  ? UserTypeLimitationPage(
                      title1: 'Only Business Idea and',
                      title2: 'Business Owners users',
                      title3: 'can access this page.',
                    )
                  : BackGroundWidget(
                      backgroundImage: Assets.backgroundImage,
                      fit: BoxFit.fill,
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: SizeConfig.getSize100(
                                          context: context) +
                                      SizeConfig.getSize55(context: context),
                                ),
                                const SizedBox(height: 30),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: DynamicColor.black))),
                                  child: Text(
                                    TextStrings.textKey['industry']!,
                                    style: textColor22,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: Obx(() {
                                    return insdustryController
                                                .isLoading.value ==
                                            true
                                        ? Center(
                                            child: CircularProgressIndicator(
                                                color: DynamicColor.gredient1),
                                          )
                                        : insdustryController.industryList
                                                .result.docs.isEmpty
                                            ? Center(
                                                child: Text(
                                                    'No Industry Available'),
                                              )
                                            : ClickableListWheelScrollView(
                                                scrollController:
                                                    scrollController,
                                                itemHeight: 8,
                                                loop: true,
                                                itemCount: insdustryController
                                                    .industryList
                                                    .result
                                                    .docs
                                                    .length,
                                                onItemTapCallback: (index) {
                                                  setState(() {});
                                                  // log("onItemTapCallback index: $index");
                                                  // PageNavigateScreen().push(context, const LocationPage());
                                                },
                                                child: ListWheelScrollView
                                                    .useDelegate(
                                                  controller: scrollController,
                                                  diameterRatio: 1.5,
                                                  itemExtent: 25,
                                                  physics: isKeyboardOpen
                                                      ? NeverScrollableScrollPhysics()
                                                      : const FixedExtentScrollPhysics(),
                                                  overAndUnderCenterOpacity:
                                                      0.8,
                                                  perspective: 0.005,
                                                  offAxisFraction: 0,
                                                  onSelectedItemChanged:
                                                      (index) {
                                                    setState(() {
                                                      chengeIndexColor = index;
                                                      insdustryController
                                                              .selectedIndustry
                                                              .value =
                                                          insdustryController
                                                              .industryList
                                                              .result
                                                              .docs[index]
                                                              .name;
                                                    });
                                                  },
                                                  childDelegate:
                                                      ListWheelChildBuilderDelegate(
                                                    childCount:
                                                        insdustryController
                                                            .industryList
                                                            .result
                                                            .docs
                                                            .length,
                                                    builder: (context, index) {
                                                      if (chengeIndexColor ==
                                                          5) {
                                                        insdustryController
                                                                .selectedIndustry
                                                                .value =
                                                            insdustryController
                                                                .industryList
                                                                .result
                                                                .docs[5]
                                                                .name;
                                                      }

                                                      return Center(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              border: chengeIndexColor ==
                                                                      index
                                                                  ? Border(
                                                                      top: BorderSide(
                                                                          color: DynamicColor
                                                                              .gredient1),
                                                                      bottom: BorderSide(
                                                                          color:
                                                                              DynamicColor.gredient1))
                                                                  : null),
                                                          child: Text(
                                                            insdustryController
                                                                .industryList
                                                                .result
                                                                .docs[index]
                                                                .name,
                                                            style: chengeIndexColor ==
                                                                    index
                                                                ? gredient122bold
                                                                : textColor15,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                  }),
                                ),
                                Text('Can’t find your Industry? Add yours!',
                                    style: textColor12),
                                searchBar(),
                                isKeyboardOpen
                                    ? SizedBox(
                                        height: SizeConfig.getSize100(
                                                context: context) +
                                            SizeConfig.getSize100(
                                                context: context) +
                                            SizeConfig.getSize100(
                                                context: context),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          CustomHeaderView(
                            progressPersent: 0.1,
                            checkNext: 'next',
                            backOnTap: () {},
                            nextOnTap: () {
                              if (insdustryController
                                  .industryList.result.docs.isNotEmpty) {
                                if (widget.isCheck != null) {
                                  _navigationController.navigationType.value =
                                      'Post';
                                }
                                if (_navigationController
                                        .navigationType.value ==
                                    'Post') {
                                  PageNavigateScreen().push(
                                      context,
                                      LocationPage(
                                        key: _abcKey,
                                      ));
                                } else {
                                  Navigator.of(context).pop();
                                }
                              }
                            },
                          ),
                          widget.bottombarCheck
                              ? NewCustomBottomBar(
                                  index: 2,
                                  isBack: true,
                                )
                              : Container(
                                  height: 0,
                                  width: 0,
                                ),
                        ],
                      ),
                    ),
    );
  }

  Widget searchBar() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        child: Column(
          children: [
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width - 95,
                child: TextFormField(
                  cursorHeight: 22,
                  controller: insdustryController.textController,
                  style: gredient116bold,
                  onTap: () {
                    setState(() {
                      isKeyboardOpen = true;
                    });
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {
                      isKeyboardOpen = false;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      insdustryController.hideList.value = false;
                    });
                  },
                  decoration: InputDecoration(
                      hintText: 'Type',
                      hintStyle: TextStyle(
                          fontSize: 15, color: DynamicColor.lightGrey),
                      contentPadding: const EdgeInsets.only(
                        left: 10,
                      ),
                      border: InputBorder.none,
                      enabledBorder: outlineInputBorderBlue,
                      focusedBorder: outlineInputBorderBlue,
                      errorBorder: outlineInputBorderBlue,
                      focusedErrorBorder: outlineInputBorderBlue,
                      suffixIcon: insdustryController
                              .textController.text.isEmpty
                          ? null
                          : InkWell(
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());

                                if (insdustryController
                                    .textController.text.isNotEmpty) {
                                  var check = '';
                                  var s = insdustryController
                                      .textController.text
                                      .trim();
                                  for (var item in insdustryController
                                      .industryList.result.docs) {
                                    if (item.name == s) {
                                      check = 'yes';
                                    }
                                  }

                                  if (check.isEmpty) {
                                    insdustryController.postIndustryApiCall(
                                        insdustryController
                                            .textController.text);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'Already available',
                                        gravity: ToastGravity.CENTER);
                                  }
                                }
                                setState(() {
                                  isKeyboardOpen = false;
                                  insdustryController.textController.text = '';
                                });
                              },
                              child: Icon(
                                Icons.add,
                                color: DynamicColor.green,
                                size: 45,
                              ),
                            )),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              // width: MediaQuery.of(context).size.width - 80,
              // padding: EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  runAlignment: WrapAlignment.start,
                  runSpacing: 5.0,
                  children: List.generate(
                      insdustryController.searchingSelectedItems.value.length,
                      (index) {
                    dynamic data =
                        insdustryController.searchingSelectedItems.value[index];
                    return Container(
                      height: 45,
                      //  padding: EdgeInsets.only(left: 10, right: 10),
                      margin: EdgeInsets.only(right: 5, left: 15),
                      child: Card(
                        elevation: 10,
                        child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          //margin: EdgeInsets.only(right: 5, left: 15),
                          decoration: BoxDecoration(
                            gradient: DynamicColor.gradientColorChange,
                          ),
                          child: Wrap(
                            // alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runAlignment: WrapAlignment.center,
                            children: [
                              Text(
                                data,
                                style: white13TextStyle,
                              ),
                              SizedBox(width: 5),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    insdustryController
                                        .searchingSelectedItems.value
                                        .remove(data);
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  color: DynamicColor.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
            )
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
