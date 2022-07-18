import 'package:flutter/material.dart';
import 'package:virtual_key/widgets/custom_appbar.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('', false),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            const SizedBox(height: 24),
            Image.asset('assets/images/qrcodebusiness.png'),
            const SizedBox(height: 24),
            const Text(
              'We\'re glad you\'re here, \n let\'s get started',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
