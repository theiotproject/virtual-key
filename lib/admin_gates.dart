import 'package:flutter/material.dart';
import 'package:virtual_key/globals.dart';
import 'package:virtual_key/models/gate.dart';
import 'package:virtual_key/services/remote_service.dart';
import 'package:virtual_key/widgets/custom_appbar.dart';

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
    gates = await RemoteService().getGates(adminTeamId);

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
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: gates?.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
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
                    Navigator.pushNamed(context, '/gate_code', arguments: {
                      "name": gates![index].name,
                      "magic_code": gates![index].magicCode,
                    });
                  },
                ),
              );
            }),
      ),
    );
  }
}
