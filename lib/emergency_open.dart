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
            const SizedBox(height: 10),
            QrImage(
              data: qrTextData,
              size: 200,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 350,
              child: TextField(
                controller: qrDataController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Type your code here',
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
                ),
                textInputAction: TextInputAction.done,
                style: const TextStyle(fontSize: 20),
              ),
            ),
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
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Generate emergency key'),
            ),
            Text(textMsg),
          ],
        ),
      ),
    );
  }
}
