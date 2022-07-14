import 'package:flutter/material.dart';
import 'package:virtual_key/globals.dart';
import 'package:virtual_key/models/team.dart';
import 'package:virtual_key/services/remote_service.dart';

class UserTeams extends StatefulWidget {
  const UserTeams({Key? key}) : super(key: key);

  @override
  State<UserTeams> createState() => _UserTeamsState();
}

class _UserTeamsState extends State<UserTeams> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your teams'),
      ),
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: teams?.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(
                    teams![index].name,
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
