import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_calc_app/ui/animal_page.dart';
import 'data/animals.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            thumbColor: WidgetStateProperty.all(Colors.grey[800]),
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
  //set default states
  var curAnimal = "";
  var curDrug = "";
  var curWeight = 0.0;
  var curWeightUnits = "kg";

  //set the animal state
  void chooseAnimal(Animal animal) {
    curAnimal = animalToString(animal);
    notifyListeners();
  }

  //sets the drug state
  void chooseDrug(String drug) {
    curDrug = drug;
    notifyListeners();
  }

  //sets the weight state
  void chooseWeight(String weight) {
    curWeight = double.parse(weight);
    notifyListeners();
  }

  //set the weight units state
  void changeWeightUnits(String units) {
    if (units == "lbs") {
      saveWeightPreference(true);
    } else {
      saveWeightPreference(false);
    }

    curWeightUnits = units;
    notifyListeners();
  }

  //set preference for weight units so they stay the same throughout app use
  void saveWeightPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // set to true for lbs, false for kg
    prefs.setBool('curWeightUnits', value);
  }

  void readWeightPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool myPreference = prefs.getBool('curWeightUnits') ?? false;

    if (myPreference) {
      curWeightUnits = "lbs";
    } else {
      curWeightUnits = "kg";
    }
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
    context.read<MyAppState>().readWeightPreference();

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: SafeArea(
          child: Center(
              child: Scrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: const AnimalPage(),
                  ))),
        ),
      );
    });
  }
}
