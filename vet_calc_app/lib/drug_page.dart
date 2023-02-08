import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cattleDrugs.dart';
import 'main.dart';

// TODO: Drug Page
class DrugPage extends StatelessWidget {
  const DrugPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    // debugPrint(appState.curAnimal);

    var animal = appState.curAnimal;

    return Scaffold(
      appBar: AppBar(
        title: Text('Drugs for $animal'),
      ),
      body: Center(
        //have this be buttons of drugs

        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
    // return ListView(
    //   children: const [
    //     Padding(
    //       padding: EdgeInsets.all(20),
    //       child: Text('Drugs'),
    //     )
    //   ],
    // );
  }
}

//Temp Drug Page
//merge this with DrugPage when we have database setup
class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  // List<ElevatedButton> getCattleDrugs() {
  //   List<ElevatedButton> drugList = [];
  //   for (var drug in cattleDrugList) {
  //     var newItem = ElevatedButton(onPressed: () {}, child: Text(drug));
  //     drugList.add(newItem);
  //   }

  //   return drugList;
  // }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var animal = appState.curAnimal;

    List<ElevatedButton> drugList = [];
    for (var drug in cattleDrugList) {
      var newItem = ElevatedButton(
          onPressed: () {
            appState.chooseDrug(drug);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WeightForm()),
            );
          },
          child: Text(drug));
      drugList.add(newItem);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Second Route'),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: drugList)));
  }
}
