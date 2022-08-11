import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:virtual_key/globals.dart';
import 'package:virtual_key/services/remote_service.dart';
import 'package:virtual_key/widgets/custom_appbar.dart';
import 'package:http/http.dart' as http;

class ConfigCode extends StatefulWidget {
  const ConfigCode({Key? key}) : super(key: key);

  @override
  State<ConfigCode> createState() => _ConfigCodeState();
}

class _ConfigCodeState extends State<ConfigCode> {
  String? teamCode;
  bool isFunctionCalled = false;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    //fetch data from API
    getData();
  }

  getData() async {
    teamCode = await RemoteService().getTeamCode(http.Client(), adminTeamId);

    if (teamCode != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  generateConfigCodeData(String magicCode, String serialNumber) {
    return 'CONF:$magicCode;$teamCode;$serialNumber;;';
  }

  sendEvent(String magicCode) async {
    String uuid = const Uuid().v1();
    String message = 'GENERATED CONFIG CODE';
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
      appBar: CustomAppBar('${arguments['name']} config', true),
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: Center(
          child: QrImage(
            data: generateConfigCodeData(
                arguments['magic_code'], arguments['serial_number']),
            size: 300,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
