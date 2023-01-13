import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:virtual_key/globals.dart';
import 'package:virtual_key/models/gate.dart';
import 'package:virtual_key/services/remote_service.dart';
import 'package:virtual_key/widgets/custom_appbar.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_key/widgets/no_cache_and_internet_msg.dart';

class KeyCode extends StatefulWidget {
  const KeyCode({Key? key}) : super(key: key);

  @override
  State<KeyCode> createState() => _KeyCodeState();
}

class _KeyCodeState extends State<KeyCode> {
  Duration duration = const Duration(minutes: 1);
  Timer? timer;

  List<Gate>? gates;
  List<String> gatesNumbers = [];

  bool isLoaded = false;
  bool showCode = false;
  bool isFunctionCalled = false;
  bool isExpired = false;
  bool isCacheClearAndConnLost = false;

  String? teamCode;
  String now = DateTime.now().toString().substring(0, 19);
  String qrData = '';

  @override
  void initState() {
    super.initState();

    //fetch data from API
    getData();
    startTimer();
  }

  getData() async {
    gates = await RemoteService().getKeyGates(http.Client(), selectedKeyId);

    teamCode = await RemoteService()
        .getTeamCode(http.Client(), selectedTeamId, selectedKeyId);

    if (gates != null && teamCode != null) {
      gates?.forEach((element) => gatesNumbers.add(element.serialNumber));
      setState(() {
        isLoaded = true;
      });
    }
    // check if data is cached
    var internetConnection = await Connectivity().checkConnectivity();
    if (internetConnection == ConnectivityResult.none) {
      String fileNameCode = "getTeamCode${selectedTeamId}Path.json";
      String fileNameGates = "keyGates${selectedKeyId}Path.json";
      var dir = await getTemporaryDirectory();
      File fileCode = File('${dir.path}/${fileNameCode}');
      File fileGates = File('${dir.path}/${fileNameGates}');
      if (!fileCode.existsSync() || !fileGates.existsSync()) {
        setState(() {
          isCacheClearAndConnLost = true;
        });
      }
    }
  }

  countDown() {
    final decreaseSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds - decreaseSeconds;

      if (seconds < 0) {
        timer?.cancel();
        isExpired = true;
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => countDown());
  }

  generateCodeData(bool isValid) {
    int? virtualKeyId = selectedKeyId;
    String uuid = const Uuid().v1();

    int unixFrom = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    int unixTo = (DateTime.now()
        .add(const Duration(minutes: 1)).millisecondsSinceEpoch / 1000).floor();

    String validFrom = unixFrom.toString();
    String validTo = unixTo.toString();

    String gNum = '';
    gatesNumbers.asMap().forEach((index, element) {
      if (gatesNumbers.length - 1 == index) {
        gNum += '$element;';
      } else {
        gNum += '$element,';
      }
    });

    sendEvent(uuid, virtualKeyId!, isValid);

    String keyData = 'OPEN:ID:$uuid;VF:$validFrom;VT:$validTo;L:$gNum;';

    String dataToHash = '$keyData$teamCode';
    List<int> dataInBytes = utf8.encode(dataToHash);
    Digest digestedData = sha256.convert(dataInBytes);

    if (isValid) {
      return '${keyData}S:${digestedData.toString()};';
    } else {
      return 'ACCESS DENIED';
    }
  }

  sendEvent(String id, int virtualKeyId, bool accessGranted) async {
    String message = '';
    if (accessGranted) {
      message = 'ACCESS GRANTED';
    } else {
      message = 'ACCESS DENIED: WEEKDAY IS NOT CORRECT';
    }

    await RemoteService()
        .sendKeyCodeGenerationEvent(id, virtualKeyId, accessGranted, message);
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
    if (!isFunctionCalled && isLoaded) {
      setState(() {
        qrData = generateCodeData(arguments['is_valid_day']);
        isFunctionCalled = true;
      });
    }
    return Scaffold(
      appBar: CustomAppBar('${arguments['label']}', true),
      body: isCacheClearAndConnLost
          ? const Center(child: NoCacheAndInternet())
          : Visibility(
              visible: isLoaded,
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
              child: Center(
                child: arguments['is_valid_day']
                    ? isExpired
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Code expired',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () {
                                  duration = const Duration(minutes: 1);
                                  startTimer();
                                  setState(() {
                                    qrData = generateCodeData(
                                        arguments['is_valid_day']);

                                    isExpired = false;
                                  });
                                },
                                child: const Text('Generate again'),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              const SizedBox(height: 32),
                              const Text(
                                'This code will expire in:',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              buildTimer(),
                              const SizedBox(height: 24),
                              QrImage(
                                data: qrData,
                                size: 300,
                                backgroundColor: Colors.white,
                              ),
                            ],
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

  Widget buildTimer() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Text(
      '$minutes:$seconds',
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
