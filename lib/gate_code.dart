import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:virtual_key/globals.dart';
import 'package:virtual_key/services/remote_service.dart';
import 'package:virtual_key/widgets/custom_appbar.dart';

class GateCode extends StatefulWidget {
  const GateCode({Key? key}) : super(key: key);

  @override
  State<GateCode> createState() => _GateCodeState();
}

class _GateCodeState extends State<GateCode> {
  bool isFunctionCalled = false;

  sendEvent(String magicCode) async {
    String uuid = const Uuid().v1();
    String message = 'GENERATED BACKUP CODE';
    int userId = user!.id;

    await RemoteService()
        .sendBackupCodeGenerationEvent(uuid, magicCode, message, userId);
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    if (!isFunctionCalled) {
      setState(() {
        sendEvent(arguments['magic_code']);
        isFunctionCalled = true;
      });
    }
    return Scaffold(
      appBar: CustomAppBar(arguments['name'], true),
      body: Center(
        child: QrImage(
          data: 'MAGIC:${arguments['magic_code']};',
          size: 300,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
