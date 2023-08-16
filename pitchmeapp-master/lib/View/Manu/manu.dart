import 'package:flutter/material.dart';
import 'package:pitch_me_app/Phase%206/Guest%20UI/Guest%20limitation%20pages/under_progress_limitation.dart';
import 'package:pitch_me_app/View/Custom%20header%20view/appbar_with_white_bg.dart';
import 'package:pitch_me_app/View/Custom%20header%20view/new_bottom_bar.dart';
import 'package:pitch_me_app/View/Deals%20Page/deals_page.dart';
import 'package:pitch_me_app/View/Manu/FAQ/faq.dart';
import 'package:pitch_me_app/View/Manu/Tutorials/tutorials.dart';
import 'package:pitch_me_app/screens/businessIdeas/home%20biography/Chat/chat_list.dart';
import 'package:pitch_me_app/utils/colors/colors.dart';
import 'package:pitch_me_app/utils/sizeConfig/sizeConfig.dart';
import 'package:pitch_me_app/utils/strings/strings.dart';
import 'package:pitch_me_app/utils/widgets/Navigation/custom_navigation.dart';

import '../../utils/strings/images.dart';
import '../../utils/widgets/containers/containers.dart';
import '../../utils/widgets/extras/backgroundWidget.dart';

class ManuPage extends StatefulWidget {
  String title;
  int pageIndex;
  dynamic isManu;
  ManuPage(
      {super.key, required this.title, required this.pageIndex, this.isManu});

  @override
  State<ManuPage> createState() => _ManuPageState();
}

class _ManuPageState extends State<ManuPage> {
  int isSelect = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicColor.white,
      body: BackGroundWidget(
        backgroundImage: Assets.backgroundImage,
        bannerRequired: false,
        fit: BoxFit.fill,
        child: Stack(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipPath(
                  clipper: CurveClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: DynamicColor.gradientColorChange),
                    height: MediaQuery.of(context).size.height * 0.235,
                  ),
                ),
                whiteBorderContainer(
                    child: Image.asset(Assets.handshakeImage),
                    color: Colors.transparent,
                    height:
                        SizeConfig.getSizeHeightBy(context: context, by: 0.12),
                    width:
                        SizeConfig.getSizeHeightBy(context: context, by: 0.12),
                    cornerRadius: 25),
              ],
            ),
            _buildBodyView(),
            Column(
              children: [
                CustomAppbarWithWhiteBg(
                  title: widget.title,
                  checkNext: 'back',
                  isManuColor: 'check',
                  onPressad: () {},
                ),
              ],
            ),
            NewCustomBottomBar(
              index: widget.pageIndex,
              isBack: widget.isManu,
              isManuIcon: 'icon',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyView() {
    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.getSize15(context: context),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomListBox(
              title: TextStrings.textKey['tutorial']!,
              singleSelectColor: isSelect,
              isSingleSelect: 1,
              onPressad: () {
                setState(() {
                  isSelect = 1;
                });
                PageNavigateScreen().push(
                    context,
                    TutorialsPage(
                      pageIndex: widget.pageIndex,
                    ));
              }),
          CustomListBox(
              title: TextStrings.textKey['faq']!,
              singleSelectColor: isSelect,
              isSingleSelect: 2,
              onPressad: () {
                setState(() {
                  isSelect = 2;
                });
                PageNavigateScreen().push(
                    context,
                    FQAPage(
                      pageIndex: widget.pageIndex,
                    ));
              }),
          CustomListBox(
              title: TextStrings.textKey['advrise']!,
              singleSelectColor: isSelect,
              isSingleSelect: 3,
              onPressad: () {
                setState(() {
                  isSelect = 3;
                });
                PageNavigateScreen().push(context, UnderDevLimitationPage());
              }),
          CustomListBox(
              title: TextStrings.textKey['buy_pitch']!,
              singleSelectColor: isSelect,
              isSingleSelect: 4,
              onPressad: () {
                setState(() {
                  isSelect = 4;
                });
                PageNavigateScreen().push(context, UnderDevLimitationPage());
              }),
          CustomListBox(
              title: TextStrings.textKey['contact']!,
              singleSelectColor: isSelect,
              isSingleSelect: 5,
              onPressad: () {
                setState(() {
                  isSelect = 5;
                });
                PageNavigateScreen().push(context, ChatListPage());
              }),
        ],
      ),
    );
  }
}
