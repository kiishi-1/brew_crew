import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugar = ["0", "1", "2", "3", "4"];

  //form values
  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData?>(context);
    return StreamBuilder<UserDataDoc>(
      stream: DatabaseService(uid: user!.uid).userData,
      builder: ((context, snapshot) {
        //the snapshot here is a reference to the data as it comes down the stream
        //every time we get data down the stream this snapshot refers to it
        //don't get it mixed up with the snapshot from firebase

        //we have to check that we have data coming
        //i don't want to do anything or anything to happen until i have data or until data is gotten(until there's data in the snapshot)
        if (snapshot.hasData) {
          UserDataDoc? userDataDoc = snapshot.data;
          //snapshot.data is how we access the data

          return Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  "Update your brew settings",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: userDataDoc!.name,
                  decoration: textInputDecoration,
                  validator: ((value) =>
                      value!.isEmpty ? "Please enter a name" : null),
                  onChanged: ((value) {
                    setState(() {
                      _currentName = value;
                    });
                  }),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField(
                    decoration: textInputDecoration,
                    //is the of value DropdownButtonFormField
                    value: _currentSugars ?? userDataDoc.sugars,
                    // _currentSugars ?? userDataDoc!.sugars means use the current data. if there isn't any, use the one stored in the database
                    items: sugar
                        .map((e) => DropdownMenuItem(
                            //the value property is what is being updated
                            //it tracks the value of what is selected
                            value: e,
                            child: Text("$e sugars")))
                        .toList(),
                    onChanged: ((value) {
                      setState(() {
                        _currentSugars = value.toString();
                      });
                    })),
                const SizedBox(
                  height: 10,
                ),
                Slider(
                  //Slider works with type double
                  min: 100.0,
                  max: 900.0,
                  divisions: 8,
                  value: (_currentStrength ?? userDataDoc.strength).toDouble(),
                  // _currentStrength ?? userDataDoc!.strength means use the current data. if there isn't any, use the one stored in the database
                  onChanged: ((value) {
                    setState(() {
                      _currentStrength = value.round();
                      //.round is going to round the value up to the nearest integer
                      //and since our slider works in hundreds, it'll always round up to hundreds
                    });
                  }),
                  activeColor:
                      Colors.brown[_currentStrength ?? userDataDoc.strength],
                  inactiveColor:
                      Colors.brown[_currentStrength ?? userDataDoc.strength],
                  // _currentStrength ?? userDataDoc!.strength means use the current data. if there isn't any, use the one stored in the database
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  child: const Text(
                    "Update",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await DatabaseService(uid: user.uid).updateUserData(
                        _currentSugars ?? userDataDoc.sugars,
                        _currentName ?? userDataDoc.name,
                        _currentStrength ?? userDataDoc.strength,
                        // _currentStrength ?? userDataDoc!.strength means use the current data. if there isn't any, use the one stored in the database
                        //in this case, the data to update
                      );
                      //so what is happening here is, the data was sent to the database(fireStore collection ("brews") - brewCollection)
                      //it found the document with the uid and it has updated does values
                      //so when anything changes inside the collection, we get a notification and a value sent(snapshot value)
                      //so we get the new list of brews(List<Brew>) after the change and the change reflects what is currently in the firestore collection
                      //then we out put the new list of data
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        } else {
          return Loading();
        }
      }),
    );
  }
}
