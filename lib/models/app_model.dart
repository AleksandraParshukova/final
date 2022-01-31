
import 'package:shared_preferences/shared_preferences.dart';
import '/consts/const.dart';

class AppModel {
  var _isLogged = false;
  bool get isLogged => _isLogged;

  Future<void> userIsLogged() async {
    final preference = await SharedPreferences.getInstance();

    var login = preference.getString('login') ?? '';
    var password = preference.getString('password') ?? '';

    if (login == authLogin && password == authPassword) {
      _isLogged = true;
    } else {
      _isLogged = false;
    }
  }

  static void saveLoginPassword(String login, String password) async {
    final preference = await SharedPreferences.getInstance();
    preference.setString('login', login);
    preference.setString('password', password);
  }

  static void logOut() async {
    final preference = await SharedPreferences.getInstance();
    preference.setString('login', '');
    preference.setString('password', '');
  }

}

