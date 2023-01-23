import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        title: 'Vet Calculator',
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

enum Animal { equine, sheepGoat, camelid, swine, cattle, dog, cat }

String animalToString(Animal animal) {
  switch (animal) {
    case Animal.equine:
      return 'Equine';
    case Animal.sheepGoat:
      return 'Sheep / Goat';
    case Animal.camelid:
      return 'Camelid';
    case Animal.swine:
      return 'Swine';
    case Animal.cattle:
      return 'Cattle';
    case Animal.dog:
      return 'Dog';
    case Animal.cat:
      return 'Cat';
    default:
      throw UnimplementedError('no string for $animal');
  }
}

class MyAppState extends ChangeNotifier {
  void chooseAnimal(Animal animal) {
    // TODO: go to drug screen
    notifyListeners();
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

    // TODO: add heading with app name
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
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
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
          const SizedBox(height: 25),
          Row(mainAxisSize: MainAxisSize.min, children: [
            // EQUINE BUTTON
            SizedBox(
              width: 150,
              height: 150,
              child: ElevatedButton(
                onPressed: () {
                  // MyAppState.chooseAnimal(Animal.equine);
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
                  //
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
                    //
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
                    //
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
                    //
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
                    //
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
                    //
                  },
                  child: Text(animalToString(Animal.cat)),
                ),
              ),
            ],
          ),
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
