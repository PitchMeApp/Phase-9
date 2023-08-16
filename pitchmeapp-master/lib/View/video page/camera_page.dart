// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitch_me_app/View/video%20page/video_play_page.dart';
import 'package:pitch_me_app/utils/sizeConfig/sizeConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/colors/colors.dart';
import '../../utils/widgets/Navigation/custom_navigation.dart';
import 'add_promt_text.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  GlobalKey<FormState> abcKey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  bool _isRecording = false;

  late CameraController _cameraController;
  late List<CameraDescription> _availableCameras;
  late Timer timer;

  String title = "";
  String promtText = "";

  int speedFactor = 50;
  int secondsRemaining = 59;

  @override
  void initState() {
    _getAvailableCameras();
    getPromt();
    title = Get.arguments.toString();

    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    timer.cancel();
    super.dispose();
  }

  void getPromt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (prefs.getString("prompt") != null) {
        promtText = prefs.getString("prompt").toString();
      }
    });
  }

  // get available cameras
  Future<void> _getAvailableCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    _availableCameras = await availableCameras();
    _initCamera(_availableCameras.reversed.first);
  }

  // init camera
  Future<void> _initCamera(CameraDescription description) async {
    _cameraController =
        CameraController(description, ResolutionPreset.high, enableAudio: true);

    try {
      await _cameraController.initialize();

      setState(() => _isLoading = false);
    } catch (e) {
      print('camera = ' + e.toString());
    }
  }

  void _toggleCameraLens() {
    // get current lens direction (front / rear)
    final lensDirection = _cameraController.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = _availableCameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = _availableCameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    if (newDescription != null) {
      _initCamera(newDescription);
    } else {
      print('Asked camera not available');
    }
  }

  _recordVideo() async {
    try {
      if (_isRecording) {
        final file = await _cameraController.stopVideoRecording();

        setState(() => _isRecording = false);
        final route = MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) =>
              VideoPage(key: abcKey, filePath: file.path, title: title),
        );
        Navigator.pushReplacement(context, route);
      } else {
        await _cameraController.prepareForVideoRecording();
        await _cameraController.startVideoRecording();
        setState(() => _isRecording = true);
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    } catch (e) {
      // log('video = ' + e.toString());
    }
  }

  void timeOutVideo() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
          print(timer.tick.toString());
        });
      } else {
        setState(() {
          timer.cancel();

          _cameraController.pausePreview();
        });
      }
    });
  }

  _scrollToBottom() {
    double maxExtent = _scrollController.position.maxScrollExtent;
    double distanceDifference = maxExtent - _scrollController.offset;
    double durationDouble = distanceDifference / speedFactor;

    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: durationDouble.toInt()),
        curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(
            color: DynamicColor.gredient1,
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
                child: Stack(
              children: [
                CameraPreview(_cameraController),
                _isRecording
                    ? SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.getSizeHeightBy(
                                      context: context, by: 0.5)),
                              child: Text(
                                promtText,
                                maxLines: 1000,
                                textScaleFactor: 2.2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.020,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.6,
                                  color: DynamicColor.gredient2,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height,
                            )
                          ],
                        ),
                      )
                    : Container(),
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.getSize50(context: context),
                        right: SizeConfig.getSize15(context: context),
                      ),
                      child: PopupMenuButton(
                          onSelected: (value) {
                            if (value == 'Slow') {
                              setState(() {
                                speedFactor = 50;
                                _scrollToBottom();
                              });
                            } else if (value == 'Medium') {
                              setState(() {
                                speedFactor = 70;
                                _scrollToBottom();
                              });
                            } else {
                              setState(() {
                                speedFactor = 90;
                                _scrollToBottom();
                              });
                            }
                          },
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(value: 'Slow', child: Text('Slow')),
                              PopupMenuItem(
                                  value: 'Medium', child: Text('Medium')),
                              PopupMenuItem(value: 'Fast', child: Text('Fast')),
                            ];
                          },
                          child: Text(
                            'Prompt Speed',
                            style: TextStyle(
                                color: DynamicColor.green,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          )),
                    ))
              ],
            )),
            Container(
              width: double.infinity,
              color: DynamicColor.white,
              child: _isRecording
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.all(15),
                            alignment: Alignment.centerRight,
                            color: DynamicColor.white,
                            child: Text(
                              secondsRemaining != 0
                                  ? secondsRemaining < 10
                                      ? '0:0$secondsRemaining'
                                      : '0:$secondsRemaining'
                                  : '0:00',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: DynamicColor.gredient1),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            alignment: Alignment.centerLeft,
                            child: FloatingActionButton(
                              heroTag: 1,
                              backgroundColor: Colors.red,
                              child: Icon(
                                _isRecording
                                    ? Icons.stop
                                    : Icons.radio_button_checked,
                                size: 40,
                              ),
                              onPressed: () {
                                _recordVideo();
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: FloatingActionButton(
                            heroTag: 1,
                            backgroundColor: Colors.red,
                            child: Icon(
                              _isRecording
                                  ? Icons.stop
                                  : Icons.radio_button_checked,
                              size: 40,
                            ),
                            onPressed: () {
                              _recordVideo();
                              timeOutVideo();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: FloatingActionButton(
                            heroTag: 2,
                            backgroundColor: DynamicColor.gredient2,
                            child: Text(
                              'Add Text',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              PageNavigateScreen()
                                  .push(context, AddPromtText())
                                  .then((value) {
                                getPromt();
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: FloatingActionButton(
                            heroTag: 3,
                            backgroundColor: DynamicColor.gredient1,
                            child: const Icon(
                              Icons.change_circle,
                              size: 40,
                            ),
                            onPressed: () => _toggleCameraLens(),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      );
    }
  }
}
