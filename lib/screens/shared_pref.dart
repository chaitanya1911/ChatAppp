import 'package:shared_preferences/shared_preferences.dart';

void storedLoggedInStatus(bool isLoggedStatus) async {
  SharedPreferences preferences = await SharedPreferences.getInstance;
  preferences.setBool('isLoggedIn', isLoggedStatus);
}

Future<bool> getLoggedInStatus() async {
  SharedPreferences preferences = await SharedPreferences.getInstance;
  return preferences.getBool('isLoggedIn') ?? false;
}
