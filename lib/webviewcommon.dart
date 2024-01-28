import 'dart:async';

// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin_ios_android/flutter_webview_plugin_ios_android.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:mob_app/Constants/Font%20Constants/font_family.dart';
import 'package:mob_app/Constants/Font%20Constants/font_size_constants.dart';
import 'package:mob_app/Constants/Profiles/dialog/dialogError.dart';
import 'package:mob_app/Screens/people/Portfolio/assets/mutualFund/Transactions/transaction_screen.dart';
import 'package:mob_app/Screens/profile/mandate/madates.dart';
import 'package:mob_app/Services/customer_service/transactionService.dart';
import 'package:mob_app/Services/login_service/login_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CommonWebView extends StatefulWidget {
  var url;
  var from;
  var familyData;
  bool subscribedPayment;
  var data;
  var data2;
  var flag;

  CommonWebView({
    Key? key,
    required this.url,
    this.from,
    this.familyData,
    this.subscribedPayment = false,
    this.data,
    this.data2,
    this.flag,
  }) : super(key: key);

  @override
  State<CommonWebView> createState() => _CommonWebViewState();
}

class _CommonWebViewState extends State<CommonWebView> {
  TransactionService transact = TransactionService();
  LoginService loginService = LoginService();

  // final flutterWebviewPlugin = new FlutterWebviewPlugin();
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  //late WebViewController controller;
  var urlString;
  bool showPaymentButton = false;
  List oderNumberId = [];
  bool showRefreshIcon = true;
  bool isLoadingPaymentLink = false;
  bool isLodingBilling = false;

  @override
  void initState() {
    // if (GetPlatform.isAndroid) WebView.platform = AndroidWebView();
    print("Webview Data ${jsonEncode(widget.data)}");
    urlString = widget.url;
    super.initState();

    if (widget.from == 'for2FA') {
      // final flutterWebviewPlugin = FlutterWebviewPlugin();
      flutterWebviewPlugin.onUrlChanged.listen((String state) async {
        print('00000 $state');
        print('not working1----------');

        if (state.contains('PurchaseRedirectPage.aspx')) {
          // check2FA(widget.data);
          setState(() {
            widget.flag == 'redeem' ? '' : showPaymentButton = true;
            print('not working2----------');
          });
          flutterWebviewPlugin.onStateChanged
              .listen((WebViewStateChanged viewState) async {
            print('------------------------00000000000');
            print(viewState.type);
            print(WebViewState.finishLoad);
            if (viewState.type == WebViewState.finishLoad &&
                widget.flag != 'redeem') {
              print('not working3----------');
              await flutterWebviewPlugin.evalJavascript(
                  "document.getElementById('btnBack').style.display = 'none';");
            }
          });
        } else if (state
            .contains('https://staging.ifanow.in/authenticate-payment')) {
          showPaymentButton = false;
          showRefreshIcon = false;
        }
      });
    }

    if (widget.from == 'billing') {
      // final flutterWebviewPlugin = FlutterWebviewPlugin();
      flutterWebviewPlugin.onUrlChanged.listen((String state) async {
        print('00000 $state');
        print('not working1----------');

        if (state.contains('homepage')) {
          print("condition True");
          setState(() {
            isLodingBilling = true;
          });
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          var userData = jsonDecode(prefs.get('userInfo').toString());
          if (userData['userType'] == 1) {
            var obj = {'advisorId': userData['advisorId']};
            var data = await loginService.getUserAccountStatus(obj);
            if (data['token'] != null) {
              prefs.setString('userInfo', jsonEncode(data));
            }
          }
          setState(() {
            isLodingBilling = false;
          });
          Navigator.pop(context);
        }
        // check2FA(widget.data);
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return widget.from == 'billing'
        ? WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: WebviewScaffold(
              url: urlString,
              clearCache: true,
              appBar: AppBar(
                leading: Visibility(
                    visible: widget.subscribedPayment == false,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      onPressed: () async {
                        if (widget.from == 'transaction') {
                          flutterWebviewPlugin.close();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const TransactionScreen('final', 2)));
                        } else if (widget.from == 'mandate') {
                          flutterWebviewPlugin.close();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Mandates(widget.familyData, 0, 'success');
                          }));
                        } else if (widget.from == 'billing') {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          var userData =
                              jsonDecode(prefs.get('userInfo').toString());
                          if (userData['userType'] == 1) {
                            var obj = {'advisorId': userData['advisorId']};
                            var data =
                                await loginService.getUserAccountStatus(obj);
                            if (data['token'] != null) {
                              prefs.setString('userInfo', jsonEncode(data));
                            }
                          }

                          Navigator.pop(context);
                        } else {
                          flutterWebviewPlugin.goBack();
                        }
                      },
                    )),
                titleSpacing: -8,
                title: Text(
                  widget.subscribedPayment == false
                      ? widget.from == 'mandate'
                          ? 'Mandate'
                          : widget.from == 'transaction'
                              ? 'Transaction'
                              : widget.from == 'IINUCC'
                                  ? 'Nominee Authentication'
                                  : widget.from == 'buyFD'
                                      ? 'Buy FD'
                                      : 'KYC'
                      : '',
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                actions: [
                  !isLodingBilling
                      ? IconButton(
                          onPressed: () async {
                            flutterWebviewPlugin.close();
                            if (widget.from == 'mandate') {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Mandates(
                                    widget.familyData, 0, 'success');
                              }));
                            } else if (widget.from == 'transaction') {
                              // check2FA(widget.data);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const TransactionScreen('final', 2)));
                            } else if (widget.from == 'IINUCC') {
                              // IINUCCScreen
                              Navigator.pop(context);
                            } else if (widget.from == 'billing') {
                              setState(() {
                                isLodingBilling = true;
                              });
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              var userData =
                                  jsonDecode(prefs.get('userInfo').toString());
                              if (userData['userType'] == 1) {
                                var obj = {'advisorId': userData['advisorId']};
                                var data = await loginService
                                    .getUserAccountStatus(obj);
                                if (data['token'] != null) {
                                  prefs.setString('userInfo', jsonEncode(data));
                                }
                              }
                              setState(() {
                                isLodingBilling = false;
                              });
                              Navigator.pop(context);
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          icon: Icon(
                            Icons.clear,
                            color: Theme.of(context).secondaryHeaderColor,
                          ))
                      : Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: LoadingAnimationWidget.threeArchedCircle(
                            color: Theme.of(context).colorScheme.onTertiary,
                            size: 25,
                          ),
                        ),
                ],
              ),
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
            ),
          )
        : widget.from == 'for2FA'
            ? WebviewScaffold(
                bottomNavigationBar:
                    // if (showPaymentButton)
                    Visibility(
                  visible: showPaymentButton,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                      onTap: () async {
                        check2FA(widget.data);
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        margin: GetPlatform.isIOS
                            ? const EdgeInsets.only(
                                top: 20, bottom: 30, left: 20, right: 20)
                            : const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onTertiary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: isLoadingPaymentLink
                            ? Center(
                                child: LoadingAnimationWidget.prograssiveDots(
                                  color: Colors.white,
                                  size: 50,
                                ),
                              )
                            // : CommonButton(
                            //     buttonColor: Theme.of(context).colorScheme.onTertiary,
                            //     onPressed: () async {
                            //       check2FA(widget.data);
                            //       // getPaymentLink(widget.data);
                            //     },
                            //     text: 'Initiate payment',
                            //     textColor: Colors.white,
                            //   ),
                            : const Center(
                                child: Text(
                                  'Initiate payment',
                                  // 'Transact Now',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: FontConstants.fontsize16,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: FontFamilyConstants.Santoshi),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                // ],
                url: urlString,
                clearCache: true,
                appBar: AppBar(
                  leading: Visibility(
                    visible: widget.subscribedPayment == false,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      onPressed: () {
                        if (widget.from == 'for2FA') {
                          flutterWebviewPlugin.close();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const TransactionScreen('final', 2)));
                        } else {
                          flutterWebviewPlugin.goBack();
                        }
                      },
                    ),
                  ),
                  titleSpacing: -8,
                  title: Text(
                    'Transaction',
                    style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  actions: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              flutterWebviewPlugin.close();

                              // check2FA(widget.data);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const TransactionScreen('final', 2)));
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Theme.of(context).secondaryHeaderColor,
                            )),
                        Visibility(
                          visible: showRefreshIcon,
                          child: IconButton(
                              onPressed: () async {
                                flutterWebviewPlugin.reload();
                              },
                              icon: Icon(
                                Icons.refresh,
                                color: Theme.of(context).secondaryHeaderColor,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
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
                      onMessageReceived: (JavascriptMessage message) {})
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
              )
            : WebviewScaffold(
                url: urlString,
                clearCache: true,
                appBar: AppBar(
                  leading: Visibility(
                    visible: widget.subscribedPayment == false,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      onPressed: () {
                        if (widget.from == 'transaction') {
                          flutterWebviewPlugin.close();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const TransactionScreen('final', 2)));
                        } else if (widget.from == 'mandate') {
                          flutterWebviewPlugin.close();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Mandates(widget.familyData, 0, 'success');
                          }));
                        } else {
                          flutterWebviewPlugin.goBack();
                        }
                      },
                    ),
                  ),
                  titleSpacing: -8,
                  title: Text(
                    widget.subscribedPayment == false
                        ? widget.from == 'mandate'
                            ? 'Mandate'
                            : widget.from == 'transaction'
                                ? 'Transaction'
                                : widget.from == 'IINUCC'
                                    ? 'Nominee Authentication'
                                    : widget.from == 'buyFD'
                                        ? 'Buy FD'
                                        : 'KYC'
                        : '',
                    style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () async {
                          flutterWebviewPlugin.close();
                          if (widget.from == 'mandate') {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Mandates(widget.familyData, 0, 'success');
                            }));
                          } else if (widget.from == 'transaction') {
                            // check2FA(widget.data);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const TransactionScreen('final', 2)));
                          } else if (widget.from == 'IINUCC') {
                            // IINUCCScreen
                            Navigator.pop(context);
                          } else if (widget.from == 'billing') {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var userData =
                                jsonDecode(prefs.get('userInfo').toString());
                            if (userData['userType'] == 1) {
                              var obj = {'advisorId': userData['advisorId']};
                              var data =
                                  await loginService.getUserAccountStatus(obj);
                              if (data['token'] != null) {
                                prefs.setString('userInfo', jsonEncode(data));
                              }
                            }
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Theme.of(context).secondaryHeaderColor,
                        )),
                  ],
                ),
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
                      onMessageReceived: (JavascriptMessage message) {})
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

  check2FA(data) async {
    setState(() {
      isLoadingPaymentLink = true;
    });
    var obj = {
      "orderNo": data['orderId'],
      "internalRefNo": widget
          .data2['internalrefno'], // confirm which value to pass over here
    };

    oderNumberId = [];
    var response = await transact.get2FAStatus(obj);
    // print(['object for 2fa', response['ifanowOrderStatus'][0]['paymentFlag']]);
    // print(['object for 2fa Response', response]);

    for (int i = 0; i < response['ifanowOrderStatus'].length; i++) {
      oderNumberId.add(response['ifanowOrderStatus'][i]['orderNo']);
    }
    print(['object for 2fa oderNumberIdList', oderNumberId]);

    // if (response['ifanowOrderStatus'][0]['paymentFlag'] == "Y") {
    setState(() {
      if (widget.data['holdingType'] == 'SI') {
        // for single holder
        showPaymentButton = true;
        getPaymentLink(data, response, oderNumberId);
      } else {
        get2FAAuthLink(data, response, oderNumberId); // for joint holder
      }
    });
    // } else {
    //   // show some msg that authentication not done and redirect to pending transactions screen
    // }
  }

  get2FAAuthLink(data, res, orderNumber) async {
    var obj = {
      "clientCode": data['clientCode'],
      "tpUserCredentialId": data['tpUserCredentialId'],
      "isReturnUrl": "N",
    };
    var response = await transact.get2FAuthLink(obj);
    print(response);
    try {
      if (response['responseString'] != null) {
        var flag = response['isLink'] == "Y" ? 1 : 2;
        print("get2FAStatusJoinHolder-->$data");
        get2FAStatusJoinHolder(data, res, flag, orderNumber);
      }
    } catch (e) {
      print(e);
    }
  }

  get2FAStatusJoinHolder(data, res, flag, orderNumber) async {
    var temp = [];
    temp.add(data['orderId']);
    var obj = {
      'orderNo': orderNumber,
      'updateMessageFlag': flag,
    };
    final response = await transact.get2FAStatusJoinHolder(obj);
    print(response);
    // if response response for second holder isLink then redirect to pending transaction screen else hit payment link api for paying
    if (flag == 2) {
      getPaymentLink(data, res, orderNumber);
    } else {
      isLoadingPaymentLink = false;
      flutterWebviewPlugin.close();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const TransactionScreen('final', 2)));
    }
  }

  getPaymentLink(data, res, orderNumberList) async {
    var temp = [];
    temp.add(res['ifanowOrderStatus'][0]['orderNo']);
    data['aggregatorType'] = data['aggregatorType'] == 'NSE' ? 1 : 2;
    data['userAccountType'] = data['userAccountType'] == 'ARN' ? 1 : 2;
    data['orderNo'] = orderNumberList;
    // print(jsonEncode(data));
    // debugPrint("Order Numbers--->$orderNumberList");
    // debugPrint("Order Numbers--->${data['orderNo']}");
    // debugPrint("getPaymentLink-->$data");
    final response = await transact.getPaymentLink(data);
    debugPrint("getPaymentLink-->$response");

    // print(jsonEncode(response));
    if (response['payment'] != null) {
      debugPrint("response payment-->${response['payment']}");
      if (response['payment']['responsestring'] != null) {
        // var link = (response['payment']['responsestring']);
        // var stringLink = link.replaceAll("\n", "");

        var orderId = response['orderId'];
        debugPrint("Oder Id-->$orderId");
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        var token = prefs.get('token');
        // debugPrint("token Id-->$token");
        token = token?.toString().replaceAll(" ", "%20");

        launchUrl(orderId, token);

        // 'https://staging.ifanow.in/authenticate-payment?orderId=$orderId&&auth=$token');      702358374  702361355  702370146
      }
    } else {
      isLoadingPaymentLink = false;
      dialogErrorPage(
        context,
        'https://res.cloudinary.com/futurewise/image/upload/v1659771160/Flutter/Skip_-_DARK.png',
        Theme.of(context).primaryColor == const Color(0xffffffff)
            ? "https://res.cloudinary.com/futurewise/image/upload/v1690955028/Mobile%20APP/new%20design%20icons%20mob_app/Skip_-_LIGHT.png"
            : "https://res.cloudinary.com/futurewise/image/upload/v1690955001/Mobile%20APP/new%20design%20icons%20mob_app/Skip_-_DARK-1.png",
        "https://res.cloudinary.com/futurewise/image/upload/v1690955016/Mobile%20APP/new%20design%20icons%20mob_app/Skip_-_DARK.png",
        '',
        'Something went wrong.',
      );
    }
  }

  Future launchUrl(orderId, token) async {
    setState(() {
      urlString =
          'https://pinnacle.ifanow.in/authenticate-payment?orderId=$orderId&&auth=$token';
      debugPrint("launch url->$urlString");
      flutterWebviewPlugin.reloadUrl(urlString);
      isLoadingPaymentLink = false;
      showPaymentButton == true ? showPaymentButton = false : '';
      showRefreshIcon == true ? showRefreshIcon = false : '';
    });
    // flutterWebviewPlugin.reloadUrl(
    //     'https://staging.ifanow.in/authenticate-payment?orderId=$orderId&&auth=$token');
  }

  Future refresh2FA() async {
    await Future.delayed(const Duration(seconds: 1), () {
      flutterWebviewPlugin.reload();
    });
  }
}
