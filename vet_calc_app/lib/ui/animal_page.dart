import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/animals.dart';
import '../main.dart';
import 'drug_page.dart';

// Main page
class AnimalPage extends StatelessWidget {
  const AnimalPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final List<Widget> animalButtons = [];

    for (final animal in Animal.values) {
      final animalName = animalToString(animal);
      final icon = animalIcon(animal);

      animalButtons.add(
        SizedBox(
          width: 150,
          height: 150,
          child: ElevatedButton.icon(
            onPressed: () {
              appState.chooseAnimal(animal);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DrugPage()),
              );
            },
            icon: icon,
            label: Text(animalName, style: const TextStyle(fontSize: 20)),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Text(
                  appName,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Select an animal:',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 30,
              runSpacing: 30,
              children: animalButtons,
            ),
          ],
        ),
      ),
    );
  }
}
