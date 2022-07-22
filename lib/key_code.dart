import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:virtual_key/globals.dart';
import 'package:virtual_key/models/gate.dart';
import 'package:virtual_key/services/remote_service.dart';
import 'package:virtual_key/widgets/custom_appbar.dart';

class KeyCode extends StatefulWidget {
  const KeyCode({Key? key}) : super(key: key);

  @override
  State<KeyCode> createState() => _KeyCodeState();
}

class _KeyCodeState extends State<KeyCode> {
  List<Gate>? gates;
  List<String> gatesNumbers = [];
  bool isLoaded = false;
  bool showCode = false;

  String now = DateTime.now().toString().substring(0, 19);

  @override
  void initState() {
    super.initState();

    //fetch data from API
    getData();
  }

  getData() async {
    gates = await RemoteService().getKeyGates(selectedKeyId);
    if (gates != null) {
      gates?.forEach((element) => gatesNumbers.add(element.serialNumber));
      setState(() {
        isLoaded = true;
      });
    }
  }

  generateCodeData() {
    String uuid = const Uuid().v1();
    String createdAt = DateTime.now().toString().substring(0, 19);
    String gNum = '';
    gatesNumbers.asMap().forEach((index, element) {
      if (gatesNumbers.length - 1 == index) {
        gNum += '${element};';
      } else {
        gNum += '${element},';
      }
    });

    return 'OPEN:ID:${uuid};CA:${createdAt};G:${gNum}';
  }

  checkDay() {
    int weekday = DateTime.now().weekday;

    Map days = <int, String>{
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
      7: 'Sunday'
    };

    return days[weekday];
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
          child: arguments['is_valid_day']
              ? QrImage(
                  data: generateCodeData(),
                  size: 300,
                  backgroundColor: Colors.white,
                )
              : Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Your code doesn\'t work on ${checkDay()}s',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
