import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'main.dart';

class DosagePage extends StatelessWidget {
  const DosagePage({super.key});

  Object databaseQuery() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Species/Cattle/Drugs");

    DatabaseEvent event = await ref.once();
    debugPrint("Snapshot type: ${event.type}");
    debugPrint("Snapshot: ${event.snapshot.value}");

    //shows the data here

    return event.snapshot.value;
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    // debugPrint(appState.curAnimal);

    var animal = appState.curAnimal;
    Object event = databaseQuery();

    debugPrint("Snapshot 2: $event");

    //shows "Instance of 'Future<dynamic>'" here instead of the actual data

    return Scaffold(
        appBar: AppBar(
          title: Text('Drugs for $animal'),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center, children: const []),
        ));
  }
}
