import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:uuid/uuid.dart';
import 'package:virtual_key/globals.dart';
import 'package:virtual_key/models/gate.dart';
import 'package:virtual_key/models/virtual_key.dart';
import 'package:virtual_key/services/remote_service.dart';
import 'package:virtual_key/widgets/custom_appbar.dart';
import 'package:http/http.dart' as http;

class UserKeys extends StatefulWidget {
  const UserKeys({Key? key}) : super(key: key);

  @override
  State<UserKeys> createState() => _UserKeysState();
}

class _UserKeysState extends State<UserKeys> {
  List<VirtualKey>? keys;
  List<Gate>? keyGates;
  bool isLoaded = false;
  String? remoteGate;

  late ConnectivityResult internetConnection;

  @override
  void initState() {
    super.initState();

    //fetch data from API
    getData();
  }

  getData() async {
    keys = await RemoteService().getKeys(http.Client(), selectedTeamId);
    internetConnection = await Connectivity().checkConnectivity();
    if (keys != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getKeyGates(virtualKeyId) async {
    keyGates = await RemoteService().getKeyGates(http.Client(), virtualKeyId);
  }

  isValidDay(validDays) {
    int weekday = DateTime.now().weekday;
    Map days = <int, String>{
      1: 'M',
      2: 'T',
      3: 'W',
      4: 'R',
      5: 'F',
      6: 'S',
      7: 'U'
    };

    return validDays.contains(days[weekday]);
  }

  openGateRemotely(String gate) async {
    String uuid = const Uuid().v1();
    String validFrom = DateTime.now().toString().substring(0, 19);
    String validTo = DateTime.now()
        .add(const Duration(minutes: 1))
        .toString()
        .substring(0, 19);

    await RemoteService()
        .remoteOpen(uuid, validFrom, validTo, gate, selectedTeamId!);
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

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    return Scaffold(
      appBar: CustomAppBar('${arguments['name']} keys', true),
      body: Column(
        children: [
          const Divider(),
          Visibility(
            visible: isLoaded,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: keys?.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      child: Slidable(
                        // Swipe from left to right to show remote openning button
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          extentRatio: 0.2,
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                // Open gate remotely when internet connection is available
                                if (internetConnection !=
                                    ConnectivityResult.none) {
                                  String uuid = const Uuid().v1();
                                  String validDays = keys![index].validDays;

                                  bool accessGranted = isValidDay(validDays);

                                  if (accessGranted) {
                                    getKeyGates(keys![index].id).then((value) {
                                      showGatesAlertDialog(context);
                                    });
                                  }

                                  sendEvent(
                                      uuid, keys![index].id, accessGranted);
                                }
                              },
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.wifi,
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            keys![index].label,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            selectedKeyId = keys![index].id;
                            Navigator.pushNamed(context, '/key_code',
                                arguments: {
                                  "label": keys![index].label,
                                  "is_valid_day": isValidDay(
                                    keys![index].validDays,
                                  ),
                                });
                          },
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  showGatesAlertDialog(BuildContext dialogContext) {
    // set up the button
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Select a gate"),
      content: SizedBox(
        width: 300,
        height: 300,
        child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: keyGates?.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 1,
                child: ListTile(
                  title: Text(
                    keyGates![index].name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, keyGates?[index].serialNumber);
                  },
                ),
              );
            }),
      ),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((valueFromDialog) {
      openGateRemotely(valueFromDialog);
    });
    ;
  }
}
