import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/screens/home/brew_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class BrewList extends StatefulWidget {
  const BrewList({Key? key}) : super(key: key);

  @override
  State<BrewList> createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  @override
  Widget build(BuildContext context) {
    final brews = Provider.of<List<Brew>?>(context) ?? [];

    //final brews = Provider.of<QuerySnapshot?>(context);
    //brews is of type List<Brew> as in Brew()
    //brews = Provider.of<List<Brew>?>(context) ?? [] means if theres is not data in the snapshot(List of documents), use an empty List
    //we are listening to the stream that is sending us QuerySnapshot from the firestore database
    //and each QuerySnapshot is like the snapshot of the firestore collection at that moment in time
    //the snapshot is an object that contains the current document and their properties and values in the collection at moment in time
    //and it contains documents(docs) and we can grab the data from each documents(docs)
    //so to access the documents(docs) from the snapshot is brews!.docs
    //the list of brew objects we want to get from our snapshot are just a list of these objects(name, Strength, sugar i.e Brew() as in Brew model) in the document
    //print(brews!.docs);

    //for(var doc in documents){
    //print(doc.documents);
    //to access data from the documents(docs) in the snapshot is doc.data
    //doc is the variable created in the loop to represent each documents(docs) in the snapshot
    //}

    //we are using the loop cus we want to get a list of brew objects in this case - name, sugars and strength i.e represented with the brew model
    //we don't to cycle through the documents and get the data of a document i.e we don't want to get one data (one of name, sugars and strength)
    //brews!.docs.data
    //instead we want to get a list of brew objects (name, sugars and strength i.e represented with the brew model)
    //the list of brew objects we want to get from our snapshot are just a list of these objects(name, Strength, sugar i.e Brew() as in Brew model) in the document

    return ListView.builder(
        //the list of brew objects we want to get from our snapshot are just a list of these objects(name, Strength, sugar i.e Brew() as in Brew model) in the document
        itemCount: brews.length,
        itemBuilder: (context, index) {
          return BrewTile(brew: brews[index]);
        });
  }
}
