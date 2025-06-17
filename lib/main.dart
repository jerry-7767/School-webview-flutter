import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_screen.dart';
import 'package:flutter_application_1/webviewcommon.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login_screen',
    routes: {'login_screen': (context) => SplashScreen()},
  ));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? splashUrl;
  bool isPageLoading = false;

  @override
  void initState() {
    super.initState();
    checkSplashUrl();
  }

  Future<void> checkSplashUrl() async {
    isPageLoading = true;
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('splash_screen');
    final userLogin = prefs.getString('isUserLogin');
    print("===>$splashUrl");

    setState(() {
      if (url != null && url.isNotEmpty) {
        isPageLoading = false;

        splashUrl = url;
        Future.delayed(const Duration(seconds: 3), () {
          if (userLogin != null && userLogin.isNotEmpty) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => CommonWebView(
                          url: userLogin,
                        )));
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        });
      } else {
        isPageLoading = false;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CodeVerificationScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isPageLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: splashUrl != null
                  ? Image.network(
                      splashUrl!,
                      height: 250,
                      width: 250,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Text('Failed to load image'),
                    )
                  : const CircularProgressIndicator(),
            ),
    );
  }
}

class CodeVerificationScreen extends StatefulWidget {
  const CodeVerificationScreen({super.key});

  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  final TextEditingController codeController = TextEditingController();
  bool isLoading = false;

  Future<void> codeVerification(String code) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            'https://common-app.dds-erp.com/mobile/MobileCommon/verifyAppAccessToken'),
        body: {'token': code},
      );

      final Map<String, dynamic> data =
          json.decode(utf8.decode(response.bodyBytes));
      print(data);
      if (data['status'] == true) {
        final accessData = data['data'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('web_url', accessData['web_url']);
        await prefs.setString('app_url', accessData['app_url']);
        await prefs.setString('access_token', accessData['access_token']);
        await prefs.setString('account_name', accessData['account_name']);
        await prefs.setString('splash_screen', accessData['splash_screen']);
        print("Splashscreenurl ${accessData['splash_screen']}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      } else {
        showMessage(data['message'] ?? "Invalid code");
      }
    } catch (e) {
      showMessage("Something went wrong. Try again.$e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void onVerifyPressed() {
    final code = codeController.text.trim();
    if (code.isEmpty) {
      showMessage("Please Enter Institute Code");
    } else {
      codeVerification(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Code input field
                  TextFormField(
                    controller: codeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Enter Code',
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 30),
                  // Verify button
                  SizedBox(
                    width: 180,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: onVerifyPressed,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: const Color(0xFF00D2C4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Verify',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Loading overlay
          if (isLoading)
            Container(
              color: Colors.black45,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
