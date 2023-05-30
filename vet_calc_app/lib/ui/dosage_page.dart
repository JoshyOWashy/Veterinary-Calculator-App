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
  List getDosage(double weight, var dosageList, bool isLbs) {
    //counter to add or's in the string
    var orCounter = 1;

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

      //add "or" if the dosages are not seperated from concentrations
      if (orCounter != dosageList.length && name == null) {
        dosageString = "$dosageString or\n";
      }
      orCounter++;
    }
    return [dosageString, dosageArray];
  }

  String getConcentration(var concentration, var dosageArray) {
    String concentrationString = "";
    //counter to add or's in the string
    var orCounter = 1;

    //iterate over concentrations
    for (var object in concentration) {
      //get units out of concenration
      String concentrationUnits =
          object["units"].substring(0, object["units"].indexOf("/"));
      String concentrationAfterUnits = object["units"]
          .substring(object["units"].indexOf("/") + 1, object["units"].length);

      //iterate over dosages
      for (var dosage in dosageArray) {
        var lowDosage = dosage['low'];
        var highDosage = dosage['high'];
        bool sameDosage = true;

        if (lowDosage != highDosage) {
          sameDosage = false;
        }

        //get units out of dosage
        String newDosageUnits = "";
        //see if dosage units are mg, µg or mEq
        if (dosage['units'].contains("mg")) {
          newDosageUnits = "mg";
        } else if (dosage['units'].contains("µg")) {
          newDosageUnits = "µg";
        } else if (dosage['units'].contains("mEq")) {
          newDosageUnits = "mEq";
        }

        double lowConcentration = object["low"].toDouble();
        double highConcentration = object["high"].toDouble();
        double lowConcentrationConverted = object["low"].toDouble() * 1000.0;
        double highConcentrationConverted = object["high"].toDouble() * 1000.0;

        //if the concentration is the same
        if (lowConcentration == highConcentration) {
          //if concentration units are mg while dosage units are µg
          if (concentrationUnits == "mg" && newDosageUnits == "µg") {
            if (sameDosage) {
              concentrationString =
                  "$concentrationString ${(lowDosage / lowConcentrationConverted).toStringAsFixed(5)} $concentrationAfterUnits\n";
            } else {
              concentrationString =
                  "$concentrationString ${(lowDosage / lowConcentrationConverted).toStringAsFixed(5)} - ${(highDosage / lowConcentrationConverted).toStringAsFixed(5)} $concentrationAfterUnits\n";
            }
          } else {
            if (sameDosage) {
              concentrationString =
                  "$concentrationString ${(lowDosage / lowConcentration).toStringAsFixed(5)} $concentrationAfterUnits\n";
            } else {
              concentrationString =
                  "$concentrationString ${(lowDosage / lowConcentration).toStringAsFixed(5)} - ${(highDosage / lowConcentration).toStringAsFixed(5)} $concentrationAfterUnits\n";
            }
          }
        } else {
          if (concentrationUnits == "mg" && newDosageUnits == "µg") {
            if (sameDosage) {
              concentrationString =
                  "$concentrationString ${(lowDosage / lowConcentrationConverted).toStringAsFixed(5)} - ${(lowDosage / highConcentrationConverted).toStringAsFixed(5)} $concentrationAfterUnits\n";
            } else {
              concentrationString =
                  "$concentrationString ${(lowDosage / lowConcentrationConverted).toStringAsFixed(5)} - ${(lowDosage / highConcentrationConverted).toStringAsFixed(5)} to ${(highDosage / lowConcentrationConverted).toStringAsFixed(5)} - ${(highDosage / highConcentrationConverted).toStringAsFixed(5)} $concentrationAfterUnits\n";
            }
          } else {
            if (sameDosage) {
              concentrationString =
                  "$concentrationString ${(lowDosage / lowConcentration).toStringAsFixed(5)} - ${(lowDosage / highConcentration).toStringAsFixed(5)} $concentrationAfterUnits\n";
            } else {
              concentrationString =
                  "$concentrationString ${(lowDosage / lowConcentration).toStringAsFixed(5)} - ${(lowDosage / highConcentration).toStringAsFixed(5)} to ${(highDosage / lowConcentration).toStringAsFixed(5)} - ${(highConcentration).toStringAsFixed(5)} $concentrationAfterUnits\n";
            }
          }
        }
      }
      if (orCounter != concentration.length) {
        concentrationString = "$concentrationString or\n";
      }
      orCounter++;
    }
    return concentrationString;
  }

  String getConcentrationSeperated(var concentration, var dosageArray) {
    String concentrationString = "";

    for (var i = 0; i < concentration.length; i++) {
      String name = "";
      concentration[i]['name'] != null
          ? name = "${concentration[i]['name']}:"
          : name = "";

      var lowDosage = dosageArray[i]['low'];
      var highDosage = dosageArray[i]['high'];
      bool sameDosage = true;

      if (lowDosage != highDosage) {
        sameDosage = false;
      }

      //get units out of concenration
      String concentrationUnits = concentration[i]["units"]
          .substring(0, concentration[i]["units"].indexOf("/"));
      String concentrationAfterUnits = concentration[i]["units"].substring(
          concentration[i]["units"].indexOf("/") + 1,
          concentration[i]["units"].length);

      //get units out of dosage
      String newDosageUnits = "";
      //see if dosage units are mg, µg or mEq
      if (dosageArray[i]['units'].contains("mg")) {
        newDosageUnits = "mg";
      } else if (dosageArray[i]['units'].contains("µg")) {
        newDosageUnits = "µg";
      } else if (dosageArray[i]['units'].contains("mEq")) {
        newDosageUnits = "mEq";
      }

      double lowConcentration = concentration[i]["low"].toDouble();
      double highConcentration = concentration[i]["high"].toDouble();
      double lowConcentrationConverted =
          concentration[i]["low"].toDouble() * 1000.0;
      double highConcentrationConverted =
          concentration[i]["high"].toDouble() * 1000.0;

      //if the concentration is the same
      if (lowConcentration == highConcentration) {
        //if concentration units are mg while dosage units are µg
        if (concentrationUnits == "mg" && newDosageUnits == "µg") {
          if (sameDosage) {
            concentrationString =
                "$concentrationString $name ${(lowDosage / lowConcentrationConverted).toStringAsFixed(5)} $concentrationAfterUnits\n";
          } else {
            concentrationString =
                "$concentrationString $name ${(lowDosage / lowConcentrationConverted).toStringAsFixed(5)} - ${(highDosage / lowConcentrationConverted).toStringAsFixed(5)} $concentrationAfterUnits\n";
          }
        } else {
          if (sameDosage) {
            concentrationString =
                "$concentrationString $name ${(lowDosage / lowConcentration).toStringAsFixed(5)} $concentrationAfterUnits\n";
          } else {
            concentrationString =
                "$concentrationString $name ${(lowDosage / lowConcentration).toStringAsFixed(5)} - ${(highDosage / lowConcentration).toStringAsFixed(5)} $concentrationAfterUnits\n";
          }
        }
      } else {
        if (concentrationUnits == "mg" && newDosageUnits == "µg") {
          if (sameDosage) {
            concentrationString =
                "$concentrationString $name ${(lowDosage / lowConcentrationConverted).toStringAsFixed(5)} - ${(lowDosage / highConcentrationConverted).toStringAsFixed(5)} $concentrationAfterUnits\n";
          } else {
            concentrationString =
                "$concentrationString $name ${(lowDosage / lowConcentrationConverted).toStringAsFixed(5)} - ${(lowDosage / highConcentrationConverted).toStringAsFixed(5)} to ${(highDosage / lowConcentrationConverted).toStringAsFixed(5)} - ${(highDosage / highConcentrationConverted).toStringAsFixed(5)} $concentrationAfterUnits\n";
          }
        } else {
          if (sameDosage) {
            concentrationString =
                "$concentrationString $name ${(lowDosage / lowConcentration).toStringAsFixed(5)} - ${(lowDosage / highConcentration).toStringAsFixed(5)} $concentrationAfterUnits\n";
          } else {
            concentrationString =
                "$concentrationString $name ${(lowDosage / lowConcentration).toStringAsFixed(5)} - ${(lowDosage / highConcentration).toStringAsFixed(5)} to ${(highDosage / lowConcentration).toStringAsFixed(5)} - ${(highConcentration).toStringAsFixed(5)} $concentrationAfterUnits\n";
          }
        }
      }
    }
    return concentrationString;
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
            } else {
              mainDrug['Seperated'] == true
                  ? concentrationDisplay = getConcentrationSeperated(
                      mainDrug['Concentration'], dosageList[1])
                  : concentrationDisplay = getConcentration(
                      mainDrug['Concentration'], dosageList[1]);
            }

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
                        //animal
                        Wrap(alignment: WrapAlignment.center, children: [
                          const Text("Animal: ",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20)),
                          Text(animal,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))
                        ]),

                        //drug
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

                        //dosage
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

                        //concentration
                        Wrap(alignment: WrapAlignment.center, children: [
                          const Text("Volume: ",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20)),
                          Text(concentrationDisplay,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))
                        ]),

                        const SizedBox(height: 20),

                        //notes
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
                        ),

                        const SizedBox(height: 20),

                        //disclaimer
                        const Padding(
                          padding: EdgeInsets.all(
                              16.0), // add desired padding value here
                          child:
                              Wrap(alignment: WrapAlignment.center, children: [
                            Text("Disclaimer: ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text(
                                "This site is for veterinarians only. Ongoing changes in information and the possibility of human error require that the user exercise judgment when utilizing this information and, if necessary, consult and compare information from other sources. The reader is advised to check the drug's product insert before prescribing or administering a drug to a patient.",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15)),
                          ]),
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
                  appState.curDrug = '';
                  Navigator.pop(context);
                  Navigator.pop(context);
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const MyHomePage()),
                  // );
                },
                iconSize: 45,
              ),
            ),
          ])),
    );
  }
}
