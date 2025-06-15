import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login_screen',
    routes: {'login_screen': (context) => LoginScreen()},
  ));
}

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordHidden = true;
  String loginAs = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),

              // Username Field
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Username*",
                    style: TextStyle(fontSize: 16),
                  ),

                  const SizedBox(width: 8),
                  const Icon(Icons.person, color: Colors.black),
                  const SizedBox(width: 10),

                  // Expanded TextField
                  Expanded(
                    child: TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: 'Email/Mobile',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Password Field
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Password*",
                    style: TextStyle(fontSize: 16),
                  ),

                  const SizedBox(width: 8),
                  const Icon(Icons.lock, color: Colors.black),
                  const SizedBox(width: 10),

                  // Expanded TextFormField with underline only
                  Expanded(
                    child: SizedBox(
                      height: 30, // 👈 Controls overall height
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: isPasswordHidden,
                        style:
                            const TextStyle(fontSize: 14), // 👈 Match font size
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 7), // 👈 Align icon properly
                            child: IconButton(
                              icon: Icon(
                                isPasswordHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 20,
                                color: Colors.grey[700],
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordHidden = !isPasswordHidden;
                                });
                              },
                            ),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.all(0), // 👈 Tight padding
                          border: const UnderlineInputBorder(),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.teal, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Login As
            
              Row(
                children: [ const Text(
                  'Login As*',
                  style: TextStyle(fontSize: 16),
                ),    const SizedBox(width: 5),
                  Radio<String>(
                    value: 'Teacher',
                    groupValue: loginAs,
                    onChanged: (value) {
                      setState(() => loginAs = value!);
                    },
                  ),
                  const Text('Teacher'),
                  const SizedBox(width: 20),
                  Radio<String>(
                    value: 'Parent',
                    groupValue: loginAs,
                    onChanged: (value) {
                      setState(() => loginAs = value!);
                    },
                  ),
                  const Text('Parent'),
                ],
              ),
              const SizedBox(height: 20),

              // Sign in Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF00D2C4), // Teal button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'SIGN ME IN !',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Support Info
              const Text(
                'If you getting any problem in filling this form or paying online kindly contact on this number',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                '8828902622',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Support Time : 10 AM to 7 PM',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CodeVerificationScreen extends StatelessWidget {
  const CodeVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            // Code input field
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Enter Code',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            // Verify button
            SizedBox(
              width: 180,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Handle verification logic here
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Verify',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
