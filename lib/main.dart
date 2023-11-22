import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/wrapper.dart';
import 'package:brew_crew/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserData?>.value(
      //StreamProvider listens to streams
      //we are using our stream to track the user status
      //StreamProvider is way to provide the root widget with the stream data
      //so that it can listen to the auth changes and pass the data down below
      //and we use StreamProvider to do this so as to know which screen to display
      //upon entering the app
      //i.e if the data gotten from the stream is null the user is signed out which will take you to the authentication screen
      //and if it is the user object, the user is signed in which will take you to the home screen
      //i think the value property is a listener
      //it listening to this stream(AuthService().user)
      //we have to specify what kind of data we going to be listening to
      //which is UserData cus remember the stream returns UserData type
      value: AuthService().user,
      //the value property in the StreamProvider specifies the stream we going to use
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.grey,
        ),
        //so, when the data is gotten from the stream, depending on the data there will be a change in the screens
        // we listens for that change inside the wrapper widget
        home: const Wrapper(),
      ),
    );
  }
}
