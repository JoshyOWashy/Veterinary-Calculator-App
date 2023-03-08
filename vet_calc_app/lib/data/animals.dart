import 'package:flutter/material.dart';
import 'package:vet_calc_app/ui/custom_icons.dart';

enum Animal { equine, sheepGoat, camelid, swine, cattle, dog, cat }

String animalToString(Animal animal) {
  switch (animal) {
    case Animal.equine:
      return 'Equine';
    case Animal.sheepGoat:
      return 'Sheep \nand Goat';
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

Widget animalIcon(Animal animal) {
  switch (animal) {
    case Animal.equine:
      return const Icon(CustomIcons.horse);
    case Animal.sheepGoat:
      return const Icon(CustomIcons.sheep);
    case Animal.camelid:
      return const Icon(CustomIcons.giraffe);
    case Animal.swine:
      return const Icon(CustomIcons.piggy_bank);
    case Animal.cattle:
      return const Icon(CustomIcons.hat_cowboy);
    case Animal.dog:
      return const Icon(CustomIcons.dog);
    case Animal.cat:
      return const Icon(CustomIcons.cat);
    default:
      throw UnimplementedError('no icon for $animal');
  }
}