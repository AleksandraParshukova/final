import 'package:final_flutter_project/models/app_model.dart';
import 'package:flutter/material.dart';

import '/consts/const.dart';

class AuthorizationWidget extends StatefulWidget {
  const AuthorizationWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthorizationWidget> createState() => _AuthorizationWidgetState();
}

class _AuthorizationWidgetState extends State<AuthorizationWidget> {
  final textFieldDecoration = const InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 5));

  TextEditingController textEditControllerLogin = TextEditingController();
  TextEditingController textEditControllerPassword = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Авторизация пользователя'),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(children: [
            const Text(
              'Login',
            ),
            TextField(
              style: const TextStyle(fontWeight: FontWeight.w600),
              controller: textEditControllerLogin,
              decoration: textFieldDecoration,
              textAlign: TextAlign.center,
              readOnly: false,
            ),
            const Text(
              'Password',
            ),
            TextField(
              style: const TextStyle(fontWeight: FontWeight.w600),
              controller: textEditControllerPassword,
              decoration: textFieldDecoration,
              textAlign: TextAlign.center,
              readOnly: false,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25))),
              ),
              onPressed: () {
                final login = textEditControllerLogin.text;
                final password = textEditControllerPassword.text;
                if (login == authLogin && password == authPassword) {
                  AppModel.saveLoginPassword(login, password);
                  Navigator.pushReplacementNamed(context, '/');
                } else {
                  showSnackBar(context);
                }
              },
              child: const Text(
                'Войти',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: '',
          onPressed: () {},
        ),
        content: const Text('НЕ правильный логин или пароль!'),
        duration: const Duration(milliseconds: 1500),
        width: 280.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
