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

    //shows the data here
    return event.snapshot.value;
  }

  List getDosage(double weight, double highDosage, double lowDosage,
      String units, bool isLbs) {
    // convert to kg if lbs
    if (isLbs) {
      weight = weight * 0.453592;
    }

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
    var weightunit = appState.curWeightUnits;

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

            var mainDrug;
            for (var drug in data) {
              if (drug['Name'] == drugname) {
                mainDrug = drug;
              }
            }

            var isLbs = false;
            if (weightunit == "lbs") {
              isLbs = true;
            }

            // returns dosage in [0] and units in [1]
            var dosageList = getDosage(
                weight.toDouble(),
                mainDrug['Dosage_high'].toDouble(),
                mainDrug['Dosage_low'].toDouble(),
                mainDrug['Units'],
                isLbs);

            // dosage
            var dosageDisplay = dosageList[0];
            debugPrint("dosageDisplay: $dosageDisplay");
            debugPrint("concentration: ${mainDrug['Concentration']}");

            // concentration
            var concentration =
                getConcentration(dosageList[1], mainDrug['Concentration']);

            String concentrationDisplay;

            if (concentration == "") {
              concentrationDisplay = "N/A";
            } else {
              concentrationDisplay = concentration;
            }

            // notes
            String notesDisplay;

            if (mainDrug['Notes'] == "") {
              notesDisplay = "N/A";
            } else {
              notesDisplay = mainDrug['Notes'];
            }

            var weightText = Text("Weight: $weight $weightunit",
                style: const TextStyle(fontSize: 20));
            if (isLbs) {
              weightText = Text(
                  "Weight: $weight $weightunit (${weight * 0.453592} kg)",
                  style: const TextStyle(fontSize: 20));
            }

            // have a bunch of text here
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Animal: $animal", style: const TextStyle(fontSize: 20)),
                  Text("Drug: $drugname", style: const TextStyle(fontSize: 20)),
                  weightText,
                  const SizedBox(height: 50),
                  Text("Dosage: $dosageDisplay",
                      style: const TextStyle(fontSize: 20)),
                  Text("Concentration: $concentrationDisplay ",
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 50),
                  Text("Notes: $notesDisplay ",
                      style: const TextStyle(fontSize: 20)),
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
