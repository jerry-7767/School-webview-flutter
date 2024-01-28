import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'multiple_user_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  int selectedRadio = 0;
  String? selectedAcademicYear;
  String strloginType = '';
  String apiData = 'Loading...';
  String mobileNumber = '';
  String supportTimingLabel = '';
  String supportTiming = '';
  List<Map<String, dynamic>> academicDataList = [];

  

  @override
  void initState() {
    super.initState();
    selectedRadio = 1;
    fetchData();
    fetchAcademicList();
  }

  Future<void> fetchAcademicList() async {
    try {
      final response = await http.get(Uri.parse("https://dds-erp.com/olps/mobile/MobileCommon/get_academic_list"));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        if (data['status'] == true) {
          final List<dynamic> academicList = data['academic_year_list'];
          if (academicList.isNotEmpty) {
            setState(() {
              academicDataList = List<Map<String, dynamic>>.from(academicList);
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching academic list: $e');
    }
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://dds-erp.com/olps/mobile/MobileCommon/getSupportContactDetails'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        if (data['status'] == true) {
          final List<dynamic> supportContactList = data['support_contact_list'];
          if (supportContactList.isNotEmpty) {
            final Map<String, dynamic> contactDetails = supportContactList[0];
            setState(() {
              mobileNumber = contactDetails['mobile_number'];
              supportTimingLabel = contactDetails['support_timing_label'];
              supportTiming = contactDetails['support_timing'];
              apiData = '$mobileNumber\n$supportTimingLabel : $supportTiming';
            });
          } else {
            setState(() {
              mobileNumber = 'No support contact details available';
            });
          }
        } else {
          setState(() {
            mobileNumber = 'API response indicates an error';
          });
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> login() async {
    try {
      final response = await http.post(
        Uri.parse('https://dds-erp.com/olps/mobile/MobileCommon/doLoginNew'),
        body: {
          'username': usernameController.text,
          'password': passwordController.text,
          'account_type': strloginType,
          'academic_year': selectedAcademicYear!,
          'regi_id': '',
          'device_token': 'fj3f823jfo',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        if (data['status'] == true) {
          final List<dynamic> multipleUserList = data['multiple_user_data'];
          if (multipleUserList.isNotEmpty) {
            final Map<String, dynamic> userList = multipleUserList[0];
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultipleUserScreen(
                  username: usernameController.text.trim(),
                  password: passwordController.text.trim(),
                  academicYear: strloginType,
                  multipleUserList: userList,
                ),
              ),
            );
          } else {
            setState(() {
              
            });
          }
        } else {
          setState(() {
            mobileNumber = 'API response indicates an error';
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Login error: $e');
    }
  }

  void handleRadioValueChanged(int value) {
    setState(() {
      selectedRadio = value;
      strloginType = value == 1 ? 'Teacher' : 'Parent';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            DropdownButtonFormField(
              value: selectedAcademicYear,
              items: academicDataList.map((academicYear) {
                return DropdownMenuItem<String>(
                  value: academicYear['academic_year_id'],
                  child: Text(academicYear['academic_year_name']),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedAcademicYear = newValue!;
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.calendar_today),
                labelText: 'Select Academic Year',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Radio(
                  value: 1,
                  groupValue: selectedRadio,
                  onChanged: (value) => handleRadioValueChanged(value as int),
                ),
                Text('Login as Teacher'),
                Radio(
                  value: 2,
                  groupValue: selectedRadio,
                  onChanged: (value) => handleRadioValueChanged(value as int),
                ),
                Text('Login as Parent'),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                login();
              },
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            Text(
              'Mobile Number: $mobileNumber',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              apiData,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
