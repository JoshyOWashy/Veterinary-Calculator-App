import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'main.dart';

class DosagePage extends StatelessWidget {
  const DosagePage({super.key});

  Future<Object?> databaseQuery(animal) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Species/$animal/Drugs");

    DatabaseEvent event = await ref.once();
    //debugPrint("Snapshot type: ${event.type}");
    //debugPrint("Snapshot: ${event.snapshot.value}");

    //shows the data here

    return event.snapshot.value;
  }

  List getDosage(
      double weight, double highDosage, double lowDosage, String units) {
    //if theres only one dosage
    int kgIdx = units.indexOf("kg");
    String beginningSubstring = units.substring(0, kgIdx - 1);
    String endSubstring = units.substring(kgIdx + 2);

    String finalSubstring = beginningSubstring + endSubstring;

    debugPrint("finalSubstring: $finalSubstring");
    //contains substring of just units and stuff after kg

    if (highDosage == lowDosage) {
      double dosage = weight * highDosage;

      //rounding to 5 for now
      return ["${dosage.toStringAsFixed(5)} $finalSubstring", finalSubstring];
    } else {
      double low = (weight * lowDosage);
      double high = weight * highDosage;

      return ["$low - $high $finalSubstring", finalSubstring];
    }
    // debugPrint(testString);
    // debugPrint(weight)
  }

  String getConcentration(String dosage, var concentration) {
    if (concentration == null) {
      return "";
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var animal = appState.curAnimal;
    var drugname = appState.curDrug;
    var weight = appState.curWeight;

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

            //debugPrint("Snapshot 2: $data");
            var mainDrug;
            for (var drug in data) {
              // debugPrint("Snapshot 3: $drug");
              if (drug['Name'] == drugname) {
                mainDrug = drug;
              }
            }

            //soage funciton that returns dosage in [0] and units in [1]
            var dosageList = getDosage(
                weight.toDouble(),
                mainDrug['Dosage_high'].toDouble(),
                mainDrug['Dosage_low'].toDouble(),
                mainDrug['Units']);

            //dosage
            var dosageDisplay = dosageList[0];
            debugPrint("dosageDisplay: $dosageDisplay");
            debugPrint("concentration: ${mainDrug['Concentration']}");

            //concentration
            var concentration =
                getConcentration(dosageList[1], mainDrug['Concentration']);

            String concentrationDisplay;

            if (concentration == "") {
              concentrationDisplay = "N/A";
            } else {
              concentrationDisplay = concentration;
            }

            //notes
            String notesDisplay;

            if (mainDrug['Notes'] == "") {
              notesDisplay = "N/A";
            } else {
              notesDisplay = mainDrug['Notes'];
            }

            //have a bunch of text here
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Animal: $animal"),
                  Text("Drug: $drugname"),
                  Text("Weight: $weight kg"),
                  Text("Dosage: $dosageDisplay"),
                  Text("Concentration: $concentrationDisplay "),
                  Text("Notes: $notesDisplay "),
                ],
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
