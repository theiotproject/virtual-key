import 'package:flutter/material.dart';
import 'package:virtual_key/globals.dart';
import 'package:virtual_key/models/team.dart';
import 'package:virtual_key/services/remote_service.dart';
import 'package:virtual_key/widgets/custom_appbar.dart';

class AdminTeams extends StatefulWidget {
  const AdminTeams({Key? key}) : super(key: key);

  @override
  State<AdminTeams> createState() => _AdminTeamsState();
}

class _AdminTeamsState extends State<AdminTeams> {
  List<Team>? teams;
  List<Team> adminTeams = [];
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
      appBar: CustomAppBar('Your teams - admin', false),
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
                    adminTeamId = adminTeams[index].id;
                    Navigator.pushNamed(context, '/admin_gates');
                  },
                ),

                //Drop down list design for future use
                /*
                key: PageStorageKey(0),
                color: Colors.white,
                elevation: 4,
                child: ExpansionTile(
                  controlAffinity: ListTileControlAffinity.trailing,
                  childrenPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  expandedCrossAxisAlignment: CrossAxisAlignment.end,
                  maintainState: true,
                  title: Text(
                    adminTeams[index].name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: const [
                    Text(
                      "gatename",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                */
              );
            }),
      ),
    );
  }
}
