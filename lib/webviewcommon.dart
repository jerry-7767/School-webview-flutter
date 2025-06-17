import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_screen.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_webview_plugin_ios_android/flutter_webview_plugin_ios_android.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CommonWebView extends StatefulWidget {
  var url;

  CommonWebView({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<CommonWebView> createState() => _CommonWebViewState();
}

class _CommonWebViewState extends State<CommonWebView> {
  //late WebViewController controller;
  var urlString;
  bool showPaymentButton = false;
  List oderNumberId = [];
  bool showRefreshIcon = true;
  bool isLoadingPaymentLink = false;
  bool isLodingBilling = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    // if (GetPlatform.isAndroid) WebView.platform = AndroidWebView();
    // print("Webview Data ${jsonEncode(widget.data)}");
    urlString = widget.url;
    super.initState();

    // if (widget.from == 'for2FA') {
    //   // final flutterWebviewPlugin = FlutterWebviewPlugin();
    //   flutterWebviewPlugin.onUrlChanged.listen((String state) async {
    //     print('00000 $state');
    //     print('not working1----------');

    //     if (state.contains('PurchaseRedirectPage.aspx')) {
    //       // check2FA(widget.data);
    //       setState(() {
    //         widget.flag == 'redeem' ? '' : showPaymentButton = true;
    //         print('not working2----------');
    //       });
    //       flutterWebviewPlugin.onStateChanged
    //           .listen((WebViewStateChanged viewState) async {
    //         print('------------------------00000000000');
    //         print(viewState.type);
    //         print(WebViewState.finishLoad);
    //         if (viewState.type == WebViewState.finishLoad &&
    //             widget.flag != 'redeem') {
    //           print('not working3----------');
    //           await flutterWebviewPlugin.evalJavascript(
    //               "document.getElementById('btnBack').style.display = 'none';");
    //         }
    //       });
    //     } else if (state
    //         .contains('https://staging.ifanow.in/authenticate-payment')) {
    //       showPaymentButton = false;
    //       showRefreshIcon = false;
    //     }
    //   });
    // }

    // if (widget.from == 'billing') {
    //   // final flutterWebviewPlugin = FlutterWebviewPlugin();
    //   flutterWebviewPlugin.onUrlChanged.listen((String state) async {
    //     print('00000 $state');
    //     print('not working1----------');

    //     if (state.contains('homepage')) {
    //       print("condition True");
    //       setState(() {
    //         isLodingBilling = true;
    //       });
    //       final SharedPreferences prefs = await SharedPreferences.getInstance();
    //       var userData = jsonDecode(prefs.get('userInfo').toString());
    //       if (userData['userType'] == 1) {
    //         var obj = {'advisorId': userData['advisorId']};
    //         var data = await loginService.getUserAccountStatus(obj);
    //         if (data['token'] != null) {
    //           prefs.setString('userInfo', jsonEncode(data));
    //         }
    //       }
    //       setState(() {
    //         isLodingBilling = false;
    //       });
    //       Navigator.pop(context);
    //     }
    //     // check2FA(widget.data);
    //   });
    // }
    getData();
  }

  var token;
  var deviceToken;
  var selectedAcademicYear;

  getData() async {
    // final SharedPreferences prefs = await _prefs;
    // token = prefs.getString('Token');
    // deviceToken = prefs.getString('deviceToken');
    // selectedAcademicYear = prefs.getString('academic_year');
    // debugPrint("----->Token $token");
    // debugPrint("----->deviceToken $deviceToken");
    // debugPrint("----->selectedAcademicYear $selectedAcademicYear");
  }

  // Future<bool> getPermissions() async {
  //   setState(() {});
  //   if (GetPlatform.isIOS) return true;
  //   await Permission.camera.request();
  //   await Permission.microphone.request();

  //   while ((await Permission.camera.isDenied)) {
  //     await Permission.camera.request();
  //   }
  //   while ((await Permission.microphone.isDenied)) {
  //     await Permission.microphone.request();
  //   }
  //   while ((await Permission.location.isDenied)) {
  //     await Permission.location.request();
  //   }
  //   while ((await Permission.videos.isDenied)) {
  //     await Permission.videos.request();
  //   }
  //   while ((await Permission.accessMediaLocation.isDenied)) {
  //     await Permission.accessMediaLocation.request();
  //   }
  //   while ((await Permission.storage.isDenied)) {
  //     await Permission.storage.request();
  //   }

  //   return true;
  // }

  // html.MediaStream? _localStream;
  // html.MediaStreamTrack? _localTrack;
  // _checkPermission() {
  //   // html.window.navigator.getUserMedia(audio: true, video: true).then((stream) {
  //   //   // Use the stream
  //   //   _localStream = stream;
  //   //   _localTrack = _localStream!.getTracks()[0];
  //   // }

  //   ).catchError((e) {
  //     print('Error: $e');
  //   }).catchError((e) {
  //     print('Error: $e');
  //   });
  // }
  Logout() async {
    try {
      var header = {
        'Accept': "application/json",
        'Authorization': token.toString(),
      };
      final response = await http.post(
          Uri.parse('https://dds-erp.com/olps/mobile/MobileCommon/logout'),
          body: {
            'academic_year': selectedAcademicYear,
            'device_token': deviceToken,
          },
          headers: header);
      print("Api call Done");
      if (response.statusCode == 200) {
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Login error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
              onTap: () async {
                final SharedPreferences prefs = await _prefs;
                prefs.clear();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CodeVerificationScreen()),
                    (Route<dynamic> route) => false);
              },
              child: const Icon(Icons.logout))
        ],
      ),
      url: urlString,
      clearCache: true,

      withLocalStorage: true,
      geolocationEnabled: true,
      withJavascript: true,
      allowFileURLs: true,
      mediaPlaybackRequiresUserGesture: true,
      clearCookies: true,
      enableAppScheme: true,
      supportMultipleWindows: true,
      javascriptChannels: {
        JavascriptChannel(
            name: 'Print',
            onMessageReceived: (JavascriptMessage message) {
              print("url print---->$message");
            })
      },
      withOverviewMode: true,
      ignoreSSLErrors: true,

      onBackPress: (webViewController) {
        // webViewController
        // ._checkPermission();
        webViewController.getPermissions();
      },
      // hidden: true,
      // initialChild: Center(
      //     child: LoadingAnimationWidget.fourRotatingDots(
      //   color: Theme.of(context).colorScheme.onTertiary,
      //   size: 50,
      // )),
    );
  }
}
// School Code : RG-20242500002

// Username : utsav.kathpalia@gmail.com / 8097939301
// Password : 12345678