import 'package:brew_crew/services/auth_service.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  Register({Key? key, required this.toggleView}) : super(key: key);
  final Function toggleView;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0,
              title: const Text("Sign up to Brew Crew"),
              actions: [
                TextButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: const Icon(Icons.person),
                    label: const Text("Sign in"))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ListView(children: [
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                //child:
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          hintText: "Email",
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "enter an email" : null,
                        onChanged: (value) {
                          //value represent whatever is in the textfield at that point
                          //onChanged means everytime a user adds, or removes something into the textfield or
                          //everytime there's a change in the TextFormField the fn is going to run and get us the value
                          //that is currently inside the textfield
                          setState(() {
                            email = value;
                          });
                          //setState(() => email = value);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          hintText: "password",
                        ),
                        validator: (value) => value!.length < 6
                            ? "enter a password 6+ chars long"
                            : null,
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                          //setState(() => password = value);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        // style: ButtonStyle(
                        //   backgroundColor: Colors.pink,
                        // ),
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _authService
                                .registerWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                error = "Please supply a valid email";
                                loading = false;
                              });
                              //after registering we want to show the user the home page but that is going to happen automatically
                              // cus of the stream set up in out root widget listening for auth changes and the user successfully registers on firebase
                              //we get the user back and the user comes down the same stream
                              //and since we get user object i.e the user data back, it means it's no longer null
                              //and when it's not null we return Home() in the wrapper widget i.e we move to the Home screen instead of Authenticate
                            }
                          }
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      )
                    ],
                  ),
                ),
                //),
              ]),
            ),
          );
  }
}
