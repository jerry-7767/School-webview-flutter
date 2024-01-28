import 'package:flutter/material.dart';

class MultipleUserScreen extends StatefulWidget {

 final String username;
  final String password;
  final String academicYear;
  final Map<String, dynamic> multipleUserList;

  MultipleUserScreen({
    required this.username,
    required this.password,
    required this.academicYear,
    required this.multipleUserList,
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
