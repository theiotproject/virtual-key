import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:virtual_key/widgets/custom_appbar.dart';

class GateKey extends StatelessWidget {
  const GateKey({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    return Scaffold(
      appBar: CustomAppBar(arguments['name'], true),
      body: Center(
        child: QrImage(
          data: arguments['magic_code'],
          size: 300,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
