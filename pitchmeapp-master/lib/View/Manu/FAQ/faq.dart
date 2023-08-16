import 'package:flutter/material.dart';
import 'package:pitch_me_app/utils/extras/extras.dart';
import 'package:pitch_me_app/utils/styles/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Phase 6/Guest UI/Profile/manu.dart';
import '../../../utils/colors/colors.dart';
import '../../../utils/sizeConfig/sizeConfig.dart';
import '../../../utils/strings/images.dart';
import '../../../utils/widgets/Navigation/custom_navigation.dart';
import '../../../utils/widgets/containers/containers.dart';
import '../../../utils/widgets/extras/backgroundWidget.dart';
import '../../Custom header view/appbar_with_white_bg.dart';
import '../../Custom header view/new_bottom_bar.dart';
import '../manu.dart';

class FQAPage extends StatefulWidget {
  int pageIndex;
  FQAPage({super.key, required this.pageIndex});

  @override
  State<FQAPage> createState() => _FQAPageState();
}

class _FQAPageState extends State<FQAPage> {
  String checkGuestType = '';

  int isCheck = 0;

  @override
  void initState() {
    checkGuest();
    super.initState();
  }

  void checkGuest() async {
    SharedPreferences preferencesData = await SharedPreferences.getInstance();
    setState(() {
      checkGuestType = preferencesData.getString('guest').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackGroundWidget(
        backgroundImage: Assets.backgroundImage,
        bannerRequired: false,
        fit: BoxFit.fill,
        child: Stack(
          // alignment: Alignment.center,
          children: [
            Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ClipPath(
                            clipper: CurveClipper(),
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: DynamicColor.gradientColorChange),
                              height:
                                  MediaQuery.of(context).size.height * 0.235,
                            ),
                          ),
                          whiteBorderContainer(
                              child: Image.asset(Assets.handshakeImage),
                              color: Colors.transparent,
                              height: SizeConfig.getSizeHeightBy(
                                  context: context, by: 0.12),
                              width: SizeConfig.getSizeHeightBy(
                                  context: context, by: 0.12),
                              cornerRadius: 25),
                        ],
                      ),
                    ],
                  ),
                ),
                listWidget(),
              ],
            ),
            CustomAppbarWithWhiteBg(
              title: 'FAQ',
              checkNext: 'back',
              onPressad: () {
                if (checkGuestType == 'null' && checkGuestType.isNotEmpty) {
                  PageNavigateScreen().push(
                      context,
                      GuestManuPage(
                        title: 'FAQ',
                        pageIndex: widget.pageIndex,
                      ));
                } else {
                  PageNavigateScreen().push(
                      context,
                      ManuPage(
                        title: 'FAQ',
                        pageIndex: widget.pageIndex,
                        isManu: 'Manu',
                      ));
                }
              },
            ),
            NewCustomBottomBar(
              index: widget.pageIndex,
              isBack: checkGuestType == 'null' ? 'Guest' : true,
            ),
          ],
        ),
      ),
    );
  }

  Widget listWidget() {
    return Expanded(
      flex: 3,
      child: SingleChildScrollView(
        child: Column(
          children: [
            whitebox(
              1,
              'Bla bla bla bla bla Bla bla bla bla bla',
              onTap: () {
                setState(() {
                  if (isCheck == 1) {
                    isCheck = 0;
                  } else {
                    isCheck = 1;
                  }
                });
              },
            ),
            isCheck != 1
                ? Container()
                : grayBox('Bla bla bla bla bla Bla bla bla bla bla'),
            whitebox(
              2,
              'Bla bla bla bla bla Bla bla bla bla bla',
              onTap: () {
                setState(() {
                  if (isCheck == 2) {
                    isCheck = 0;
                  } else {
                    isCheck = 2;
                  }
                });
              },
            ),
            isCheck != 2
                ? Container()
                : grayBox('Bla bla bla bla bla Bla bla bla bla bla'),
            whitebox(
              3,
              'Bla bla bla bla bla Bla bla bla bla bla',
              onTap: () {
                setState(() {
                  if (isCheck == 3) {
                    isCheck = 0;
                  } else {
                    isCheck = 3;
                  }
                });
              },
            ),
            isCheck != 3
                ? Container()
                : grayBox('Bla bla bla bla bla Bla bla bla bla bla'),
            whitebox(
              4,
              'Bla bla bla bla bla Bla bla bla bla bla',
              onTap: () {
                setState(() {
                  if (isCheck == 4) {
                    isCheck = 0;
                  } else {
                    isCheck = 4;
                  }
                });
              },
            ),
            isCheck != 4
                ? Container()
                : grayBox('Bla bla bla bla bla Bla bla bla bla bla'),
            whitebox(
              5,
              'Bla bla bla bla bla Bla bla bla bla bla',
              onTap: () {
                setState(() {
                  if (isCheck == 5) {
                    isCheck = 0;
                  } else {
                    isCheck = 5;
                  }
                });
              },
            ),
            isCheck != 5
                ? Container()
                : grayBox('Bla bla bla bla bla Bla bla bla bla bla'),
            whitebox(
              6,
              'Bla bla bla bla bla Bla bla bla bla bla',
              onTap: () {
                setState(() {
                  if (isCheck == 6) {
                    isCheck = 0;
                  } else {
                    isCheck = 6;
                  }
                });
              },
            ),
            isCheck != 6
                ? Container()
                : grayBox('Bla bla bla bla bla Bla bla bla bla bla'),
            whitebox(
              7,
              'Bla bla bla bla bla Bla bla bla bla bla',
              onTap: () {
                setState(() {
                  if (isCheck == 7) {
                    isCheck = 0;
                  } else {
                    isCheck = 7;
                  }
                });
              },
            ),
            isCheck != 7
                ? Container()
                : grayBox('Bla bla bla bla bla Bla bla bla bla bla'),
            spaceHeight(MediaQuery.of(context).size.height * 0.15),
          ],
        ),
      ),
    );
  }

  Widget whitebox(int isSelect, String title, {required VoidCallback onTap}) {
    return Padding(
      padding: EdgeInsets.only(
          top: 5,
          left: SizeConfig.getSize25(context: context),
          right: SizeConfig.getSize25(context: context)),
      child: Card(
        elevation: isCheck == isSelect ? 0 : 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          onTap: onTap,
          leading: isCheck != isSelect
              ? Icon(
                  Icons.add,
                  color: DynamicColor.gredient2,
                  size: 40,
                )
              : Icon(Icons.remove, color: DynamicColor.redColor, size: 40),
          title: Text(
            title,
            style: textColor12,
            maxLines: 1,
          ),
        ),
      ),
    );
  }

  Widget grayBox(title) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.getSize25(context: context),
          right: SizeConfig.getSize25(context: context)),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Color(0xffF0EBEB),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textColor12,
                    maxLines: 1,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'shisai',
                    style: textColor12,
                    maxLines: 1,
                  ),
                  SizedBox(height: 5),
                  Text(
                    '- ahhadshahj',
                    style: textColor12,
                    maxLines: 1,
                  ),
                  SizedBox(height: 5),
                  Text(
                    '- ahsaihsa laliipfdpidf',
                    style: textColor12,
                    maxLines: 1,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
