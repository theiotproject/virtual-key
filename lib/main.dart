import 'package:flutter/material.dart';
import 'package:virtual_key/emergency_open.dart';
import 'package:virtual_key/home.dart';
import 'package:virtual_key/login.dart';
import 'package:virtual_key/user_gates.dart';

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
        primarySwatch: Colors.lightGreen,
        scaffoldBackgroundColor: Colors.grey,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/emergency_open': (context) => const EmergencyOpen(),
        '/login': (context) => const Login(),
        '/user_gates': (context) => const UserGates()
      },
    );
  }
}
