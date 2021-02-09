import 'dart:io';
import 'package:ChatApp/brain.dart';
import 'package:ChatApp/screens/contacts.dart';
import 'package:ChatApp/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart';

class Profile extends StatefulWidget {
  static String id = "editProfile";
  final User loggedInUser;
  Profile({this.loggedInUser});
  @override
  _ProfileState createState() => _ProfileState(loggedInUser: loggedInUser);
}

class _ProfileState extends State<Profile> {
  final User loggedInUser;
  bool _updatedata = false;
  String name;
  String urlLoad;
  final _firestore = FirebaseFirestore.instance;
  bool _showPass = false;
  _ProfileState({this.loggedInUser});
  File _image;
  String imageUrl;
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
      print(imageUrl);
    });
    return imageUrl;
  }

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

    email.text = loggedInUser.email;
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
            Navigator.pushNamed(context, Contacts.id);
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
              final names = snapshot.data.docs;
              for (var name in names) {
                final userName = name.data()['name'];
                final url = name.data()['ppurl'];
                if (name.data()['email'] == loggedInUser.email) {
                  username.text = userName;
                  urlLoad = url;
                }
              }
              return ListView(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                        painter: HeaderCurvedContainer(),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text('EDIT PROFILE',
                                style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600)),
                          ),
                          Container(
                            height: 200,
                            width: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: (_image == null)
                                  ? ((urlLoad != null)
                                      ? Image.network(urlLoad,
                                          fit: BoxFit.scaleDown)
                                      : Image.asset('assets/images/man.png',
                                          fit: BoxFit.contain))
                                  : Image.file(_image),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 450,
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    textfield(
                                        hintText: 'Username',
                                        controller: username),
                                    textfield(
                                        hintText: 'Email', controller: email),
                                    Container(
                                      height: 55,
                                      width: double.infinity,
                                      child: RaisedButton(
                                        onPressed: () async {
                                          setState(() {
                                            _updatedata = true;
                                          });
                                          urlLoad = await uploadPic(context);
                                          Map<String, String> info = {
                                            "name": username.text,
                                            "email": email.text,
                                            "ppurl": urlLoad
                                          };
                                          if (loggedInUser.email
                                                  .compareTo(email.text) ==
                                              0) {
                                            brain.updateUser(
                                                loggedInUser.email, info);
                                            Navigator.popAndPushNamed(
                                                context, Contacts.id);
                                          } else {
                                            loggedInUser
                                                .updateEmail(email.text);
                                            brain.updateUser(
                                                loggedInUser.email, info);
                                            Navigator.popAndPushNamed(
                                                context, Login.id);
                                          }
                                          if (pass.text != null &&
                                              pass.text
                                                      .compareTo(repass.text) ==
                                                  0) {
                                            loggedInUser
                                                .updatePassword(pass.text);
                                            Navigator.popAndPushNamed(
                                                context, Contacts.id);
                                          }
                                          setState(() {
                                            _updatedata = false;
                                          });
                                        },
                                        color: Colors.black54,
                                        child: Center(
                                            child: Text(
                                          'Update All',
                                          style: TextStyle(
                                            fontSize: 23,
                                            color: Colors.white,
                                          ),
                                        )),
                                      ),
                                    ),
                                    Container(
                                      height: 55,
                                      width: double.infinity,
                                      child: RaisedButton(
                                        color: Colors.black54,
                                        onPressed: () {
                                          setState(() {
                                            _showPass = !_showPass;
                                          });
                                        },
                                        child: Center(
                                            child: Text(
                                          'Change Password?',
                                          style: TextStyle(
                                            fontSize: 23,
                                            color: Colors.white,
                                          ),
                                        )),
                                      ),
                                    ),
                                    Visibility(
                                        visible: _showPass,
                                        child: textfield(
                                            hintText: 'Password',
                                            controller: pass)),
                                    Visibility(
                                      visible: _showPass,
                                      child: textfield(
                                          hintText: 'Confirm password',
                                          controller: repass),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 270, left: 184),
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              getImage(ImageSource.gallery);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xFF555555);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
