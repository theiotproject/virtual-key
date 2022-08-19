import 'package:flutter/material.dart';
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
            Image.asset('assets/images/logo.png', height: 100, width: 100),
            const SizedBox(height: 10),
            Image.asset('assets/images/qrcodebusiness.png'),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'We\'re glad you\'re here, \n let\'s get started',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 300,
              height: 40,
              child: ElevatedButton(
                onPressed: () async {
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
