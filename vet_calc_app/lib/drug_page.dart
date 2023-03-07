import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'main.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text('$animal Drug Calculation'),
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

            if (appState.curDrug.isEmpty && dropdownItems.isNotEmpty) {
              appState.chooseDrug(dropdownItems.first.value.toString());
            }

            return Center(
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
                    const SizedBox(height: 10),
                    // Drug dropdown list
                    DropdownButton(
                      value: appState.curDrug,
                      onChanged: (String? newValue) {
                        if (newValue == null || newValue == appState.curDrug) {
                          return;
                        }

                        setState(() {
                          appState.chooseDrug(newValue);
                        });
                      },
                      items: dropdownItems,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 25.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: [
                                // Weight text field
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: TextFormField(
                                      controller: textController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'(^\d*\.?\d*)'),
                                        ),
                                      ],
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Enter Weight for $animal',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a weight';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                // Weight units dropdown list
                                DropdownButton<String>(
                                  value: appState.curWeightUnits,
                                  onChanged: (String? newValue) {
                                    if (newValue == null ||
                                        newValue == appState.curWeightUnits) {
                                      return;
                                    }

                                    setState(() {
                                      appState.changeWeightUnits(newValue);
                                    });
                                  },
                                  items: <String>['kg', 'lbs']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 100),
                            // Calculate button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(300, 100),
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState == null) return;

                                if (_formKey.currentState!.validate()) {
                                  appState.chooseWeight(textController.text);
                                  appState.changeWeightUnits(
                                      appState.curWeightUnits);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('woooo!')),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DosagePage()),
                                  );
                                }
                              },
                              child: const Text(
                                'Calculate',
                                style: TextStyle(
                                  fontSize: 18,
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
