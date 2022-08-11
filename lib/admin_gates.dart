import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:virtual_key/globals.dart';
import 'package:virtual_key/models/gate.dart';
import 'package:virtual_key/services/remote_service.dart';
import 'package:virtual_key/widgets/custom_appbar.dart';
import 'package:http/http.dart' as http;

class AdminGates extends StatefulWidget {
  const AdminGates({Key? key}) : super(key: key);

  @override
  State<AdminGates> createState() => _AdminGatesState();
}

class _AdminGatesState extends State<AdminGates> {
  List<Gate>? gates;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    //fetch data from API
    getData();
  }

  getData() async {
    gates = await RemoteService().getGates(http.Client(), adminTeamId);

    if (gates != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Open gate', true),
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
                  padding: const EdgeInsets.all(16),
                  itemCount: gates?.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      child: Slidable(
                        // Swipe from left to right to open config menu
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          extentRatio: 0.2,
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                Navigator.pushNamed(context, '/config_code',
                                    arguments: {
                                      "name": gates![index].name,
                                      "magic_code": gates![index].magicCode,
                                      "serial_number":
                                          gates![index].serialNumber,
                                    });
                              },
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.settings,
                              //label: 'Config',
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            gates![index].name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/gate_code',
                                arguments: {
                                  "name": gates![index].name,
                                  "magic_code": gates![index].magicCode,
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
}
