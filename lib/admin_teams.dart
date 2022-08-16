import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:virtual_key/globals.dart';
import 'package:virtual_key/models/team.dart';
import 'package:virtual_key/services/remote_service.dart';
import 'package:virtual_key/widgets/custom_appbar.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_key/widgets/no_cache_and_internet_msg.dart';

class AdminTeams extends StatefulWidget {
  const AdminTeams({Key? key}) : super(key: key);

  @override
  State<AdminTeams> createState() => _AdminTeamsState();
}

class _AdminTeamsState extends State<AdminTeams> {
  List<Team>? teams;
  List<Team> adminTeams = [];
  bool isLoaded = false;
  bool isCacheClearAndConnLost = false;

  @override
  void initState() {
    super.initState();

    //fetch data from API
    getData();
  }

  getData() async {
    teams = await RemoteService().getTeams(http.Client(), user!.id);

    if (teams != null) {
      teams?.forEach((element) async {
        bool isAdmin =
            await RemoteService().checkAdmin(http.Client(), element.id) == '1';
        if (isAdmin) {
          adminTeams.add(element);
          setState(() {
            isLoaded = true;
          });
        }
      });
    }
    // check if data is cached
    var internetConnection = await Connectivity().checkConnectivity();
    if (internetConnection == ConnectivityResult.none) {
      String fileName = "teamsPath.json";
      var dir = await getTemporaryDirectory();
      File file = File('${dir.path}/${fileName}');
      if (!file.existsSync()) {
        setState(() {
          isCacheClearAndConnLost = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Your teams - admin', false),
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
                  child: Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: adminTeams.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 5,
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
                          );
                        }),
                  ),
                ),
        ],
      ),
    );
  }
}
