import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'dosage_page.dart';

class WeightForm extends StatefulWidget {
  const WeightForm({super.key});

  @override
  WeightFormState createState() {
    return WeightFormState();
  }
}

// Weight Page
// TODO: show error when input is empty
class WeightFormState extends State<WeightForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    var animal = appState.curAnimal;
    var drug = appState.curDrug;

    final textController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: Text('Weight of $animal  ($drug)'),
        ),
        body: Form(
          key: _formKey,
          child: Center(
              //add some padding
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: TextFormField(
                    controller: textController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
                    ],
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter Weight for $animal in kg',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a weight';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          appState.chooseWeight(textController.text);
                          debugPrint(
                              "Weight ${textController.text} in WeightPage");
                          debugPrint("Animal $animal in WeightPage");
                          debugPrint("Drug $drug in WeightPage");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('yay')),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DosagePage()),
                          );
                        }
                      },
                      child: const Text("Calculate")),
                )
              ])),
        ));
  }
}
