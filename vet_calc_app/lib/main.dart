import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_calc_app/animal_page.dart';
import 'animals.dart';

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

class MyAppState extends ChangeNotifier {
  // if I make this static, then notify listeners doesn't work
  // if it's not static, then I can't call it
  // not sure why, didn't really look into static enough to figure out
  var curAnimal = "";
  var curDrug = "";
  var curWeight = 0.0;

  void chooseAnimal(Animal animal) {
    curAnimal = animalToString(animal);
    notifyListeners();
  }

  void chooseDrug(String drug) {
    curDrug = drug;
    notifyListeners();
  }

  void chooseWeight(String drug) {
    curWeight = double.parse(drug);
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
  // var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Widget page;
    // switch (selectedIndex) {
    //   case 0:
    //     page = const AnimalButtons();
    //     break;
    //   case 1:
    //     page = const SettingsPage();
    //     break;
    //   default:
    //     throw UnimplementedError('no widget for $selectedIndex');
    // }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            // SafeArea(
            //   child: NavigationRail(
            //     extended: constraints.maxWidth >= 600,
            //     destinations: const [
            //       NavigationRailDestination(
            //         icon: Icon(Icons.home),
            //         label: Text('Home'),
            //       ),
            //       NavigationRailDestination(
            //         icon: Icon(Icons.settings),
            //         label: Text('Settings'),
            //       ),
            //     ],
            //     selectedIndex: selectedIndex,
            //     onDestinationSelected: (value) {
            //       setState(() {
            //         selectedIndex = value;
            //       });
            //     },
            //   ),
            // ),
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: const AnimalPage(),
                // child: const page,
              ),
            )),
          ],
        ),
      );
    });
  }
}
