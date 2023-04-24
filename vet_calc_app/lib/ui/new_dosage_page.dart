import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import '../main.dart';

class NewDosagePage extends StatelessWidget {
  const NewDosagePage({super.key});

  Future<Object?> databaseQuery(animal) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Species/$animal/Drugs");

    DatabaseEvent event = await ref.once();

    //shows the data here
    return event.snapshot.value;
  }

  //TODO: update concentration function to account for multiple dosages

  //calculates dosage
  //takes in weight, high dosage, low dosage, units, and if weight is in lb or kg
  //returns list with [dosage string, unit string, calculated low dosage, calculated high dosage]
  List getDosage(double weight, var dosageList, bool isLbs) {
    // convert to kg if lbs
    if (isLbs) {
      weight = weight * 0.453592;
    }

    String dosageString = "";
    var dosageArray = [];

    // loop through every dosage in the list
    for (var object in dosageList) {
      //check to see if dosage has a name for seperated dosages/concentrations
      var name;
      object['name'] == null ? name = null : name = object['name'];

      double highDosage = object['high'].toDouble();
      double lowDosage = object['low'].toDouble();

      //extract the kg fro mthe units so it only has useful units
      int kgIdx = object['units'].indexOf("kg");
      String beforeKgString = object['units'].substring(0, kgIdx - 1);
      String afterKgString = object['units'].substring(kgIdx + 2);

      String unitSubstring = beforeKgString + afterKgString;

      //calculate the dosage
      if (highDosage == lowDosage) {
        double dosage = weight * highDosage;

        //rounding to 3 to fix double to string conversions
        name == null
            ? dosageString =
                "$dosageString ${dosage.toStringAsFixed(3)} $unitSubstring\n"
            : dosageString =
                "$dosageString $name: ${dosage.toStringAsFixed(3)} $unitSubstring\n";
        dosageArray.add({
          'low': dosage,
          'high': dosage,
          'units': unitSubstring,
          'name': name
        });
      } else {
        double low = (weight * lowDosage);
        double high = weight * highDosage;

        //rounding to 3 to fix double to string conversions
        name == null
            ? dosageString =
                "$dosageString ${low.toStringAsFixed(3)} - ${high.toStringAsFixed(3)} $unitSubstring\n"
            : dosageString =
                "$dosageString $name: ${low.toStringAsFixed(3)} - ${high.toStringAsFixed(3)} $unitSubstring\n";
        dosageArray.add(
            {'low': low, 'high': high, 'units': unitSubstring, 'name': name});
      }
    }
    return [dosageString, dosageArray];
  }

  // String getConcentration(
  //     var concentration, var dosageArray, bool seperatedDosages) {
  //   String concentrationString = "";
  //   bool sameDosage = true;
  //   if (lowDosage != highDosage) {
  //     sameDosage = false;
  //   }
  //   for (var object in concentration) {
  //     String concentrationUnits =
  //         object["units"].substring(0, object["units"].indexOf("/"));
  //     String concentrationAfterUnits = object["units"]
  //         .substring(object["units"].indexOf("/") + 1, object["units"].length);

  //     String newDosageUnits = "";

  //     //see if dosage units are mg, µg or mEq
  //     if (dosageUnits.contains("mg")) {
  //       newDosageUnits = "mg";
  //     } else if (dosageUnits.contains("µg")) {
  //       newDosageUnits = "µg";
  //     } else if (dosageUnits.contains("mEq")) {
  //       newDosageUnits = "mEq";
  //     }

  //     double lowConcentration = object["low"].toDouble();
  //     double highConcentration = object["high"].toDouble();
  //     double lowConcentrationConverted = object["low"].toDouble() * 1000.0;
  //     double highConcentrationConverted = object["high"].toDouble() * 1000.0;

  //     //if the concentration is the same
  //     if (lowConcentration == highConcentration) {
  //       //if concentration units are mg while dosage units are µg
  //       if (concentrationUnits == "mg" && newDosageUnits == "µg") {
  //         if (sameDosage) {
  //           concentrationString =
  //               "$concentrationString ${(lowDosage / lowConcentrationConverted).toStringAsFixed(5)} $concentrationAfterUnits\n";
  //         } else {
  //           concentrationString =
  //               "$concentrationString ${(lowDosage / lowConcentrationConverted).toStringAsFixed(5)} - ${(highDosage / lowConcentrationConverted).toStringAsFixed(5)} $concentrationAfterUnits\n";
  //         }
  //       } else {
  //         if (sameDosage) {
  //           concentrationString =
  //               "$concentrationString ${(lowDosage / lowConcentration).toStringAsFixed(5)} $concentrationAfterUnits\n";
  //         } else {
  //           concentrationString =
  //               "$concentrationString ${(lowDosage / lowConcentration).toStringAsFixed(5)} - ${(highDosage / lowConcentration).toStringAsFixed(5)} $concentrationAfterUnits\n";
  //         }
  //       }
  //     } else {
  //       if (concentrationUnits == "mg" && newDosageUnits == "µg") {
  //         if (sameDosage) {
  //           concentrationString =
  //               "$concentrationString ${(lowDosage / lowConcentrationConverted).toStringAsFixed(5)} - ${(lowDosage / highConcentrationConverted).toStringAsFixed(5)} $concentrationAfterUnits\n";
  //         } else {
  //           concentrationString =
  //               "$concentrationString ${(lowDosage / lowConcentrationConverted).toStringAsFixed(5)} - ${(lowDosage / highConcentrationConverted).toStringAsFixed(5)} to ${(highDosage / lowConcentrationConverted).toStringAsFixed(5)} - ${(highDosage / highConcentrationConverted).toStringAsFixed(5)} $concentrationAfterUnits\n";
  //         }
  //       } else {
  //         if (sameDosage) {
  //           concentrationString =
  //               "$concentrationString ${(lowDosage / lowConcentration).toStringAsFixed(5)} - ${(lowDosage / highConcentration).toStringAsFixed(5)} $concentrationAfterUnits\n";
  //         } else {
  //           concentrationString =
  //               "$concentrationString ${(lowDosage / lowConcentration).toStringAsFixed(5)} - ${(lowDosage / highConcentration).toStringAsFixed(5)} to ${(highDosage / lowConcentration).toStringAsFixed(5)} - ${(highConcentration).toStringAsFixed(5)} $concentrationAfterUnits\n";
  //         }
  //       }
  //     }
  //   }
  //   return concentrationString;
  // }

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
        title: Text('$animal Dosage Calculation'),
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

            // dosage
            // see if its a string to just output that or go to function

            // getDosage returns dosage string in [0] and dosage array in [1]
            // for concentration
            String dosageDisplay = "";
            List dosageList = [];
            if (mainDrug['Dosage'] is String) {
              dosageDisplay = mainDrug['Dosage'];
            } else {
              dosageList =
                  getDosage(weight.toDouble(), mainDrug['Dosage'], isLbs);

              dosageDisplay = dosageList[0];
            }

            // concentration
            String concentrationDisplay = "";
            if (mainDrug['Concentration'] == null) {
              concentrationDisplay = "N/A";
            } else if (mainDrug['Concentration'] is String) {
              concentrationDisplay = mainDrug['Concentration'];
            }
            // else {
            //   concentrationDisplay = getConcentration(mainDrug['Concentration'],
            //       dosageList[1], mainDrug['SameDosages'] != null ? true : false);
            // }

            // notes
            String notesDisplay;

            if (mainDrug['Notes'] == null) {
              notesDisplay = "N/A";
            } else {
              notesDisplay = mainDrug['Notes'];
            }

            // weight
            Wrap weightText;
            if (isLbs) {
              // weightText = Text(
              //     "Weight: $weight $weightunit (${(weight * 0.453592).toStringAsFixed(2)} kg)",
              //     style: const TextStyle(fontSize: 20));
              weightText = Wrap(alignment: WrapAlignment.center, children: [
                const Text("Weight: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20)),
                Text(
                    "$weight $weightunit (${(weight * 0.453592).toStringAsFixed(2)} kg)",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold))
              ]);
            } else {
              // weightText = Text("Weight: $weight $weightunit",
              //     style: const TextStyle(fontSize: 20));
              weightText = Wrap(alignment: WrapAlignment.center, children: [
                const Text("Weight: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20)),
                Text("$weight $weightunit",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold))
              ]);
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
                        // Text("Animal: $animal",
                        //     style: const TextStyle(fontSize: 20)),
                        Wrap(alignment: WrapAlignment.center, children: [
                          const Text("Animal: ",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20)),
                          Text(animal,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))
                        ]),
                        // Text("Drug: $drugname",
                        //     style: const TextStyle(fontSize: 20)),
                        Wrap(alignment: WrapAlignment.center, children: [
                          const Text("Drug: ",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20)),
                          Text(drugname,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))
                        ]),
                        weightText,
                        const SizedBox(height: 50),
                        // Text("Recommended Dosage: $dosageDisplay",
                        //     textAlign: TextAlign.center,
                        //     style: const TextStyle(fontSize: 20)),
                        Wrap(alignment: WrapAlignment.center, children: [
                          const Text("Recommended Dosage: ",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20)),
                          Text(dosageDisplay,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))
                        ]),
                        const SizedBox(height: 20),
                        // Text("Concentration: $concentrationDisplay",
                        //     textAlign: TextAlign.center,
                        //     style: const TextStyle(fontSize: 20)),
                        Wrap(alignment: WrapAlignment.center, children: [
                          const Text("Concentration: ",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20)),
                          Text(concentrationDisplay,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))
                        ]),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.all(
                              16.0), // add desired padding value here
                          child:
                              Wrap(alignment: WrapAlignment.center, children: [
                            const Text("Notes: ",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20)),
                            Text(notesDisplay,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold))
                          ]),
                          //Text("Notes: $notesDisplay",
                          //     textAlign: TextAlign.center,
                          //     style: const TextStyle(fontSize: 20)),
                        ),
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
