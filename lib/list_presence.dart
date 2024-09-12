import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presence_hr_app/db/presence.dart';
import 'package:presence_hr_app/model/presence_model.dart';

class ListPresence extends StatefulWidget {
  const ListPresence({super.key});

  @override
  State<ListPresence> createState() => _ListPresenceState();
}

class _ListPresenceState extends State<ListPresence> {
  // Placeholder for presence data from repository
  List<Presence> _listPresence = [];
  final PresenceRepo _presenceRepo = PresenceRepo.instance;

  @override
  void initState() {
    super.initState();
    _fetchPresenceEntries();
  }

  Future<void> _fetchPresenceEntries() async {
    try {
      var listData = await _presenceRepo.readAll("john_doe");
      print("$listData");
      setState(() {
        _listPresence = listData;
      });
    } catch (e) {
      // Handle any errors that occur during data fetching
      print("Error fetching presence entries: $e");
    }
  }

  String dateTimeFormatter(String dateTimeOld) {
    DateTime dateTime = DateTime.parse(dateTimeOld);

    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);
    print(formattedDate);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presence List'),
      ),
      body: ListView.builder(
        itemCount: _listPresence.length,
        itemBuilder: (context, index) {
          print("${_listPresence.length}");
          final entry = _listPresence[index];

          return ListTile(
            title: Text(
                'Presence at ${dateTimeFormatter(entry.presenceTime.toString())}'),
            subtitle: Text(
                'Go Home at ${dateTimeFormatter(entry.goHomeTime.toString())}\nLat: ${entry.latitude}, Long: ${entry.longitude}'),
            trailing: const Icon(Icons.location_on),
          );
        },
      ),
    );
  }
}
