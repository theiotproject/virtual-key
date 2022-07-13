import 'package:flutter/material.dart';
import 'package:virtual_key/globals.dart';

class UserHub extends StatelessWidget {
  const UserHub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hub'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/user_teams');
              },
              child: const Text('View your teams'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/emergency_open');
              },
              child: const Text('Emergency lock opening'),
            ),
            ElevatedButton(
              onPressed: () {
                isLogged = false;
                token = null;
                user = null;

                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
