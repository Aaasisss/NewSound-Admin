import 'package:newsound_admin/Screens/Add_Events/add_events.dart';
import 'package:newsound_admin/Screens/Bank_Details/bank_details.dart';
import 'package:newsound_admin/Screens/Home/home_page.dart';
import 'package:newsound_admin/Screens/Links/links.dart';
import 'package:newsound_admin/Screens/Settings/settings.dart';
import 'package:newsound_admin/Screens/View_Events/view_events.dart';

var approute = {
  '/add_events': (context) => const AddEvents(),
  '/bank_details': (context) => const BankDetails(),
  '/home': (context) => const HomePage(),
  '/links': (context) => const Links(),
  '/settings': (context) => const Settings(),
  '/view_events': (context) => const ViewEvents(),
};
