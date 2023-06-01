import 'package:flutter/material.dart';
import 'package:vet_calc_app/ui/custom_icons.dart';

enum Animal { equine, sheepGoat, camelid, swine, cattle, dog, cat }

//returns a string for each animal that is the exact string for the animals
//on the database
String animalToString(Animal animal) {
  switch (animal) {
    case Animal.equine:
      return 'Equine';
    case Animal.sheepGoat:
      return 'Sheep Goat';
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

//returns an Icon widget for each animal
Widget animalIcon(Animal animal) {
  switch (animal) {
    case Animal.equine:
      return const Icon(CustomIcons.horse);
    case Animal.sheepGoat:
      return const Icon(CustomIcons.sheep);
    case Animal.camelid:
      return const Icon(CustomIcons.giraffe);
    case Animal.swine:
      return const Icon(CustomIcons.piggyBank);
    case Animal.cattle:
      return const Icon(CustomIcons.hatCowboy);
    case Animal.dog:
      return const Icon(CustomIcons.dog);
    case Animal.cat:
      return const Icon(CustomIcons.cat);
    default:
      throw UnimplementedError('no icon for $animal');
  }
}
