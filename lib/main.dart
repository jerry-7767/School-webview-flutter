import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login_screen',
    routes: {'login_screen': (context) => DeciderScreen()},
  ));
}

class DeciderScreen extends StatefulWidget {
  const DeciderScreen({super.key});

  @override
  State<DeciderScreen> createState() => _DeciderScreenState();
}

class _DeciderScreenState extends State<DeciderScreen> {
  @override
  void initState() {
    super.initState();
    checkSplashUrl();
  }

  Future<void> checkSplashUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final splashUrl = prefs.getString('splash_screen');
print("===>$splashUrl");
    if (splashUrl != null && splashUrl.isNotEmpty) {
      // Go to splash screen if URL is saved
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SplashScreen()),
      );
    } else {
      // Else go to code register screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CodeVerificationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Optional loading UI
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? splashUrl;

  @override
  void initState() {
    super.initState();
    loadSplashUrl();
  }

  Future<void> loadSplashUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('splash_screen');

    setState(() {
      splashUrl = url;
    });

    // Optional: Navigate after few seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
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
