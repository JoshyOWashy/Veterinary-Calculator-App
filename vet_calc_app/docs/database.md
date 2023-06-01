# Database Documentation

## Firebase

The app uses the Realtime Database from Firebase. To access the database, go to [Firebase Console](https://console.firebase.google.com/u/0/), login and select the `Veterinary-Application` application. This will bring up the project. To access the data in the database, select `Realtime Database` from the left pane. This will bring up the database where all of the drug information is stored.

## Modifications

While in the Realtime Database section in Firebase, you can click on the arrows to expand certain sections of the data where you can modify the data. When finished modifying, press `Enter` on your keyboard to apply those changes.

An easier method is to click on the three vertical dots on the top right and click `Export JSON`. This will download a JSON file of the database where modifications can be made and everything in the database will be shown. When finished modifying, save the file and go back to the `Realtime Database` and click the three dots and select `Import JSON`. Select the JSON file you just modified with the changes and apply that to the database.

## Structure

The high level structure of the database is as follows:

- The top most level is an object called `Species` which has all of animals/species that the app supports.

- For each animal, there is an array called `Drugs` which has all of the drugs for that specific animal/species.

- Inside of the `Drugs`. There will be an array or string (only a string for mEq cases) of `Concentration`, an array or string (only a string in mEq cases) of `Dosage`, a string `Name`, and possibly a string `Notes` (if there are no notes for that drug, do not add a `Notes` object). For particular cases where there is a combination of drugs that all have different concentrations and dosages such as `Ketamine “Stun” Xylazine, (100 mg/ml) Ketamine (100 mg/ml), Butorphanol (10 mg/ml)`, there is a `Seperated` object that should be set to `true` so the app will calculate the dosages and concentrations seperately for each drug in that combination

- The `Concentration` array may have one or more concentrations which have the following: a string `high`, a string `low` and a string `units`. `low` and `high` are the decimal values of the range of concentration for that particualr drug, if there is no range of concentration and just a single concentration (1mg vs 1-5mg), then make `high` and `low` be the same decimal number.

- The `Dosages` array may have one or more dosages which have the following: a string `high`, a string `low` and a string `units`. `low` and `high` are the decimal values of the range of dosage for that particualr drug, if there is no range of dosage and just a single dosage (1mg vs 1-5mg), then make `high` and `low` be the same decimal number.

The database as a JSON file looks as follows:

```json
{
    Species: {
        "Camelid": {
            "Drugs": [
                {
                    "Concentration": [
                        {
                            "high": 10,
                            "low" : 10,
                            "units": "ml",
                        },
                        ...
                    ],
                    "Dosage": [
                        {
                            "high": 10,
                            "low" : 10,
                            "units": "mg",
                        },
                        ...
                    ],
                    "Name": "Drug Name",
                    "Notes": "Add Notes Here",
                    "Seperated": true,
                },
                {},
                ...
            ]
        },
        "Cat": {
            ...
        }
        ...
    }
}

```
