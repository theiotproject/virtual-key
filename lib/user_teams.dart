import 'package:flutter/material.dart';
import 'package:virtual_key/globals.dart';
import 'package:virtual_key/models/team.dart';
import 'package:virtual_key/services/remote_service.dart';
import 'package:virtual_key/widgets/custom_appbar.dart';

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
      appBar: CustomAppBar('Your teams', false),
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
                  itemCount: teams?.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
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
                          selectedTeamId = teams![index].id;
                          Navigator.pushNamed(context, '/key_code', arguments: {
                            "name": teams![index].name,
                          });
                        },
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
