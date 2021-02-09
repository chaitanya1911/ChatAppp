import 'dart:async';

import 'package:ChatApp/screens/chatScreen.dart';
import 'package:ChatApp/screens/contacts.dart';
import 'package:ChatApp/screens/login.dart';
import 'package:ChatApp/screens/register.dart';
import 'package:ChatApp/screens/shared_pref.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/screens/editProfile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        Contacts.id: (context) => Contacts(),
        ChatScreen.id: (context) => ChatScreen(),
        Login.id: (context) => Login(),
        Register.id: (context) => Register(),
        //  Profile.id: (context) => Profile(),
      },
      title: 'Lets Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  @override
  void initState() {
    fcm.getToken().then((token) => print('tokennnnnnnnnnn' + token)); //token

    super.initState();

    Timer(Duration(seconds: 3), () async {
      bool isLoggedIn = await getLoggedInStatus();
      print(isLoggedIn);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return isLoggedIn ? Contacts() : Login();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.redAccent),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        child: Image.asset(
                          'assets/images/cicon.png',
                          fit: BoxFit.cover,
                        ),
                        backgroundColor: Colors.white,
                        radius: 60,
                      ),
                      Padding(padding: EdgeInsets.all(20)),
                      Text(
                        'ChatApp',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      Padding(padding: EdgeInsets.all(30)),
                      Text(
                        'Chat with EveryBody',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }
}
