import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:ChatApp/button.dart';
import 'package:ChatApp/constants.dart';
import 'package:ChatApp/screens/contacts.dart';
import 'package:ChatApp/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ChatApp/brain.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Register extends StatefulWidget {
  static String id = 'register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final _formkey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  Brain brain = new Brain();
  bool showSpinner = false;
  String email;
  String password;
  String username;
  bool _obscure = true;
  File _image;
  String imageUrl;
  String myToken;
  Future<void> getImage(ImageSource source) async {
    PickedFile selectedFile = await ImagePicker().getImage(source: source);
    File image = File(selectedFile.path);

    if (image != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxHeight: 700,
          maxWidth: 700,
          cropStyle: CropStyle.circle,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.amber,
            toolbarTitle: 'Crop Image',
            statusBarColor: Colors.transparent,
            backgroundColor: Colors.white,
          ));

      setState(() {
        _image = cropped;
      });
    }
  }

  Future uploadPic(BuildContext context) async {
    String filename = basename(_image.path);
    Reference fireBaseStorageRef =
        FirebaseStorage.instance.ref().child(filename);
    UploadTask uploadTask = fireBaseStorageRef.putFile(_image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    var downloadUrl = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      imageUrl = downloadUrl.toString();
    });
    return imageUrl;
  }

  @override
  void initState() {
    super.initState();
    _fcm.getToken().then((token) => myToken = token);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return Scaffold(
      key: _scaffoldkey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.deepOrange, Colors.yellow]),
        ),
        child: Form(
          key: _formkey,
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: Hero(
                    tag: 'logo',
                    child: Container(
                      child: Container(
                        child: (_image != null)
                            ? Container(
                                height: 300,
                                width: 300,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5000),
                                  child: Image.file(
                                    _image,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              )
                            : Stack(
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
                                  Positioned(
                                    left: 80,
                                    bottom: 40,
                                    child: Icon(
                                      Icons.add_circle,
                                      size: 40,
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ),
                  )),
                  RoundedButton(
                    title: 'Add Photo',
                    colour: Colors.redAccent,
                    onPressed: () async {
                      getImage(ImageSource.gallery);
                    },
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  Stack(
                    children: [
                      Positioned(
                        child: IconButton(
                          icon: Icon(Icons.person),
                          onPressed: null,
                        ),
                      ),
                      TextFormField(
                        validator: (value) =>
                            value.isEmpty ? 'Enter password' : null,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          username = value;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter Username'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Stack(
                    children: [
                      Positioned(
                        child: IconButton(
                          icon: Icon(Icons.mail),
                          onPressed: null,
                        ),
                      ),
                      TextFormField(
                        validator: (value) =>
                            value.isEmpty ? 'Enter Email' : null,
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter your email'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Stack(
                    children: [
                      Positioned(
                        child: IconButton(
                          icon: Icon(Icons.lock),
                          onPressed: null,
                        ),
                      ),
                      TextFormField(
                        validator: (value) => value.isEmpty
                            ? 'Enter password +6 characters'
                            : null,
                        obscureText: _obscure,
                        textAlign: TextAlign.center,
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
                    ],
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  RoundedButton(
                    title: 'Register',
                    colour: Colors.redAccent,
                    onPressed: () async {
                      if (_formkey.currentState.validate()) {
                        String ppurl;
                        if (_image != null) {
                          ppurl = await uploadPic(context);
                        }
                        Map<String, dynamic> userData = {
                          "name": username,
                          "email": email,
                          "ppurl": ppurl,
                          "token": myToken
                        };

                        try {
                          setState(() {
                            showSpinner = true;
                          });
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                          if (newUser != null) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance;
                            prefs.setString('storeName', username);
                            prefs.setString('storeUrl', ppurl);
                            Navigator.pushNamed(context, Contacts.id);
                            brain.uploadUser(userData);
                          }
                        } catch (e) {
                          setState(() {
                            showSpinner = false;
                          });
                          print(e);
                          showSnackBar();
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: kMessageContainerDecoration.copyWith(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //  crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Already have an account?',
                style: TextStyle(color: Colors.black54)),
            FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, Login.id);
              },
              child: Text(
                'Log In',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSnackBar() {
    final snackBarContent = SnackBar(
      content: Text(
        "Email Already exits",
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.blue,
      action: SnackBarAction(
          label: 'Email Already exits',
          onPressed: _scaffoldkey.currentState.hideCurrentSnackBar),
    );
    _scaffoldkey.currentState.showSnackBar(snackBarContent);
  }
}
