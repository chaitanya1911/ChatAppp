import 'package:ChatApp/brain.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class ViewProfile extends StatefulWidget {
  static String id = "ViewProfile";
  final String loggedInUser;
  final String img, sender;
  ViewProfile({this.loggedInUser, this.sender, this.img});
  @override
  _ViewProfileState createState() =>
      _ViewProfileState(loggedInUser: loggedInUser, sender: sender, img: img);
}

class _ViewProfileState extends State<ViewProfile> {
  final String loggedInUser;
  final String img, sender;
  bool _updatedata = false;
  String name;
  String urlLoad;
  final _firestore = FirebaseFirestore.instance;

  _ViewProfileState({this.loggedInUser, this.sender, this.img});

  Widget textfield({String hintText, TextEditingController controller}) {
    return Material(
        elevation: 4,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                letterSpacing: 2,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
              fillColor: Colors.white30,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none)),
        ));
  }

  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  TextEditingController repass = new TextEditingController();
  Brain brain = new Brain();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF555555),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _updatedata,
        child: StreamBuilder(
            stream: _firestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blueAccent,
                  ),
                );
              }

              final userName = loggedInUser;
              final url = img;
              email.text = sender;
              print(sender);
              username.text = userName;
              urlLoad = url;

              return Container(
                  color: Colors.white,
                  child: ListView(
                    children: [
                      Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height / 2,
                                width: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                    child: ((urlLoad != null)
                                        ? Image.network(urlLoad,
                                            fit: BoxFit.scaleDown)
                                        : Image.asset('assets/images/man.png',
                                            fit: BoxFit.contain))),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 250,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                            textAlign: TextAlign.center,
                                            readOnly: true,
                                            controller: username),
                                        TextFormField(
                                            textAlign: TextAlign.center,
                                            readOnly: true,
                                            controller: email),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ));
            }),
      ),
    );
  }
}
