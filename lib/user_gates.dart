import 'package:flutter/material.dart';
import 'package:virtual_key/models/gate.dart';
import 'package:virtual_key/services/remote_service.dart';

class UserGates extends StatefulWidget {
  const UserGates({Key? key}) : super(key: key);

  @override
  State<UserGates> createState() => _UserGatesState();
}

class _UserGatesState extends State<UserGates> {
  List<Gate>? gates;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    //fetch data from API
    getData();
  }

  getData() async {
    gates = await RemoteService().getGates();
    if (gates != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your gates'),
      ),
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: gates?.length,
            itemBuilder: (context, index) {
              return Container(
                child: Text(
                  gates![index].title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
      ),
    );
  }
}
