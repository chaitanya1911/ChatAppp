import 'package:ChatApp/button.dart';
import 'package:ChatApp/constants.dart';
import 'package:ChatApp/screens/contacts.dart';
import 'package:ChatApp/screens/register.dart';
import 'package:ChatApp/screens/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Login extends StatefulWidget {
  static String id = 'login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool _obscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.deepOrange, Colors.yellow]),
        ),
        child: Form(
          key: _formkey,
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Stack(
                        alignment: Alignment(0, 0),
                        children: [
                          Positioned(
                            top: 15,
                            child: Icon(
                              Icons.circle,
                              color: Colors.white,
                              size: 200,
                            ),
                          ),
                          Image.asset('assets/images/man.png'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                Stack(children: [
                  Positioned(
                    child: IconButton(
                      icon: Icon(Icons.mail),
                      onPressed: null,
                    ),
                  ),
                  TextFormField(
                    validator: (value) => value.isEmpty ? 'Enter Email' : null,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email'),
                  ),
                ]),
                SizedBox(
                  height: 30.0,
                ),
                Stack(children: [
                  Positioned(
                    left: 0.0,
                    child: IconButton(
                      icon: Icon(Icons.lock),
                      onPressed: null,
                    ),
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    validator: (value) => value.length < 6
                        ? 'Enter Password +6 character long'
                        : null,
                    obscureText: _obscure,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your password'),
                  ),
                  Positioned(
                    right: 0.0,
                    child: IconButton(
                        icon: _obscure
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            if (_obscure)
                              _obscure = false;
                            else
                              _obscure = true;
                          });
                        }),
                  ),
                ]),
                SizedBox(
                  height: 14.0,
                ),
                RoundedButton(
                    title: 'Log In',
                    colour: Colors.redAccent,
                    onPressed: () async {
                      FocusManager.instance.primaryFocus.unfocus();
                      if (_formkey.currentState.validate()) {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);

                          if (user != null) {
                            storedLoggedInStatus(true);

                            Navigator.pushNamed(context, Contacts.id);
                          }
                        } catch (e) {
                          setState(() {
                            showSpinner = false;
                          });
                          showSnackBar();
                          print(e);
                        }
                      }
                    })
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: kMessageContainerDecoration.copyWith(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Don't have an account?",
              style: TextStyle(color: Colors.black87, fontSize: 15),
            ),
            FlatButton(
              onPressed: () {
                FocusManager.instance.primaryFocus.unfocus();
                Navigator.pushNamed(context, Register.id);
              },
              child: Text(
                'Register',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSnackBar() {
    final snackBarContent = SnackBar(
      // padding: EdgeInsets.symmetric(horizontal: 60),

      content: Container(
        height: 30,
        alignment: Alignment.centerRight,
        child: Text(
          "Wrong Email/Password",
          style: TextStyle(fontSize: 11),
        ),
      ),
      backgroundColor: Colors.blue,
      action: SnackBarAction(
          label: "Enter Valid Email or Password",
          onPressed: _scaffoldkey.currentState.hideCurrentSnackBar),
    );
    _scaffoldkey.currentState.showSnackBar(snackBarContent);
  }
}
