import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'main.dart';

class DosagePage extends StatelessWidget {
  const DosagePage({super.key});

  Future<Object?> databaseQuery() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Species/Cattle/Drugs");

    DatabaseEvent event = await ref.once();
    //debugPrint("Snapshot type: ${event.type}");
    //debugPrint("Snapshot: ${event.snapshot.value}");

    //shows the data here

    return event.snapshot.value;
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var animal = appState.curAnimal;
    var drugname = appState.curDrug;

    return Scaffold(
      appBar: AppBar(
        title: Text('Drugs for $animal'),
      ),
      body: FutureBuilder(
        future: databaseQuery(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // data has been loaded, build the widget tree
            var data = snapshot.data as List<dynamic>;

            //debugPrint("Snapshot 2: $data");
            var main_drug;
            for (var drug in data) {
              // debugPrint("Snapshot 3: $drug");
              if (drug['Name'] == drugname) {
                main_drug = drug;
              }
            }
            debugPrint("Snapshot 4: $main_drug");

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [],
              ),
            );
          } else if (snapshot.hasError) {
            // an error occurred while loading the data
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            // data is still loading
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
