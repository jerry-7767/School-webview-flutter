// import 'dart:convert';
// import 'package:flutter_application_1/webviewcommon.dart';
// import 'package:http/http.dart' as http;

// import 'package:flutter/material.dart';

// class MultipleUserScreen extends StatefulWidget {
//   final username;
//   final password;
//   final academicYear;
//   final multipleUserList;
//   final selectedRadio;

//   MultipleUserScreen(
//       {super.key,
//       this.academicYear,
//       this.multipleUserList,
//       this.password,
//       this.username,
//       this.selectedRadio});

//   @override
//   State<MultipleUserScreen> createState() => _MultipleUserScreenState();
// }

// class _MultipleUserScreenState extends State<MultipleUserScreen> {
//   var baseUrl =
//       'https://dds-erp.com/olps-mobile/MobileAppLogin/mobileForcefullyLoginNew/';

//   @override
//   void initState() {
//     print('get List   ---${widget.multipleUserList}');
//     print('get List   ---${widget.academicYear}');

//     // TODO: implement initState
//     super.initState();
//   }

//   Future<void> login(String getId, String getType) async {
//     try {
//       final response = await http.post(
//         Uri.parse('https://dds-erp.com/olps/mobile/MobileCommon/doLoginNew'),
//         body: {
//           'username': widget.username,
//           'password': widget.password,
//           'account_type': getType,
//           'academic_year': widget.academicYear,
//           'regi_id': getId,
//           'device_token': 'fj3f823jfo',
//         },
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data =
//             json.decode(utf8.decode(response.bodyBytes));
//         if (data['status'] == true) {
//           final List multipleUserList = data['multiple_user_data'];
//           if (multipleUserList.isNotEmpty) {
//             final List userList = multipleUserList;
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(
//             //     builder: (context) => MultipleUserScreen(
//             //       username: usernameController.text.trim(),
//             //       password: passwordController.text.trim(),
//             //       academicYear: strloginType,
//             //       multipleUserList: userList,
//             //     ),
//             //   ),
//             // );
//           } else {
//             print('api callllll---------------->');
//             String url = baseUrl +
//                 "?username=${widget.username}" +
//                 "&password=${base64Encode(utf8.encode(widget.password))}" +
//                 "&account_type=${widget.selectedRadio}" +
//                 "&academic_year=${widget.academicYear}" +
//                 "&regi_id=${getId}" +
//                 "&device_token=fj3f823jfo";
//             print('get base url$url');
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
//             // mobileNumber = 'API response indicates an error';
//           });
//         }
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print('Login error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
        
    
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Select User",
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     itemBuilder: (contex, i) {
//                       return GestureDetector(
//                         onTap: () async {
//                           print("button call");
//                           await login(
//                               widget.multipleUserList[i]['regi_id'].toString(),
//                               widget.selectedRadio);
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.only(bottom: 10),
//                           child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: Colors.white,
//                                 border: Border.all(
//                                   color: Color(0xFFF05A22),
//                                   style: BorderStyle.solid,
//                                   width: 1.0,
//                                 ),
//                               ),
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 5),
//                                 child: Column(
//                                   children: [
//                                     TextCommanClass(
//                                       Text1: 'Reg id:',
//                                       Text2: widget.multipleUserList[i]
//                                               ['regi_id']
//                                           .toString(),
//                                     ),
//                                     TextCommanClass(
//                                       Text1: 'Full Name:',
//                                       Text2: widget.multipleUserList[i]
//                                               ['first_name']
//                                           .toString(),
//                                     ),
//                                     TextCommanClass(
//                                       Text1: 'Class:',
//                                       Text2: widget.multipleUserList[i]['class']
//                                           .toString(),
//                                     ),
//                                   ],
//                                 ),
//                               )),
//                         ),
//                       );
//                     },
//                     itemCount: widget.multipleUserList.length,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }

// class TextCommanClass extends StatefulWidget {
//   final Text1;
//   final Text2;
//   TextCommanClass({super.key, this.Text1, this.Text2});

//   @override
//   State<TextCommanClass> createState() => _TextCommanClassState();
// }

// class _TextCommanClassState extends State<TextCommanClass> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 5),
//       child: Row(children: [
//         Text(
//           widget.Text1,
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
//         ),
//         Text(
//           widget.Text2,
//           style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//         )
//       ]),
//     );
//   }
// }
