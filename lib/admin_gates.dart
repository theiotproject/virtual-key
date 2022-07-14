import 'package:flutter/material.dart';
import 'package:virtual_key/globals.dart';
import 'package:virtual_key/models/team.dart';
import 'package:virtual_key/services/remote_service.dart';

class AdminGates extends StatefulWidget {
  const AdminGates({Key? key}) : super(key: key);

  @override
  State<AdminGates> createState() => _AdminGatesState();
}

class _AdminGatesState extends State<AdminGates> {
  List<Team>? teams;
  bool isLoaded = false;

  List<Team> adminTeams = [];

  @override
  void initState() {
    super.initState();

    //fetch data from API
    getData();
  }

  getData() async {
    teams = await RemoteService().getTeams(user!.id);

    if (teams != null) {
      teams?.forEach((element) async {
        bool isAdmin = await RemoteService().checkAdmin(element.id) == '1';
        if (isAdmin) {
          adminTeams.add(element);
          setState(() {
            isLoaded = true;
          });
        }
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
            itemCount: adminTeams.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(
                    adminTeams[index].name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/gate_key',
                        arguments: {"id": teams![index].id.toString()});
                  },
                ),
              );
            }),
      ),
    );
  }
}
