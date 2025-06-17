import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/webviewcommon.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'multiple_user_screen.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

//   bool isPasswordVisible = false;
//   int selectedRadio = 0;
//   String? selectedAcademicYear;
//   String strloginType = '';
//   String apiData = 'Loading...';
//   String mobileNumber = '';
//   String supportTimingLabel = '';
//   String supportTiming = '';
//   List<Map<String, dynamic>> academicDataList = [];

//   var baseUrl =
//       'https://dds-erp.com/olps-mobile/MobileAppLogin/mobileForcefullyLoginNew/';

//   @override
//   void initState() {
//     super.initState();
//     selectedRadio = 1;
//     fetchData();
//     fetchAcademicList();
//   }

//   Future<void> fetchAcademicList() async {
//     try {
//       final response = await http.get(Uri.parse(
//           "https://dds-erp.com/olps/mobile/MobileCommon/get_academic_list"));
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data =
//             json.decode(utf8.decode(response.bodyBytes));
//         if (data['status'] == true) {
//           final List<dynamic> academicList = data['academic_year_list'];
//           if (academicList.isNotEmpty) {
//             setState(() {
//               academicDataList = List<Map<String, dynamic>>.from(academicList);
//               print('academicDataList   $academicDataList');
//             });
//           }
//         }
//       }
//     } catch (e) {
//       print('Error fetching academic list: $e');
//     }
//   }

//   Future<void> fetchData() async {
//     try {
//       final response = await http.get(Uri.parse(
//           'https://dds-erp.com/olps/mobile/MobileCommon/getSupportContactDetails'));
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data =
//             json.decode(utf8.decode(response.bodyBytes));
//         if (data['status'] == true) {
//           final List<dynamic> supportContactList = data['support_contact_list'];
//           if (supportContactList.isNotEmpty) {
//             final Map<String, dynamic> contactDetails = supportContactList[0];
//             setState(() {
//               mobileNumber = contactDetails['mobile_number'];
//               supportTimingLabel = contactDetails['support_timing_label'];
//               supportTiming = contactDetails['support_timing'];
//               apiData = '$mobileNumber\n$supportTimingLabel : $supportTiming';
//             });
//           } else {
//             setState(() {
//               mobileNumber = 'No support contact details available';
//             });
//           }
//         } else {
//           setState(() {
//             mobileNumber = 'API response indicates an error';
//           });
//         }
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//   }

//   Future<void> login() async {
//     try {
//       final response = await http.post(
//         Uri.parse('https://dds-erp.com/olps/mobile/MobileCommon/doLoginNew'),
//         body: {
//           'username': usernameController.text,
//           'password': passwordController.text,
//           'account_type': strloginType,
//           // 'academic_year': selectedAcademicYear!,
//           'regi_id': '',
//           'device_token': 'fj3f823jfo',
//         },
//       );

//       if (response.statusCode == 200) {
//         final SharedPreferences prefs = await _prefs;

//         final Map<String, dynamic> data =
//             json.decode(utf8.decode(response.bodyBytes));
//             debugPrint('get Token Save -->${data['token']}');
//         prefs.setString('Token', 'Bearer ' + data['token']);
//         prefs.setString('deviceToken', data['device_token']);
//         prefs.setString('academic_year', selectedAcademicYear!);
//         if (data['status'] == true) {
//           final List multipleUserList = data['multiple_user_data'];
//           if (multipleUserList.isNotEmpty) {
//             final List userList = multipleUserList;
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => MultipleUserScreen(
//                     username: usernameController.text.trim(),
//                     password: passwordController.text.trim(),
//                     academicYear: selectedAcademicYear,
//                     multipleUserList: userList,
//                     selectedRadio: strloginType),
//               ),
//             );
//           } else {
//             String url = baseUrl +
//                 "?username=${usernameController.text.trim()}" +
//                 "&password=${base64Encode(utf8.encode(passwordController.text))}" +
//                 "&account_type=$strloginType" +
//                 "&academic_year=$strloginType" +
//                 "&regi_id=''" +
//                 "&device_token=fj3f823jfo";
//             setState(() {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => CommonWebView(url: url),
//                 ),(Route<dynamic> route) => false
//               );
//             });
//           }
//         } else {
//           setState(() {
//             mobileNumber = 'API response indicates an error';
//           });
//         }
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print('Login error: $e');
//     }
//   }

//   void handleRadioValueChanged(int value) {
//     setState(() {
//       selectedRadio = value;
//       strloginType = value == 1 ? 'Teacher' : 'Parent';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextFormField(
//               controller: usernameController,
//               decoration: InputDecoration(
//                 prefixIcon: const Icon(Icons.person),
//                 labelText: 'Username',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20.0),
//             TextFormField(
//               controller: passwordController,
//               obscureText: !isPasswordVisible,
//               decoration: InputDecoration(
//                 prefixIcon: const Icon(Icons.lock),
//                 labelText: 'Password',
//                 suffixIcon: IconButton(
//                   icon: Icon(isPasswordVisible
//                       ? Icons.visibility
//                       : Icons.visibility_off),
//                   onPressed: () {
//                     setState(() {
//                       isPasswordVisible = !isPasswordVisible;
//                     });
//                   },
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20.0),
//             // DropdownButtonFormField(
//             //   value: selectedAcademicYear,
//             //   items: academicDataList.map((academicYear) {
//             //     return DropdownMenuItem<String>(
//             //       value: academicYear['academic_year_name'],
//             //       child: Text(academicYear['academic_year_name']),
//             //     );
//             //   }).toList(),
//             //   onChanged: (String? newValue) {
//             //     setState(() {
//             //       selectedAcademicYear = newValue!;
//             //       print("get value year $selectedAcademicYear");
//             //     });
//             //   },
//             //   decoration: InputDecoration(
//             //     prefixIcon: const Icon(Icons.calendar_today),
//             //     labelText: 'Select Academic Year',
//             //     border: OutlineInputBorder(
//             //       borderRadius: BorderRadius.circular(10.0),
//             //     ),
//             //   ),
//             // ),
//             const SizedBox(height: 20.0),
//             Row(
//               children: [
//                 Radio(
//                   value: 1,
//                   groupValue: selectedRadio,
//                   onChanged: (value) => handleRadioValueChanged(value as int),
//                 ),
//                 const Text('Login as Teacher'),
//                 Radio(
//                   value: 2,
//                   groupValue: selectedRadio,
//                   onChanged: (value) => handleRadioValueChanged(value as int),
//                 ),
//                 const Text('Login as Parent'),
//               ],
//             ),
//             const SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: () {
//                 login();
//               },
//               child: const Text('Login'),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Mobile Number: $mobileNumber',
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 10),
//             Text(
//               apiData,
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Login',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 30),

              // Username Field
              Row(
                children: [
                  const Text("Username*", style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  const Icon(Icons.person, color: Colors.black),
                  const SizedBox(width: 10),
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
                children: [
                  const Text("Password*", style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  const Icon(Icons.lock, color: Colors.black),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 30,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: isPasswordHidden,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 7),
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
                          contentPadding: const EdgeInsets.all(0),
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

              // Login As Radio
              Row(
                children: [
                  const Text('Login As*', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 5),
                  Radio<String>(
                    value: 'Teacher', // actual value sent to API
                    groupValue: loginAs,
                    onChanged: (value) {
                      setState(() => loginAs = value!);
                    },
                  ),
                  const Text('Teacher'),
                  const SizedBox(width: 20),
                  Radio<String>(
                    value: 'Parent', // actual value sent to API
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
                    backgroundColor: const Color(0xFF00D2C4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _handleLogin,
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

  Future<void> _handleLogin() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final type = loginAs;

    if (username.isEmpty || password.isEmpty || type.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final encodedPassword = base64Encode(utf8.encode(password));
    final prefs = await SharedPreferences.getInstance();
    final appUrl = prefs.getString('app_url') ?? '';
    final deviceToken = prefs.getString('firebase_token') ?? '';

    final loginUrl = '$appUrl/MobileAppLogin/mobileForcefullyLogin'
        '?username=${Uri.encodeComponent(username)}'
        '&password=${Uri.encodeComponent(encodedPassword)}'
        '&account_type=${Uri.encodeComponent('Parent')}'
        '&regi_id='
        '&device_token=e8RA1d1LQfKWNLx5cZQ62F:APA91bGdEcPKGs6se5JQGylmKGuUKssUiBzIhXb9yZ_IC2vR75G6sOZnp3Z_gqnVtLkZ1clhbnoAEpyx9SQaZ-GQOE--NjbeYfIyFAyZt4AB72WiQy6r9W4';
    // 1parent 2teacher
    print("response is${loginUrl}");

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      // final response = await http.get(Uri.parse(loginUrl));
      // print("response is${response.body}");

      Navigator.of(context).pop(); // hide loading

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => CommonWebView(
                  url: loginUrl,
                )),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}

class MainActivity extends StatelessWidget {
  const MainActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Welcome to MainActivity')),
    );
  }
}
