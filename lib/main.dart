import 'package:flutter/material.dart';
import 'package:newsound_admin/Screens/Add_Events/add_events.dart';
import 'package:newsound_admin/Screens/Bank_Details/bank_details.dart';
import 'package:newsound_admin/Screens/Links/links.dart';
import 'package:newsound_admin/Screens/Login/login_page.dart';
import 'package:newsound_admin/Screens/Settings/settings.dart';
import 'package:newsound_admin/Screens/View_Events/view_events.dart';
import 'package:newsound_admin/Services/auth.dart';
import 'package:newsound_admin/Shared/Routes/approute.dart';
import 'Screens/Home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'New Sound Admin App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const App(),
      routes: approute,
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'error!',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MainPage();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(
          body: Center(
            child: Text(
              'loading...',
              style: TextStyle(color: Colors.green),
            ),
          ),
        );
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthServive().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        } else if (snapshot.hasError) {
          return Text("error occured!");
        } else if (snapshot.hasData) {
          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
