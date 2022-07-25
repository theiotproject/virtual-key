import 'package:flutter/material.dart';
import 'package:virtual_key/globals.dart';
import 'package:virtual_key/models/virtual_key.dart';
import 'package:virtual_key/services/remote_service.dart';
import 'package:virtual_key/widgets/custom_appbar.dart';

class UserKeys extends StatefulWidget {
  const UserKeys({Key? key}) : super(key: key);

  @override
  State<UserKeys> createState() => _UserKeysState();
}

class _UserKeysState extends State<UserKeys> {
  List<VirtualKey>? keys;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    //fetch data from API
    getData();
  }

  getData() async {
    keys = await RemoteService().getKeys(selectedTeamId);
    if (keys != null) {
      setState(() {
        isLoaded = true;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    return Scaffold(
      appBar: CustomAppBar('${arguments['name']} keys', true),
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
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: keys?.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        title: Text(
                          keys![index].label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          selectedKeyId = keys![index].id;
                          Navigator.pushNamed(context, '/key_code', arguments: {
                            "label": keys![index].label,
                            "is_valid_day": isValidDay(
                              keys![index].validDays,
                            ),
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
