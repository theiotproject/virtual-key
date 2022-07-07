import 'package:flutter/material.dart';
import 'package:virtual_key/emergency_open.dart';
import 'package:virtual_key/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Key',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        backgroundColor: Colors.grey,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/emergency_open': (context) => const EmergencyOpen()
      },
    );
  }
}
