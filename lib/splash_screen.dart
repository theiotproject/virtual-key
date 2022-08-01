import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:virtual_key/globals.dart';
import 'package:virtual_key/services/remote_service.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = FlutterSecureStorage();
  String? userToken;

  @override
  void initState() {
    storage.read(key: 'KEY_TOKEN').then((value) {
      token = value;
      if (token != null) {
        loginUser(value);
      }
    });

    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(
          context, userToken == null ? '/' : '/user_hub'),
    );

    super.initState();
  }

  loginUser(value) async {
    user = await RemoteService().getUser(http.Client());
    if (user != null) {
      isLogged = true;
      userToken = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}
