import 'package:flutter/material.dart';
import 'package:newsound_admin/Screens/Add_Events/add_events.dart';
import 'package:newsound_admin/Screens/Bank_Details/bank_details.dart';
import 'package:newsound_admin/Screens/Links/links.dart';
import 'package:newsound_admin/Screens/Login/login_page.dart';
import 'package:newsound_admin/Screens/Settings/settings.dart';
import 'package:newsound_admin/Screens/View_Events/view_events.dart';
import 'package:newsound_admin/Shared/Routes/approute.dart';
import 'Screens/Home/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'New Sound Admin App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      routes: approute,
    );
  }
}
