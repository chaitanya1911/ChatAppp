import 'package:cloud_firestore/cloud_firestore.dart';

class Brain {
  final serverKey =
      "AAAAPyRoId0:APA91bHOcs1fUJ-BOHwMWI_13G8CTyFtlYC5JjQWN2vmZC1anZuwyTUX_KLQzkYWnvKR_LxXx8m-W6QWjTP8U-uMt0acNgKoaB0avTBSKaIVfhYYCp0l9_r6mLqIyUr_psaRI2gTqi4I";
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
