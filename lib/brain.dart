import 'package:cloud_firestore/cloud_firestore.dart';

class Brain {
  final serverKey =
      "";
  getUser(String email) {
    return FirebaseFirestore.instance.collection("users").doc(email);
  }

  uploadUser(userData) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userData["email"])
        .set(userData); //user data from register page
  }

  uploadChats(chat) {
    FirebaseFirestore.instance.collection("chats").add(chat); // ch
  }

  updateUser(sender, info) {
    if (sender == info["email"]) {
      FirebaseFirestore.instance.collection("users").doc(sender).set(info);
    } else {
      FirebaseFirestore.instance
          .collection("users")
          .doc(info["email"])
          .set(info);
      FirebaseFirestore.instance.collection("users").doc(sender).delete();
    }
  }

  // deleteChat() {
  //   FirebaseFirestore.instance.collection("chats").doc().delete();
  // }
  String getServerKey() {
    return serverKey;
  }

  uploadProfilePic() {}
}
