import 'package:flutter/material.dart';
import 'package:pitch_me_app/View/posts/model.dart';
import 'package:pitch_me_app/screens/businessIdeas/home%20biography/home_page_biography.dart';
import 'package:pitch_me_app/utils/colors/colors.dart';
import 'package:pitch_me_app/utils/extras/extras.dart';
import 'package:pitch_me_app/utils/sizeConfig/sizeConfig.dart';
import 'package:pitch_me_app/utils/strings/images.dart';
import 'package:pitch_me_app/utils/widgets/Alert%20Box/show_image_popup.dart';
import 'package:pitch_me_app/utils/widgets/extras/backgroundWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/styles/styles.dart';
import '../../utils/widgets/Navigation/custom_navigation.dart';

class StatisticsPage_Two extends StatefulWidget {
  const StatisticsPage_Two({
    Key? key,
    required this.pagecont,
    required this.salesDoc,
  }) : super(key: key);
  final PageController pagecont;
  final SalesDoc salesDoc;

  @override
  State<StatisticsPage_Two> createState() => _StatisticsPage_TwoState();
}

class _StatisticsPage_TwoState extends State<StatisticsPage_Two> {
  List typeList = [];
  List serviceList = [];
  List serviceDetailList = [];
  List whocanwatchList = [];
  late SalesDoc salesDoc;

  String userType = '';

  @override
  void initState() {
    salesDoc = widget.salesDoc;

    var type = salesDoc.type.replaceAll('[', '').replaceAll(']', '');

    if (type.contains(' ')) {
      typeList = type.split(', ');
    } else {
      typeList = type.split(',');
    }
    if (typeList.isNotEmpty) {
      if (typeList.length > 1) {
        typeList.sort((a, b) => a.length.compareTo(b.length));
        typeList.removeAt(0);
      }
    }

    var service = salesDoc.services.replaceAll('[', '').replaceAll(']', '');
    if (service.isNotEmpty) {
      serviceList = service.split(', ');
    }
    var serviceDetail =
        salesDoc.servicesDetail.replaceAll('[', '').replaceAll(']', '');
    if (serviceDetail.isNotEmpty) {
      serviceDetailList = serviceDetail.split(', ');
    }
    var whoCanWatch =
        salesDoc.whocanwatch.replaceAll('[', '').replaceAll(']', '');
    if (whoCanWatch.isNotEmpty) {
      whocanwatchList = whoCanWatch.split(', ');
    }
    checkUserType();
    super.initState();
  }

  void checkUserType() {
    if (salesDoc.user.logType == 1) {
      userType = 'Business Idea';
    } else if (salesDoc.user.logType == 2) {
      userType = 'Business Owner';
    } else if (salesDoc.user.logType == 3) {
      userType = 'Investor';
    } else {
      userType = 'Facilitator';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackGroundWidget(
        backgroundImage: Assets.backgroundImage,
        fit: BoxFit.fill,
        child: Stack(
          children: [
            Column(
              children: [
                spaceHeight(SizeConfig.getSize60(context: context)),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              widget.pagecont.previousPage(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.linear);
                            },
                            child: Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: /* SvgPicture.asset(Assets.tiktokPreviousIco),*/
                                    RotatedBox(
                                  quarterTurns: 6,
                                  child: Image.asset(
                                    "assets/Phase 2 icons/ic_keyboard_arrow_down_24px.png",
                                    height:
                                        SizeConfig.getSize35(context: context),
                                    width:
                                        SizeConfig.getSize35(context: context),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Expanded(child: appStatistics(context: context)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget appStatistics({required BuildContext context}) {
    return SingleChildScrollView(
      child: Center(
          child: Column(
        children: [
          customWidget('What Industry', salesDoc.industry, onPressad: () {}),
          // customWidget(
          //     'assets/images/ic_place_24px-mdpi.png', salesDoc.location,
          //     onPressad: () {}),
          typeList.length > 0
              ? customWidget('Who is Needed', typeList[0].replaceAll(',', ''),
                  onPressad: () {})
              : Container(),
          salesDoc.valueamount.isNotEmpty
              ? customWidget('How much', salesDoc.valueamount, onPressad: () {})
              : Container(),
          typeList.length > 1 && typeList[1].isNotEmpty
              ? customWidget('Who is Needed', typeList[1], onPressad: () {})
              : Container(),
          serviceList.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  padding: EdgeInsets.zero,
                  itemCount: serviceList.length,
                  itemBuilder: (context, index) {
                    return customWidget("What is Needed", serviceList[index],
                        onPressad: () {});
                  })
              : Container(),
          serviceDetailList.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  padding: EdgeInsets.zero,
                  itemCount: serviceDetailList.length,
                  itemBuilder: (context, index) {
                    return customWidget(
                        "What is Needed", serviceDetailList[index],
                        onPressad: () {});
                  })
              : Container(),
          customWidget('Initial Offer', widget.salesDoc.description,
              onPressad: () {}),
          whocanwatchList.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  padding: EdgeInsets.zero,
                  itemCount: whocanwatchList.length,
                  itemBuilder: (context, index) {
                    return customWidget("Who can see", whocanwatchList[index],
                        onPressad: () {
                      //PageNavigateScreen().push(context, NeedPage());
                    });
                  })
              : Container(),
          customWidget('User Type', userType, onPressad: () {}),
          customWidget('Your Profile', 'Biography', onPressad: () {
            PageNavigateScreen().push(
                context,
                HomeBiographyPage(
                  type: 'Biography',
                  userID: salesDoc.userid,
                  notifyID: '',
                ));
          }),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: Wrap(
              runSpacing: 10,
              spacing: 10,
              children: [
                salesDoc.img1.isNotEmpty
                    ? imageWidget(salesDoc.img1)
                    : Container(
                        height: 0,
                        width: 0,
                      ),
                salesDoc.img2.isNotEmpty
                    ? imageWidget(salesDoc.img2)
                    : Container(
                        height: 0,
                        width: 0,
                      ),
                salesDoc.img3.isNotEmpty
                    ? imageWidget(salesDoc.img3)
                    : Container(
                        height: 0,
                        width: 0,
                      ),
                salesDoc.file.isNotEmpty
                    ? pdfWidget(salesDoc.file)
                    : Container(
                        height: 0,
                        width: 0,
                      ),
              ],
            ),
          ),
          spaceHeight(SizeConfig.getSize100(context: context)),
        ],
      )),
    );
  }

  Widget customWidget(title, name, {required VoidCallback onPressad}) {
    final sizeH = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: onPressad,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(title, style: black14w5),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: SizeConfig.getFontSize25(context: context),
              right: SizeConfig.getFontSize25(context: context),
            ),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                  height: sizeH * 0.068,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    left: 5,
                    right: 5,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: DynamicColor.gradientColorChange),
                  child: Text(
                    name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget imageWidget(url) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => ShowFullImagePopup(image_url: url));
      },
      child: Container(
        height: SizeConfig.getSizeHeightBy(context: context, by: 0.16),
        width: SizeConfig.getSizeWidthBy(context: context, by: 0.43),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image:
                DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)),
      ),
    );
  }

  Widget pdfWidget(url) {
    return InkWell(
      onTap: () {
        launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      },
      child: Container(
        height: SizeConfig.getSizeHeightBy(context: context, by: 0.16),
        width: SizeConfig.getSizeWidthBy(context: context, by: 0.43),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: const [Color(0xff5388C0), Color(0xff67C8B5)]),
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage('assets/images/pdf.png'))),
      ),
    );
  }
}
