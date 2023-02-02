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