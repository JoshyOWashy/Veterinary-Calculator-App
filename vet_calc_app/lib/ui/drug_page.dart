import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import '../main.dart';
import 'package:flutter/services.dart';
import 'dosage_page.dart';

class DrugPage extends StatefulWidget {
  const DrugPage({Key? key}) : super(key: key);

  @override
  DrugListPageState createState() => DrugListPageState();
}

class DrugListPageState extends State<DrugPage> {
  final _formKey = GlobalKey<FormState>();

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

    final textController = TextEditingController();
    final ScrollController scrollController = ScrollController();

    return WillPopScope(
        onWillPop: () async {
          // Reset the curDrug value when the user goes back to the animal page
          appState.curDrug = '';
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('$animal Drug Selection'),
          ),
          body: FutureBuilder(
            future: databaseQuery(animal),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // data has been loaded, build the widget tree
                var data = snapshot.data as List<dynamic>;
                data.sort((a, b) {
                  return a['Name']
                      .toLowerCase()
                      .compareTo(b['Name'].toLowerCase());
                });

                // load dropdown box from database
                // populate dropdown with drug names
                List<DropdownMenuItem<String>> dropdownItems = [];
                for (var drug in data) {
                  dropdownItems.add(
                    DropdownMenuItem(
                      value: drug['Name'],
                      child: Text(drug['Name'], overflow: TextOverflow.clip),
                    ),
                  );
                }

                //set dropdown value of drug dropdown to the first drug in the list
                var drugDropDownValue = dropdownItems.first.value.toString();

                return Center(
                    child: Scrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text for drug selection
                        const Text(
                          'Select a drug:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Drug dropdown list
                        SizedBox(
                          width: 300,
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                            ),
                            value: drugDropDownValue,
                            onChanged: (String? newValue) {
                              if (newValue == null ||
                                  newValue == appState.curDrug) {
                                return;
                              }

                              // update current drug when a new drug is selected
                              setState(() {
                                appState.chooseDrug(newValue);
                              });
                            },
                            isExpanded: true,
                            items: dropdownItems,
                          ),
                        ),

                        // weight input text input field
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35.0, vertical: 25.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Weight text field
                                    SizedBox(
                                      width: 220,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: SizedBox(
                                          height: 100,
                                          child: TextFormField(
                                            controller: textController,
                                            keyboardType: const TextInputType
                                                    .numberWithOptions(
                                                decimal: true),
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'(^\d*\.?\d*)'),
                                              ),
                                            ],
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'Enter Weight',
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a weight';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Weight units dropdown list
                                    SizedBox(
                                      width: 90,
                                      // bottom padding to align with text field
                                      child: DropdownButtonFormField(
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                          ),
                                        ),
                                        value: appState.curWeightUnits,
                                        onChanged: (String? newValue) {
                                          if (newValue == null ||
                                              newValue ==
                                                  appState.curWeightUnits) {
                                            return;
                                          }

                                          // update weight units when weight is
                                          // entered
                                          setState(() {
                                            appState
                                                .changeWeightUnits(newValue);
                                          });
                                        },
                                        isExpanded: true,
                                        items: <String>['kg', 'lbs']
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),

                                // Calculate button
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(300, 100),
                                    side: const BorderSide(
                                      color: Colors.grey,
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState == null) return;

                                    if (_formKey.currentState!.validate()) {
                                      if (appState.curDrug == '') {
                                        appState.chooseDrug(drugDropDownValue);
                                      }
                                      appState
                                          .chooseWeight(textController.text);
                                      appState.changeWeightUnits(
                                          appState.curWeightUnits);

                                      FocusScope.of(context).unfocus();

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            maintainState: false,
                                            builder: (context) =>
                                                const DosagePage()),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'Calculate',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
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

          //home button
          bottomNavigationBar: BottomAppBar(
              color: Theme.of(context).colorScheme.primaryContainer,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  width: 75,
                  height: 75,
                  child: IconButton(
                    icon: const Icon(Icons.home),
                    onPressed: () {
                      //pop once when home button is pressed to get back to
                      //animal screen
                      Navigator.pop(context);
                    },
                    iconSize: 45,
                  ),
                ),
              ])),
        ));
  }
}
