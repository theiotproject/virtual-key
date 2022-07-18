import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:virtual_key/globals.dart';
import 'package:virtual_key/models/team.dart';
import 'package:virtual_key/services/remote_service.dart';
import 'package:virtual_key/widgets/custom_appbar.dart';

class KeyCode extends StatefulWidget {
  const KeyCode({Key? key}) : super(key: key);

  @override
  State<KeyCode> createState() => _KeyCodeState();
}

class _KeyCodeState extends State<KeyCode> {
  List<Team>? teams;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    //fetch data from API
    getData();
  }

  getData() async {
    teams = await RemoteService().getTeams(user!.id);
    if (teams != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    return Scaffold(
      appBar: CustomAppBar('${arguments['name']} key', true),
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: Center(
          child: QrImage(
            data: '2022-07-18 11:59:21/MSDECVKOPN',
            size: 300,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
