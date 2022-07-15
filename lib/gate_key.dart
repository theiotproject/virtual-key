import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GateKey extends StatelessWidget {
  const GateKey({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        title: Text(arguments['name']),
      ),
      body: Center(
        child: QrImage(
          data: arguments['magic_code'],
          size: 200,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
