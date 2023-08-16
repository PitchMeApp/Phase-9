import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitch_me_app/View/Custom%20header%20view/appbar_with_white_bg.dart';
import 'package:pitch_me_app/View/Custom%20header%20view/new_bottom_bar.dart';
import 'package:pitch_me_app/View/Manu/manu.dart';
import 'package:pitch_me_app/View/Profile/Pitches/controller.dart';
import 'package:pitch_me_app/View/Profile/Pitches/detail_page.dart';
import 'package:pitch_me_app/View/Profile/Pitches/model.dart';
import 'package:pitch_me_app/utils/colors/colors.dart';
import 'package:pitch_me_app/utils/sizeConfig/sizeConfig.dart';
import 'package:pitch_me_app/utils/styles/styles.dart';
import 'package:pitch_me_app/utils/widgets/Alert%20Box/delete_sales_post.dart';
import 'package:pitch_me_app/utils/widgets/Navigation/custom_navigation.dart';

import '../../../utils/extras/extras.dart';
import '../../../utils/strings/images.dart';
import '../../../utils/widgets/containers/containers.dart';
import '../../../utils/widgets/extras/backgroundWidget.dart';
import '../../Feedback/controller.dart';

class PitchesListPage extends StatefulWidget {
  String notifyID;
  PitchesListPage({super.key, required this.notifyID});

  @override
  State<PitchesListPage> createState() => _PitchesListPageState();
}

class _PitchesListPageState extends State<PitchesListPage> {
  // late VideoPlayerController _videoPlayerController;

  PitcheController controller = Get.put(PitcheController());
  FeebackController feebackController = Get.put(FeebackController());

  @override
  void initState() {
    if (widget.notifyID.isNotEmpty) {
      feebackController.readAllNotiApi(widget.notifyID);
    }

    super.initState();
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
                _postListWidget(),
              ],
            ),
            CustomAppbarWithWhiteBg(
              title: 'Pitches',
              checkNext: 'back',
              onPressad: () {
                PageNavigateScreen().push(
                    context,
                    ManuPage(
                      title: 'Pitches',
                      pageIndex: 4,
                      isManu: 'Manu',
                    ));
              },
            ),
            NewCustomBottomBar(
              index: 4,
              isBack: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _postListWidget() {
    return Expanded(
      flex: 3,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.getSize15(context: context),
                  right: SizeConfig.getSize15(context: context)),
              child: FutureBuilder<SavedListModel>(
                  future: controller.getUserData(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.getSize100(context: context) +
                                  SizeConfig.getSize50(context: context)),
                          child: const Center(
                              child: CircularProgressIndicator(
                            color: DynamicColor.gredient1,
                          )),
                        );
                      default:
                        if (snapshot.hasError) {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.getSize100(context: context) +
                                    SizeConfig.getSize50(context: context)),
                            child: const Center(
                                child: Text('No pitches available')),
                          );
                        } else if (snapshot.data!.result.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.getSize100(context: context) +
                                    SizeConfig.getSize50(context: context)),
                            child: const Center(
                                child: Text('No pitches available')),
                          );
                        } else {
                          return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height * 0.90),
                              ),
                              shrinkWrap: true,
                              primary: false,
                              //reverse: true,
                              padding: EdgeInsets.zero,
                              itemCount: snapshot.data!.result.length,
                              itemBuilder: (context, index) {
                                SavedResult data = snapshot.data!.result[index];

                                return Column(
                                  children: [
                                    SizedBox(
                                      height: SizeConfig.getSizeHeightBy(
                                          context: context, by: 0.16),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: DynamicColor.black),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              gradient: DynamicColor
                                                  .gradientColorChange),
                                          child: data.img1.isNotEmpty
                                              ? Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: SizedBox(
                                                          height: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Image.network(
                                                            data.img1,
                                                            fit: BoxFit.cover,
                                                          )),
                                                    ),
                                                    removeButton(
                                                        index, data.id),
                                                    InkWell(
                                                        onTap: () {
                                                          Get.to(() =>
                                                              PitcheShowFullVideoPage(
                                                                url: data.vid1,
                                                                data: data,
                                                              ));
                                                        },
                                                        child: CircleAvatar(
                                                          radius: 15,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          backgroundImage:
                                                              AssetImage(
                                                                  'assets/imagess/ic_play_circle_filled_24px.png'),
                                                        ))
                                                  ],
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Image.asset(
                                                    'assets/images/image_not.jpg',
                                                    height: 100,
                                                    width: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      data.title,
                                      style: textColor15,
                                    ),
                                    Text(
                                      data.status == 1
                                          ? 'Pending'
                                          : data.status == 2
                                              ? 'Approved'
                                              : 'Rejected',
                                      style: TextStyle(
                                        color: data.status == 1
                                            ? DynamicColor.yellowColor
                                            : data.status == 2
                                                ? DynamicColor.green
                                                : DynamicColor.redColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      data.comment,
                                      style: textColor15,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                );
                              });
                        }
                    }
                  }),
            ),
            spaceHeight(SizeConfig.getSizeHeightBy(context: context, by: 0.1))
          ],
        ),
      ),
    );
  }

  Widget removeButton(int index, id) {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) => DeleteSalesPostPopUp(
                    id: id,
                    type: 'Pitches',
                  )).then((value) {
            setState(() {});
          });
        },
        child: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
                color: DynamicColor.white,
                borderRadius: BorderRadius.circular(20)),
            child: Icon(
              Icons.close,
              color: DynamicColor.gredient1,
            )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
