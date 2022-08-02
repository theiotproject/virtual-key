import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:virtual_key/widgets/custom_appbar.dart';

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
  bool showQr = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar('Generate backup code', true),
      body: Center(
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.start,
          padding: const EdgeInsets.all(32),
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: 350,
              child: TextField(
                controller: qrDataController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'Type your code here',
                  labelStyle: const TextStyle(color: Colors.black),
                  hintText: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
                ),
                textInputAction: TextInputAction.done,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (guidRegExp.hasMatch(qrDataController.text)) {
                  setState(() {
                    qrTextData = 'MAGIC:${qrDataController.text};';
                    textMsg = 'Code accepted';
                    showQr = true;
                  });
                } else {
                  setState(() {
                    textMsg = 'This is not a valid code';
                    showQr = false;
                  });
                }
              },
              child: const Text('Generate'),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                textMsg,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Visibility(
                visible: showQr,
                child: QrImage(
                  data: qrTextData,
                  size: 300,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
