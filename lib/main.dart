import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_screen.dart';
void main() { 
runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: 'login_screen',
  routes: {
    'login_screen' : (context) => LoginPage()
  } ,
)); 
}




 
