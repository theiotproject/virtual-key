import 'package:flutter/material.dart';
import 'package:virtual_key/admin_gates.dart';
import 'package:virtual_key/admin_teams.dart';
import 'package:virtual_key/config_code.dart';
import 'package:virtual_key/emergency_open.dart';
import 'package:virtual_key/gate_code.dart';
import 'package:virtual_key/home.dart';
import 'package:virtual_key/key_code.dart';
import 'package:virtual_key/login.dart';
import 'package:virtual_key/splash_screen.dart';
import 'package:virtual_key/user_hub.dart';
import 'package:virtual_key/user_keys.dart';
import 'package:virtual_key/values/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Virtual Key',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Montserrat',
        textTheme: const TextTheme(
          headline6: TextStyle(fontWeight: FontWeight.bold),
          bodyText2: TextStyle(fontWeight: FontWeight.w500),
          subtitle1: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          button: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colorBackground,
        ),
        dividerTheme: const DividerThemeData(
          space: 80,
          thickness: 3,
          color: Colors.blue,
          indent: 60,
          endIndent: 60,
        ),
      ),
      initialRoute: '/splash_screen',
      routes: {
        '/splash_screen': (context) => const SplashScreen(),
        '/': (context) => const Home(),
        '/login': (context) => const Login(),
        '/emergency_open': (context) => const EmergencyOpen(),
        '/user_hub': (context) => const UserHub(),
        '/admin_teams': (context) => const AdminTeams(),
        '/admin_gates': (context) => const AdminGates(),
        '/gate_code': (context) => const GateCode(),
        '/config_code': (context) => const ConfigCode(),
        '/user_keys': (context) => const UserKeys(),
        '/key_code': (context) => const KeyCode()
      },
    );
  }
}
