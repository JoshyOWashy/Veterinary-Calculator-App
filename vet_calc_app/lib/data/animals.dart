import 'package:flutter/material.dart';
import 'package:vet_calc_app/ui/custom_icons.dart';

enum Animal { equine, sheepGoat, camelid, swine, cattle, dog, cat }

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

Animal stringToAnimal(String animal) {
  switch (animal) {
    case 'Equine':
      return Animal.equine;
    case 'Sheep Goat':
      return Animal.sheepGoat;
    case 'Camelid':
      return Animal.camelid;
    case 'Swine':
      return Animal.swine;
    case 'Cattle':
      return Animal.cattle;
    case 'Dog':
      return Animal.dog;
    case 'Cat':
      return Animal.cat;
    default:
      throw UnimplementedError('no animal for $animal');
  }
}

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
