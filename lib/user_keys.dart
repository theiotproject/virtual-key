import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:virtual_key/globals.dart';
import 'package:virtual_key/models/gate.dart';
import 'package:virtual_key/models/virtual_key.dart';
import 'package:virtual_key/services/remote_service.dart';
import 'package:virtual_key/widgets/custom_appbar.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_key/widgets/empty_list_text.dart';
import 'package:virtual_key/widgets/no_cache_and_internet_msg.dart';

class UserKeys extends StatefulWidget {
  const UserKeys({Key? key}) : super(key: key);

  @override
  State<UserKeys> createState() => _UserKeysState();
}

class _UserKeysState extends State<UserKeys> {
  List<VirtualKey>? keys;
  List<Gate>? keyGates;
  bool isLoaded = false;
  bool isListEmpty = false;
  bool isCacheClearAndConnLost = false;
  String? remoteGate;

  @override
  void initState() {
    super.initState();

    //fetch data from API
    getData();
  }

  getData() async {
    keys = await RemoteService().getKeys(http.Client(), user!.id);
    if (keys != null) {
      setState(() {
        isLoaded = true;
      });
      if (keys!.isEmpty) {
        isListEmpty = true;
      }
    }
    final userId = user!.id;
    // check if data is cached
    var internetConnection = await Connectivity().checkConnectivity();
    if (internetConnection == ConnectivityResult.none) {
      String fileName = "keys${userId}Path.json";
      var dir = await getTemporaryDirectory();
      File file = File('${dir.path}/${fileName}');
      if (!file.existsSync()) {
        setState(() {
          isCacheClearAndConnLost = true;
        });
      }
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
    return Scaffold(
      appBar: CustomAppBar('Virtual Keys', false),
      body: Column(
        children: [
          const Divider(),
          isCacheClearAndConnLost
              ? const NoCacheAndInternet()
              : Visibility(
                  visible: isLoaded,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: isListEmpty
                      ? const EmptyListText(
                          title: 'There are no keys assigned to you')
                      : Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(16),
                              itemCount: keys?.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 5,
                                  clipBehavior: Clip.antiAlias,
                                  child: Dismissible(
                                    background: Container(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: const Padding(
                                        padding: EdgeInsets.only(left: 24.0),
                                        child: Icon(
                                          Icons.wifi,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    key: ValueKey<int>(keys![index].id),
                                    confirmDismiss:
                                        (DismissDirection direction) async {
                                      // Open gate remotely when internet connection is available
                                      var internetConnection =
                                          await Connectivity()
                                              .checkConnectivity();

                                      if (internetConnection !=
                                          ConnectivityResult.none) {
                                        String uuid = const Uuid().v1();
                                        String validDays =
                                            keys![index].validDays;

                                        bool accessGranted =
                                            isValidDay(validDays);

                                        if (accessGranted) {
                                          getKeyGates(keys![index].id)
                                              .then((value) {
                                            if (keyGates!.length > 1) {
                                              showGatesAlertDialog(context);
                                            } else {
                                              selectedTeamId = keys![index].teamId;
                                              openGateRemotely(
                                                  keyGates![0].serialNumber);
                                            }
                                          });
                                        }

                                        sendEvent(uuid, keys![index].id,
                                            accessGranted);
                                      } else {
                                        showNoWifiSnackbar(context);
                                      }

                                      // don't dismiss widget
                                      return false;
                                    },
                                    child: ListTile(
                                      title: Text(
                                        keys![index].label,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(keys![index].teamName),
                                      onTap: () {
                                        selectedKeyId = keys![index].id;
                                        selectedTeamId = keys![index].teamId;
                                        Navigator.pushNamed(
                                            context, '/key_code',
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
  }

  void showNoWifiSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue,
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.wifi_off,
              color: Colors.white,
            ),
            Text("You don't have internet access",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
