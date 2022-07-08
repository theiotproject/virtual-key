import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Log In'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/emergency_open');
              },
              child: const Text('Emergency lock opening'),
            ),
          ],
        ),
      ),
    );
  }
}
