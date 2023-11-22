import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//NB: we use model so that utilization and maniplation of data can be easier
//NB:A QuerySnapshot contains the results of a query. It can contain zero or more DocumentSnapshot objects
//NB:A DocumentSnapshot contains data read from a document in your Cloud Firestore database. The data can be extracted with the getData() or get(String) methods

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  //so when we create an instanse of DatabaseService in the future we are going to pass in a uid
  //so we have the uid stored in the variable uid
  //which will then be passed into the document mtd

  //collection reference

  //when the code runs and the collection doesn't exist firestore will go ahead and create a collection
  //basically when it sees the collection reference and there is no collection created yet
  //it'll then create a collection. after it's creation, it'll then get a reference.
  //it doesn't matter if we have not created a collection in our firebase console
  //when the code runs and it sees this reference and then it'll create the collection for this reference
  //and then reference it
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection("brews");
  //so we reference the collection when we want to add something to it

  //create a document for the user with a specific ID (user's ID)
  //we can use the ID to create a document for the user
  //and since the document has the ID we then know the document or data that belongs to the user

  //essentially, when a user sign's up, we going to use that ID that firebase generates for the user
  //we then use the ID to create a document inside the collection for the user

  //so when a user sign's up we want to create a new document for that user inside the collection

  //this fn is going to be used to reference the collection
  //we are going to use this fn twice once when they sign up to create there data initially
  //and secondly in the future when they go to the seetings to update their data
  //each time around it's going to the same thing
  //get a reference to their document and update the data
  Future updateUserData(String sugars, String name, int strength) async {
    // the uid will then be passed into the document mtd
    //what that's going to do is get a reference to that document in the collection
    //if the document doesn't exist yet with this uid, firestore will create the document with the uid
    //when a user first sign's up and we call updateUserData() fn and we pass in a uid of that user
    //the document of the user is not going to exist yet, it's going to create the document with that uid
    //thereby linking the firestore document for the user with the firebase user

    return await brewCollection.doc(uid).set({
      "sugars": sugars,
      "name": name,
      "strength": strength,
      //we are setting these infos(data of type Map) in the document
    });
  }
  //we need to call the updateUserData() fn when any user sign's up
  //i.e in the registerWithEmailAndPassword() fn

  //brew list from snapshot (list of brew object from snapshot)
  List<Brew>? _brewListFromSnapshot(QuerySnapshot snapshot) {
    //QuerySnapshot is used with a List
    //making a query as in asking and getting all the document in our firebase collection
    //so here, using QuerySnapshot, we want to get all the documents as a List in our snapshot
    //this fn is used to pass the QuerySnapshot data into the model
    //the list of brew objects we want to get from our snapshot are just a list of these objects(name, Strength, sugar i.e Brew() as in Brew model) in the document
    //essentially, List of Brew() as in Brew Model
    //the snapshot is passed into the _brewListFromSnapshot fn
    //the data of the document(docs) in the snapshot is passed into the Brew model(and the required data are passed into the properties of the model using the keys of the values in the Map)
    //i.e it is mapped into the model (since the data type is Map<String, dynamic>
    //i.e the Map that has the name, sugars and strength key and value. so we want to map into the model)
    //and then it's mutated into a List
    return snapshot.docs.map((doc) {
      return Brew(
          name: (doc.data() as Map<String, dynamic>)["name"] ?? "",
          strength: (doc.data() as Map<String, dynamic>)["Strength"] ?? 0,
          sugars: (doc.data() as Map<String, dynamic>)["sugar"] ?? "0");
    }).toList();
  }
  //(doc.data() as Map<String, dynamic>)["name"] == doc["name"] == doc.get("name")

  //the stream is going to notify us on any document, changes of documents or any document changes in the database
  // the stream is going to notify us of documents inside the firestore collection initially and also changes to those document, when they occur
  //if a new document is added or if a document is changed, come down the stream and notify us
  //every data gotten from the stream is going to be a snapshot of that collection(brewCollection) at that moment in time
  //the snapshot is an object that contains the current document or the enter collection of document(depending on the type of snapshot) and their properties and values in the collection at moment in time
  //we get the data we need from the snapshot and organise it in a way we want in our app
  //when we add a new document when a user signs up,
  //at that moment in time the snapshot comes down the stream through the root widget

  // i think here he was talking about QuerySnapshot
  //(QuerySnapshot) the snapshot gotten will represent  the brews collection at that moment in time. it will contain the documents in it including the ones that just been added
  //so that we can extract the data and do something with it

  //if we change(update) the document in the database, we get a fresh snapshot from the stream
  //which represent the current state of that collection including the fresh change
  //so we always get an up to date data/snapshot of the brews collection all of the time

  //setting up the stream to listen to the database
  //get brews stream
  //QuerySnapshot is the snapshot of the firestore collection at that moment in time (when something changes)
  //that is the QuerySnapshot dosn't just hold one document, it hold all the document in the collection
  Stream<List<Brew>?> get brews {
    return brewCollection
        .snapshots()
        .map((QuerySnapshot snapshot) => _brewListFromSnapshot(snapshot));
    //brewCollection is the variable of type CollectionReference which references the brewsCollection (FirebaseFirestore.instance.collection("brews");)
    //snapshots() is mtd built into firestore library
    //brewCollection.snapshots() is our stream
  }

  //basically we want to persist the that that we inputed in the setting bottomsheet
  //i.e name, sugars and strength inside the various widget used(textFields, dropdowns, slider)
  //essentially, we want whatever data in those widget to be the current user data and also not to be empty or resort back to default
  //UserDataDoc is the model created to hold the data we want to persist

  //user data(UserDataDoc) from snapshot
  //this fn is used to pass the documentSnapshot data into the model
  UserDataDoc _userDataFromSnapshot(DocumentSnapshot snapshot) {
    //DocumentSnapshot is used when we want to get the data in a document unlike QuerySnapshot(getting all document)
    //the reason we're returning UserDataDoc() straight and not doing - snapshot.docs.map((doc) before returning our modelis cus
    //this uses DocumentSnapshot and not QuerySnapshot
    return UserDataDoc(
        //uid is gotten when authentication is done
        uid: uid,
        name: snapshot['name'],
        strength: snapshot['strength'],
        sugars: snapshot['sugars']);
  }

  //get user doc stream
  //
  //this stream is used to listen for the data in UserDataDoc()
  //we going to use the uid gotten when user sign's up cus its specifies or identifies the document we want
  //so we a user log's in, the user's the uses data will be gotten from the document using the uid
  Stream<UserDataDoc> get userData {
    return brewCollection
        .doc(uid)
        .snapshots()
        .map((DocumentSnapshot snapshot) => _userDataFromSnapshot(snapshot));
    //we passing the uid to the document we want (docs(uid)) and the uid allows us to know which document we want to get
    //i.e which user's document since every user has a uid
    //essentially it'll let us know which user is logged in and the document to get(user's document)

    //the stream is taking the current firebase stream from our firestore document based on the uid
    //and every time there is a change or initially we are receiving a snapshot to tell us about the document(the data on it) at that moment in time
  }
}
