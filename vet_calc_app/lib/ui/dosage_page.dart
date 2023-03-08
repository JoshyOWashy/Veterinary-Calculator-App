import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import '../main.dart';

class DosagePage extends StatelessWidget {
  const DosagePage({super.key});

  Future<Object?> databaseQuery(animal) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Species/$animal/Drugs");

    DatabaseEvent event = await ref.once();

    //shows the data here
    return event.snapshot.value;
  }

  //calculates dosage
  //takes in weight, high dosage, low dosage, units, and if weight is in lb or kg
  //returns list with [dosage string, unit string, calculated low dosage, calculated high dosage]
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

    String unitSubstring = beginningSubstring + endSubstring;

    // debugPrint("unitSubstring: $unitSubstring");

    //contains substring of just units and stuff after kg
    if (highDosage == lowDosage) {
      double dosage = weight * highDosage;

      //rounding to 5 for now
      return [
        "${dosage.toStringAsFixed(3)} $unitSubstring",
        unitSubstring,
        dosage,
        dosage
      ];
    } else {
      double low = (weight * lowDosage);
      double high = weight * highDosage;

      return [
        "${low.toStringAsFixed(3)} - ${high.toStringAsFixed(3)} $unitSubstring",
        unitSubstring,
        low,
        high
      ];
    }
  }

  String getConcentration(
      var concentration, var lowDosage, var highDosage, String dosageUnits) {
    debugPrint("concentration: $concentration");
    debugPrint("lowDosage: $lowDosage");
    debugPrint("highDosage: $highDosage");
    debugPrint("dosageUnits: $dosageUnits");
    if (concentration == null) {
      return "";
    } else if (concentration == "Varies") {
      return "Varies";
    } else if (concentration == "See notes") {
      return "See Notes";
    } else {
      String concentrationString = "";
      bool sameDosage = true;
      if (lowDosage != highDosage) {
        sameDosage = false;
      }
      for (var object in concentration) {
        String concentrationUnits =
            object["units"].substring(0, object["units"].indexOf("/"));
        String concentrationAfterUnits = object["units"].substring(
            object["units"].indexOf("/") + 1, object["units"].length);

        String newDosageUnits = "";

        //see if dosage units are mg, µg or mEq
        if (dosageUnits.contains("mg")) {
          newDosageUnits = "mg";
        } else if (dosageUnits.contains("µg")) {
          newDosageUnits = "mg";
        } else if (dosageUnits.contains("mEq")) {
          newDosageUnits = "mEq";
        }

        debugPrint("concentrationUnits: $concentrationUnits");
        debugPrint("concentrationAfterUnits: $concentrationAfterUnits");
        debugPrint("newDosageUnits: $newDosageUnits");

        //if the concentration is the same
        if (object["low"] == object["high"]) {
          //if concentration units are mg while dosage units are µg
          if (concentrationUnits == "mg" && newDosageUnits == "µg") {
            if (sameDosage) {
              var newConcentration = object["low"] / 1000.0;
              concentrationString =
                  "$concentrationString ${(newConcentration * lowDosage).toStringAsFixed(5)} $concentrationAfterUnits";
            } else {
              var newConcentration = object["low"] / 1000.0;
              concentrationString =
                  "$concentrationString ${(newConcentration * lowDosage).toStringAsFixed(5)} - ${(newConcentration * highDosage).toStringAsFixed(5)} $concentrationAfterUnits";
            }
          }
        } else {
          if (sameDosage) {
            var newLowConcentration = object["low"];
            var newHighConcentration = object["high"];
            concentrationString = "here";
            concentrationString =
                "$concentrationString ${(newLowConcentration * lowDosage).toStringAsFixed(5)} - ${(newHighConcentration * lowDosage).toStringAsFixed(5)} $concentrationAfterUnits";
          } else {
            var newLowConcentration = object["low"];
            var newHighConcentration = object["high"];
            concentrationString =
                "$concentrationString ${(newLowConcentration * lowDosage).toStringAsFixed(5)} - ${(newHighConcentration * lowDosage).toStringAsFixed(5)} to ${(newLowConcentration * highDosage).toStringAsFixed(5)} - ${(newHighConcentration * lowDosage).toStringAsFixed(5)} $concentrationAfterUnits";
          }
        }
        // concentrationString = object["units"];
        // concentrationString = concentrationUnits;
        // concentrationString = newDosageUnits;
      }
      debugPrint("concentrationString: $concentrationString");
      return concentrationString;
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var animal = appState.curAnimal;
    var drugname = appState.curDrug;
    var weight = appState.curWeight;
    var weightunit = appState.curWeightUnits;

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
            // debugPrint("dosageDisplay: $dosageDisplay");
            // debugPrint("concentration: ${mainDrug['Concentration']}");

            // concentration
            var concentration = getConcentration(mainDrug['Concentration'],
                dosageList[2], dosageList[3], dosageList[1]);

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
              child: Scrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Animal: $animal",
                            style: const TextStyle(fontSize: 20)),
                        Text("Drug: $drugname",
                            style: const TextStyle(fontSize: 20)),
                        weightText,
                        const SizedBox(height: 50),
                        Text("Recommended Dosage: $dosageDisplay",
                            style: const TextStyle(fontSize: 20)),
                        Text("Concentration: $concentrationDisplay ",
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(height: 50),
                        Text("Notes: $notesDisplay ",
                            style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                  )),
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
      bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              width: 75,
              height: 75,
              child: IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                  );
                },
                iconSize: 45,
              ),
            ),
          ])),
    );
  }
}
