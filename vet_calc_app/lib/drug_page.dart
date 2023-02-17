import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'main.dart';
import 'weight_page.dart';

// TODO: Drug Page
class DrugPage1 extends StatelessWidget {
  const DrugPage1({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    // debugPrint(appState.curAnimal);

    var animal = appState.curAnimal;

    return Scaffold(
      appBar: AppBar(
        title: Text('Drugs for $animal'),
      ),
      body: Center(
        //have this be buttons of drugs

        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
    // return ListView(
    //   children: const [
    //     Padding(
    //       padding: EdgeInsets.all(20),
    //       child: Text('Drugs'),
    //     )
    //   ],
    // );
  }
}

//Temp Drug Page
//TODO: query database to get drugs for specific animal
class DrugPage extends StatelessWidget {
  const DrugPage({super.key});

  // List<ElevatedButton> getCattleDrugs() {
  //   List<ElevatedButton> drugList = [];
  //   for (var drug in cattleDrugList) {
  //     var newItem = ElevatedButton(onPressed: () {}, child: Text(drug));
  //     drugList.add(newItem);
  //   }

  //   return drugList;
  // }

  Future<Object?> databaseQuery(animal) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Species/$animal/Drugs");

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Drugs for $animal'),
      ),
      body: FutureBuilder(
        future: databaseQuery(animal),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // data has been loaded, build the widget tree
            var data = snapshot.data as List<dynamic>;
            data.sort((a, b) {
              return a['Name'].toLowerCase().compareTo(b['Name'].toLowerCase());
            });

            //debugPrint("Snapshot 2: $data");
            List<ElevatedButton> drugList = [];
            for (var drug in data) {
              var newItem = ElevatedButton(
                  onPressed: () {
                    appState.chooseDrug(drug['Name']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WeightForm()),
                    );
                  },
                  child: Text(drug['Name']));
              drugList.add(newItem);
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: drugList,
              ),
            );
          } else if (snapshot.hasError) {
            // an error occurred while loading the data
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            // data is still loading
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
