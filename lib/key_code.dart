import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:virtual_key/globals.dart';
import 'package:virtual_key/services/remote_service.dart';
import 'package:virtual_key/widgets/custom_appbar.dart';

class KeyCode extends StatefulWidget {
  const KeyCode({Key? key}) : super(key: key);

  @override
  State<KeyCode> createState() => _KeyCodeState();
}

class _KeyCodeState extends State<KeyCode> {
  String? code;
  bool isLoaded = false;

  String now = DateTime.now().toString().substring(0, 19);

  @override
  void initState() {
    super.initState();

    //fetch data from API
    getData();
  }

  getData() async {
    code = await RemoteService().getKeyCode(selectedKeyId);
    if (code != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    return Scaffold(
      appBar: CustomAppBar('${arguments['label']}', true),
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: Center(
          child: QrImage(
            data: '$now/${code.toString()}',
            size: 300,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
