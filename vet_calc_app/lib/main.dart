import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_calc_app/animal_page.dart';
import 'animals.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const appName = "Vet RX Calculator";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: appName,
        theme: ThemeData(
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.all(Colors.grey[800]),
          ),
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

  void chooseWeight(String weight) {
    curWeight = double.parse(weight);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: SafeArea(
          child: Center(
              // TODO: need scrollbar on other screens
              child: Scrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: const AnimalPage(),
                    ),
                  ))),
        ),
      );
    });

    /*
      OLD LAYOUT BUILDER IN CASE WE WANT TO SWITCH TO IS

    */
    // return LayoutBuilder(builder: (context, constraints) {
    //   return Scaffold(
    //     body: Row(
    //       children: [
    //         // SafeArea(
    //         //   child: NavigationRail(
    //         //     extended: constraints.maxWidth >= 600,
    //         //     destinations: const [
    //         //       NavigationRailDestination(
    //         //         icon: Icon(Icons.home),
    //         //         label: Text('Home'),
    //         //       ),
    //         //       NavigationRailDestination(
    //         //         icon: Icon(Icons.settings),
    //         //         label: Text('Settings'),
    //         //       ),
    //         //     ],
    //         //     selectedIndex: selectedIndex,
    //         //     onDestinationSelected: (value) {
    //         //       setState(() {
    //         //         selectedIndex = value;
    //         //       });
    //         //     },
    //         //   ),
    //         // ),
    //         Expanded(
    //             child: SingleChildScrollView(
    //           child: Container(
    //             color: Theme.of(context).colorScheme.primaryContainer,
    //             child: const AnimalPage(),
    //             // child: const page,
    //           ),
    //         )),
    //       ],
    //     ),
    //   );
    // });
  }
}
