import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'main.dart';
import 'weight_page.dart';

class DrugPage extends StatefulWidget {
  const DrugPage({super.key});

  @override
  DrugListPageState createState() => DrugListPageState();
}

class DrugListPageState extends State<DrugPage> {
  Future<Object?> databaseQuery(animal) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Species/$animal/Drugs");

    DatabaseEvent event = await ref.once();

    //shows the data here
    return event.snapshot.value;
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var animal = appState.curAnimal;
    final ScrollController scrollController = ScrollController();

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

            List<DropdownMenuItem<String>> dropdownItems = [];
            for (var drug in data) {
              dropdownItems.add(
                DropdownMenuItem(
                  value: drug['Name'],
                  child: Text(drug['Name']),
                ),
              );
            }

            appState.chooseDrug(dropdownItems.first.value.toString());

            return Center(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton(
                      value: appState.curDrug,
                      onChanged: (String? newValue) {
                        if (newValue == null) return;

                        appState.chooseDrug(newValue);

                        // TODO: currDrug doesn't update
                        debugPrint(appState.curDrug);
                      },
                      items: dropdownItems,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WeightForm()),
                        );
                      },
                      child: const Text('Go to Weight Page'),
                    ),
                  ],
                ),
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
