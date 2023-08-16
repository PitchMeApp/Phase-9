import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pitch_me_app/View/posts/post_binding.dart';
import 'package:pitch_me_app/screens/businessIdeas/Apicall.dart/noti.dart';
import 'package:pitch_me_app/screens/splash_screen.dart';
import 'package:pitch_me_app/utils/colors/colors.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

late IO.Socket socket;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init();
  await Firebase.initializeApp();
  socket = IO.io('https://api.salespitchapp.com/',
      IO.OptionBuilder().setTransports(['websocket']).build());
  socket.onConnect((_) {
    log('connect soket');
    // socket.emit('msg', 'test');
  });
  socket.on('connected', (data) => log('event = ' + data.toString()));
  socket.onDisconnect((data) {
    log('disconnect');
    socket.on('reconnect', (error) => log('msg error = ' + error.toString()));
  });

  socket.on('fromServer', (server) => log('Server = ' + server.toString()));
  socket.on('error', (error) => log('msg error = ' + error.toString()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return LayoutBuilder(
        builder: (context, constraints) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            // DeviceOrientation.landscapeLeft,
            // DeviceOrientation.landscapeRight,
          ]);
          return OrientationBuilder(
            builder: (context, orientation) {
              return ChangeNotifierProvider(
                create: (_) => DataClass(),
                child: GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  useInheritedMediaQuery: true,
                  initialBinding: PostBindng(),
                  defaultTransition: Transition.rightToLeft,
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  builder: (context, widget) => ResponsiveBreakpoints.builder(
                    child: BouncingScrollWrapper.builder(context, widget!),
                    /* maxWidth: 1200,
                      minWidth: 450,*/
                    breakpoints: [
                      Breakpoint(start: 0, end: 450, name: MOBILE),
                      Breakpoint(start: 451, end: 800, name: TABLET),
                      Breakpoint(start: 801, end: 1200, name: DESKTOP),
                      Breakpoint(start: 1921, end: 2460, name: "4K"),
                    ],
                  ),
                  home: SplashScreen(),
                ),
              );
            },
          );
        },
      );
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// fb key
//786165039121807
//89ee216e202b0435a33d7e59d9e8e508

class DemoScrollPage extends StatefulWidget {
  const DemoScrollPage({super.key});

  @override
  State<DemoScrollPage> createState() => _DemoScrollPageState();
}

class _DemoScrollPageState extends State<DemoScrollPage> {
  ScrollController _scrollController = ScrollController();
  _scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 30), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    String val = '''
The person making the pitch, or the Application, as the case maybe, shall retain sole and proprietary ownership in the Confidential Information, which includes all intellectual property rights therein, such as patents, trademarks and copyrights. Nothing in this Policy shall be deemed to be construed as granting any right or authority whatsoever to the Users in connection with the Confidential Information, which includes but is not limited to licenses, assignment or any right to use or claim ownership of the Confidential Information.
''';
    return Scaffold(
      appBar: AppBar(
        title: Text('Lyrics'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Text(
          val,
          maxLines: 1000,
          // textScaleFactor: 4,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.020,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.6,
            color: DynamicColor.gredient1,
          ),
        ),
      ),
    );
  }
}
