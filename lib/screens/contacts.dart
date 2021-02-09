import 'package:ChatApp/screens/editProfile.dart';
import 'package:ChatApp/screens/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/brain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'editProfile.dart';
import 'package:ChatApp/screens/listtile.dart';
import 'package:ChatApp/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Constants {
  static const String Logout = 'Logout';
  static const String EditProfile = 'EditProfile';

  static const List<String> choices = [
    EditProfile,
    Logout,
  ];
}

class Contacts extends StatefulWidget {
  static String id = 'contacts';

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  String storeName;
  String storeUrl;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  Brain brain = new Brain();
  TextEditingController searchTextEditingController =
      new TextEditingController();
  List<Tile> s = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  storeData(String name, String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance;
    prefs.setString('storeName', name);
    prefs.setString('storeUrl', url);
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance;
    setState(() {
      storeName = prefs.getString('storeName');
      storeUrl = prefs.getString('storeUrl');
    });
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    try {
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void choiceAction(String choice) {
    if (choice == Constants.Logout) {
      storedLoggedInStatus(false);
      Navigator.popAndPushNamed(context, Login.id);
    } else if (choice == Constants.EditProfile) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Profile(
          loggedInUser: loggedInUser,
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(children: [
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 30),
                width: MediaQuery.of(context).size.width,
                height: 90.0,
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Conversations",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32.0,
                          fontFamily: 'CK',
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: Container(
                        child: PopupMenuButton<String>(
                            icon: Icon(
                              IconData(62530, fontFamily: 'MaterialIcons'),
                            ),
                            onSelected: choiceAction,
                            itemBuilder: (BuildContext context) {
                              return Constants.choices.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(
                                    choice,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }).toList();
                            }),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Stack(children: [
                  Container(
                    // height: 60,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 50,
                    ),
                  ),
                  Positioned(
                    child: Container(
                      color: Colors.white,
                      child: Card(
                        elevation: 20,
                        child: CupertinoTextField(
                          controller: searchTextEditingController,
                          keyboardType: TextInputType.text,
                          placeholder: 'Search',
                          placeholderStyle: TextStyle(
                            color: Color(0xffC4C6CC),
                            fontSize: 14.0,
                            fontFamily: 'Montserrat',
                          ),
                          prefix: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
                            child: Icon(
                              Icons.search,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              Expanded(
                child: Container(
                  //  padding: EdgeInsets.only(bottom: 0),
                  child: Column(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: s,
                    ),
                    StreamBuilder(
                        stream: _firestore.collection('users').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.blue,
                              ),
                            );
                          }
                          final names = snapshot.data.docs;
                          List<Tile> contacts = [];
                          for (var name in names) {
                            final userName =
                                name.data()['name'].toString().toLowerCase();
                            if (name.data()['email'] != loggedInUser.email &&
                                userName.contains(
                                    searchTextEditingController.text)) {
                              final tile = Tile(
                                username: name.data()['name'],
                                sender: loggedInUser.email,
                                img: name.data()['ppurl'],
                                reciever: name.data()['email'],
                                recieverToken: name.data()['token'],
                              );
                              contacts.add(tile);
                            } else {
                              storeData(
                                  name.data()['name'], name.data()['ppurl']);
                            }
                          }
                          return Expanded(
                            child: ListView(
                              children: contacts,
                            ),
                          );
                        }),
                  ]),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
