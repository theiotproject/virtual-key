import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EmergencyOpen extends StatefulWidget {
  const EmergencyOpen({Key? key}) : super(key: key);

  @override
  State<EmergencyOpen> createState() => _EmergencyOpenState();
}

class _EmergencyOpenState extends State<EmergencyOpen> {
  final qrDataController = TextEditingController();
  final guidRegExp = RegExp(
      r'^[a-zA-Z0-9]{8}\-[a-zA-Z0-9]{4}\-[a-zA-Z0-9]{4}\-[a-zA-Z0-9]{4}\-[a-zA-Z0-9]{12}$');
  // final guidRegExp = RegExp(r'^[a-zA-Z0-9]+$');
  String qrTextData = "";
  String textMsg = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Emergency Lock Opening'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            QrImage(
              data: qrTextData,
              size: 200,
              backgroundColor: Colors.white,
            ),
            TextField(
                controller: qrDataController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Type your code here',
                  hintText: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
                ),
                textInputAction: TextInputAction.done),
            ElevatedButton(
              onPressed: () {
                if (guidRegExp.hasMatch(qrDataController.text)) {
                  setState(() {
                    qrTextData = qrDataController.text;
                    textMsg = 'Code accepted';
                  });
                } else {
                  setState(() {
                    textMsg = 'This is not a valid code';
                  });
                }
              },
              child: const Text('Generate emergency key'),
            ),
            Text(textMsg),
          ],
        ),
      ),
    );
  }
}
