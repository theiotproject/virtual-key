import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page'), actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return const [
              PopupMenuItem<int>(
                value: 0,
                child: Text("Emergency lock opening"),
              ),
            ];
          },
          onSelected: (value) {
            switch (value) {
              case 0:
                Navigator.pushNamed(context, '/emergency_open');
                break;
            }
          },
        ),
      ]),
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
          ],
        ),
      ),
    );
  }
}
