import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'animals.dart';
import 'main.dart';
import 'drug_page.dart';

// Main page
class AnimalPage extends StatelessWidget {
  const AnimalPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    // debugPrint(appState.curAnimal);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(appName,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 25),
          Row(mainAxisSize: MainAxisSize.min, children: [
            // EQUINE BUTTON
            SizedBox(
              width: 150,
              height: 150,
              child: ElevatedButton(
                onPressed: () {
                  appState.chooseAnimal(Animal.equine);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DrugPage()),
                  );
                },
                child: Text(animalToString(Animal.equine)),
              ),
            ),

            const SizedBox(width: 25),

            // SHEEP GOAT BUTTON
            SizedBox(
              width: 150,
              height: 150,
              child: ElevatedButton(
                onPressed: () {
                  appState.chooseAnimal(Animal.sheepGoat);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DrugPage()),
                  );
                },
                child: Text(animalToString(Animal.sheepGoat)),
              ),
            )
          ]),
          const SizedBox(height: 25),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // CAMELID BUTTON
              SizedBox(
                width: 150,
                height: 150,
                child: ElevatedButton(
                  onPressed: () {
                    appState.chooseAnimal(Animal.camelid);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DrugPage()),
                    );
                  },
                  child: Text(animalToString(Animal.camelid)),
                ),
              ),

              const SizedBox(width: 25),

              // SWINE BUTTON
              SizedBox(
                width: 150,
                height: 150,
                child: ElevatedButton(
                  onPressed: () {
                    appState.chooseAnimal(Animal.swine);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DrugPage()),
                    );
                  },
                  child: Text(animalToString(Animal.swine)),
                ),
              )
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // CATTLE BUTTON
              SizedBox(
                width: 150,
                height: 150,
                child: ElevatedButton(
                  onPressed: () {
                    appState.chooseAnimal(Animal.cattle);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DrugPage()),
                    );
                  },
                  child: Text(animalToString(Animal.cattle)),
                ),
              ),

              const SizedBox(width: 25),

              // DOG BUTTON
              SizedBox(
                width: 150,
                height: 150,
                child: ElevatedButton(
                  onPressed: () {
                    appState.chooseAnimal(Animal.dog);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DrugPage()),
                    );
                  },
                  child: Text(animalToString(Animal.dog)),
                ),
              )
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // CAT BUTTON
              SizedBox(
                width: 150,
                height: 150,
                child: ElevatedButton(
                  onPressed: () {
                    appState.chooseAnimal(Animal.cat);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DrugPage()),
                    );
                  },
                  child: Text(animalToString(Animal.cat)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
