//we use model so that utilization and maniplation of data can be easier
class UserData {
  final String uid;

  UserData({required this.uid});
}

//everytime we get some kind of document snapshot down the stream of the user's document
//we are going to take that data and put into the UserDataDoc model
class UserDataDoc {
  final String? uid;
  final String name;
  final String sugars;
  final int strength;

  UserDataDoc(
      { this.uid,
      required this.name,
      required this.strength,
      required this.sugars});
}
