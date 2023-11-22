import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/authenticate/authenticate.dart';
import 'package:brew_crew/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //we listening for the change in screens inside the wrapper
    //we need the context of type buildContext to use Provider.of<UserData>(context);
    //that is why we defined it inside the build fn
    final user = Provider.of<UserData?>(context);
    //recall that whatever we are geting from our service fns is being pass into our UserData model using the _userFromFirebaseUser fn
    //then our stream ..
    //we are using UserData as our type cus that is the kind of data we trying to receive - StreamProvider<UserData?>.value
    //also we specify what type of data we need here(UserData?) so that it knows the stream to listen to - StreamProvider<UserData?>.value
    //at the root widget, when using the streamProvider we are saying it's a UserData type we are receiving through the stream - StreamProvider<UserData?>.value
    //so, we are accessing the user data(UserData) from our provider - StreamProvider<UserData?>.value
    // so here "final user = Provider.of<UserData?>(context);" we access the user data every time we get a new value

    //inside the wrapper we are grabbing the value of the user via the user stream and the provider
    //final user = Provider.of<UserData?>(context);
    //everytime the user logs in we are getting the user object back from that stream
    //and it's being stored inside the user variable i.e final user = Provider.of<UserData?>(context);
    //everyime the user logs out we're going to get a null value from the stream and the user variable will be set to null

    //return user == null ? Authenticate() : Home();

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
