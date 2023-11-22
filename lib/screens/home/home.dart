import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/screens/home/brew_list.dart';
import 'package:brew_crew/screens/home/settings_form.dart';
import 'package:brew_crew/services/auth_service.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Brew>?>.value(
      value: DatabaseService().brews,
      //StreamProvider listens to streams
      //we are using our stream to track the changes in our snapshots
      //StreamProvider is way to provide the root widget with the stream data
      //so that it can listen to the snapshot changes and pass the data down below
      //and we use StreamProvider to do this so as to use(display) the data in the snapshot in our app
      //the list of brew objects we want to get from our snapshot are just a list of these objects(name, Strength, sugar) in the document
      //the value property is a listener
      //it listening to this stream(DatabaseService().brews)
      //we have to specify what kind of data we going to be listening to
      //which is List<Brew> cus remember the stream returns List<Brew> type
      initialData: [],
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: const Text("Brew Crew"),
          backgroundColor: Colors.brown[400],
          elevation: 0,
          actions: [
            TextButton.icon(
                onPressed: () async {
                  await _authService.signOut();
                },
                icon: const Icon(Icons.person),
                label: const Text("logout")),
            TextButton.icon(
                onPressed: () {
                  _showSettingsPanel();
                },
                icon: const Icon(Icons.settings),
                label: const Text("settings")),
          ],
        ),
        body: BrewList(),
      ),
    );
  }
}
