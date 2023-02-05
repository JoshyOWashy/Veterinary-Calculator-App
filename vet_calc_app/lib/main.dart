import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'animals.dart';
import 'cattleDrugs.dart';

// Name idea: "Vet RX Calc"
const appName = "Vet RX Calculator";

void main() {
  runApp(const MyApp());
}

// Main app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: appName,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 106, 107, 175)),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

// Loading screen
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO:
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => MyAppState()),
    // );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // if I make this static, then notify listeners doesn't work
  // if it's not static, then I can't call it
  // not sure why, didn't really look into static enough to figure out
  static void chooseAnimal(Animal animal) {
    // TODO: go to drug screen
    // notifyListeners();
  }
}

// Home page
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const GeneratorPage();
        break;
      case 1:
        page = const SettingsPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text('Settings'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            )),
          ],
        ),
      );
    });
  }
}

// Main page
class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {
                  MyAppState.chooseAnimal(Animal.equine);
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
                  MyAppState.chooseAnimal(Animal.sheepGoat);
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
                    MyAppState.chooseAnimal(Animal.camelid);
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
                    MyAppState.chooseAnimal(Animal.swine);
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
                    MyAppState.chooseAnimal(Animal.cattle);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SecondRoute()),
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
                    MyAppState.chooseAnimal(Animal.dog);
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
                    MyAppState.chooseAnimal(Animal.cat);
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

// Settings page
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return ListView(
      children: const [
        Padding(
          padding: EdgeInsets.all(20),
          child: Text('Settings'),
        )
      ],
    );
  }
}

// TODO:
class DrugPage extends StatelessWidget {
  const DrugPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return ListView(
      children: const [
        Padding(
          padding: EdgeInsets.all(20),
          child: Text('Drugs'),
        )
      ],
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  List<ElevatedButton> getCattleDrugs() {
    List<ElevatedButton> drugList = [];
    for (var drug in cattleDrugList) {
      var newItem = ElevatedButton(onPressed: () {}, child: Text(drug));
      drugList.add(newItem);
    }

    return drugList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Second Route'),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getCattleDrugs())));
  }
}
