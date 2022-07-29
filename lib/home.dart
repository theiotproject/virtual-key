import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:virtual_key/globals.dart';
import 'package:virtual_key/widgets/custom_appbar.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                fontSize: 28,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 300,
              height: 40,
              child: ElevatedButton(
                onPressed: () async {
                  const storage = FlutterSecureStorage();
                  token = (await storage.read(key: 'KEY_TOKEN'))!;

                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
