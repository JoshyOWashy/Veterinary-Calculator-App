# Veterinary-Calculator-App

The Vet RX Calculator is a mobile application available soon on iOS and Android built with Dart/Flutter that allows users to quickly calculate the recommended dosage of a drug for a specific animal based on certain parameters. This provides quick and efficient calculations for veterinarians, students, and other animal health professionals as calculating dosages of a drug without this app would require looking through various handbooks for the equations and calculate them by hand.

[GitHub Repository](https://github.com/JoshyOWashy/Veterinary-Calculator-App)

## Authors

- **Project Partner:** [Lacy Kamm](mailto:lacy.kamm@oregonstate.edu)
- [Robert Houeland](mailto:houelanr@oregonstate.edu)
- [Joshua Minyard](mailto:minyardj@oregonstate.edu)
- [Nawaf Alothman](mailto:alothman@oregonstate.edu)

## Supported Animals

The application currently supports the following animals:

- Equine
- Sheep/Goat
- Camelid
- Swine
- Cattle
- Dog
- Cat

## Features

The Vet RX Calculator provides the following features for users:

- Select an animal to work with

<img src='https://user-images.githubusercontent.com/72106212/226070301-e1b11dab-9429-45a1-8260-f2c4917c4ec3.png' alt='Animal selection page'  height='700'>

- Select a compatible drug to administer to the animal

<img src='https://user-images.githubusercontent.com/72106212/226070353-2ca5626a-3a7e-4c9c-a4c3-369c536be60d.png' alt='general page for choosing drugs/weight' height='700'>  <img src='https://user-images.githubusercontent.com/72106212/226070364-1c35ef3d-dbf5-48b7-8a45-eaa68da2a374.png' alt='list of drugs for the animal' height='700'>

- Enter the animal's weight

<img src='https://user-images.githubusercontent.com/72106212/226070375-53718c7d-db2b-4246-8410-7b3aa77f73b9.png' alt='entering the animals weight' height='700'>

- Calculate the recommended dose of the drug
- Provide extra information about the drug when applicable

<img src='https://user-images.githubusercontent.com/72106212/226070393-cca1359e-03d0-4b9b-bb26-4a277b36a092.png' alt='dosage calculation results' height='700'>

## Usage

To use the Animal Drug Dose Calculator, simply download the app onto your mobile device and launch it. Select the animal you wish to work with from the main menu. From there, select the drug you wish to administer to the animal. Enter the animal's weight in pounds and press the "Calculate" button to get the recommended dose of the drug. If applicable, the app will also provide extra information about the drug. After the calculations are done you have the option of pressing the back button to get a drug dosage for the same animal, or pressing the home button to choose a different animal.

## How to run this app locally

The Veterinary Calculator app is built on the [Flutter](https://docs.flutter.dev/get-started/install) framework and will need to be downloaded to be able to build and run this app. Once Flutter is installed, open a terminal and type  

```bash
flutter doctor -v
```

This will show you everything else that needs to be downloaded and installed to ensure that everything for flutter is working.

To run the app on emulators, the easiest way for Android is to download [Android Studio](https://developer.android.com/studio) and create an emulator through their [Device Manager](https://developer.android.com/studio/run/managing-avds) which will create an android device and allow you to run the app on it. For iOS, [Xcode](https://developer.apple.com/xcode/) and a Mac is needed to create an iOS simulator to run the app.

To run the app type

```bash
flutter run -d {device name}
```

with `device name` being the specific device, such as iOS or Android emulator, that you want to run the app on. To get a list of devices type

```bash
flutter devices
```

## Repository Navigation

All of the files for the UI of the app is located at `vet_calc_app/lib` with the different screens being in `ui`. Files for specific runners such as android and ios are located in `vet_calc_app` in their corresponding folders.

## License

TBD
