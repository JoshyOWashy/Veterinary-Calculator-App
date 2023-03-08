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
    // TODO: make buttons dynamically generated
    // TODO: add icons to buttons
    var appState = context.watch<MyAppState>();

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
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onPressed: () {
                  appState.chooseAnimal(Animal.equine);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DrugPage()),
                  );
                },
                child: Text(animalToString(Animal.equine),
                    style: const TextStyle(fontSize: 20)),
              ),
            ),

            const SizedBox(width: 25),

            // SHEEP GOAT BUTTON
            SizedBox(
              width: 150,
              height: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onPressed: () {
                  appState.chooseAnimal(Animal.sheepGoat);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DrugPage()),
                  );
                },
                child: Text(animalToString(Animal.sheepGoat),
                    style: const TextStyle(fontSize: 20)),
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
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () {
                    appState.chooseAnimal(Animal.camelid);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DrugPage()),
                    );
                  },
                  child: Text(animalToString(Animal.camelid),
                      style: const TextStyle(fontSize: 20)),
                ),
              ),

              const SizedBox(width: 25),

              // SWINE BUTTON
              SizedBox(
                width: 150,
                height: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () {
                    appState.chooseAnimal(Animal.swine);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DrugPage()),
                    );
                  },
                  child: Text(animalToString(Animal.swine),
                      style: const TextStyle(fontSize: 20)),
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
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () {
                    appState.chooseAnimal(Animal.cattle);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DrugPage()),
                    );
                  },
                  child: Text(animalToString(Animal.cattle),
                      style: const TextStyle(fontSize: 20)),
                ),
              ),

              const SizedBox(width: 25),

              // DOG BUTTON
              SizedBox(
                width: 150,
                height: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () {
                    appState.chooseAnimal(Animal.dog);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DrugPage()),
                    );
                  },
                  child: Text(animalToString(Animal.dog),
                      style: const TextStyle(fontSize: 20)),
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
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () {
                    appState.chooseAnimal(Animal.cat);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DrugPage()),
                    );
                  },
                  child: Text(animalToString(Animal.cat),
                      style: const TextStyle(fontSize: 20)),
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
