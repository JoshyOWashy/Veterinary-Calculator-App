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
  var animals = [
    "Equine",
    "Sheep/Goat",
    "Camelid",
    "Swine",
    "Cattle",
    "Dog",
    "Cat"
  ];

  void chooseAnimal() {
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
        page = SettingsPage();
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
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  //
                },
                child: Text(appState.animals[0]),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  //
                },
                child: Text(appState.animals[1]),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  //
                },
                child: Text(appState.animals[2]),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  //
                },
                child: Text(appState.animals[3]),
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
