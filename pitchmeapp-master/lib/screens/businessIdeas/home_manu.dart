import 'package:flutter/material.dart';
import 'package:pitch_me_app/Phase%206/Guest%20UI/Guest%20limitation%20pages/under_progress_limitation.dart';
import 'package:pitch_me_app/View/Deals%20Page/deals_page.dart';
import 'package:pitch_me_app/View/Manu/FAQ/faq.dart';
import 'package:pitch_me_app/View/Manu/Tutorials/tutorials.dart';
import 'package:pitch_me_app/utils/strings/strings.dart';
import 'package:pitch_me_app/utils/widgets/Navigation/custom_navigation.dart';

import '../../utils/colors/colors.dart';
import '../../utils/sizeConfig/sizeConfig.dart';
import '../../utils/strings/images.dart';
import '../../utils/widgets/containers/containers.dart';
import '../../utils/widgets/extras/backgroundWidget.dart';
import 'home biography/Chat/chat_list.dart';

class HomeManuPage extends StatefulWidget {
  int pageIndex;
  HomeManuPage({super.key, required this.pageIndex});

  @override
  State<HomeManuPage> createState() => _HomeManuPageState();
}

class _HomeManuPageState extends State<HomeManuPage> {
  int isSelect = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: DynamicColor.white,
      body: _buildBodyView(),
    );
  }

  Widget _buildBodyView() {
    return BackGroundWidget(
      backgroundImage: Assets.backgroundImage,
      fit: BoxFit.cover,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipPath(
                clipper: CurveClipper(),
                child: Container(
                  decoration:
                      BoxDecoration(gradient: DynamicColor.gradientColorChange),
                  height: MediaQuery.of(context).size.height * 0.27,
                ),
              ),
              whiteBorderContainer(
                  child: Image.asset(Assets.handshakeImage),
                  color: Colors.transparent,
                  height:
                      SizeConfig.getSizeHeightBy(context: context, by: 0.12),
                  width: SizeConfig.getSizeHeightBy(context: context, by: 0.12),
                  cornerRadius: 25)
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Column(
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
                    PageNavigateScreen()
                        .push(context, UnderDevLimitationPage());
                  }),
              CustomListBox(
                  title: TextStrings.textKey['buy_pitch']!,
                  singleSelectColor: isSelect,
                  isSingleSelect: 4,
                  onPressad: () {
                    setState(() {
                      isSelect = 4;
                    });
                    PageNavigateScreen()
                        .push(context, UnderDevLimitationPage());
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
          )
        ],
      ),
    );
  }
}
