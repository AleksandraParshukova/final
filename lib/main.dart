import 'package:final_flutter_project/models/app_model.dart';
import 'package:final_flutter_project/screens/authorization_screen.dart';
import 'package:final_flutter_project/screens/user_info_screen.dart';
import 'package:final_flutter_project/screens/user_list_screen.dart';
import 'package:flutter/material.dart';

import 'models/user_info.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final appModel = AppModel();
  await appModel.userIsLogged();
  runApp(MyApp(appModel: appModel));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.appModel}) : super(key: key);

  final AppModel appModel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: appModel.isLogged ? '/' : 'authorization',
      routes: {
        'authorization': (context) => const AuthorizationWidget(),
        '/': (context) => UserListWidget(appModel: appModel,),
        '/userInfo': (context) => UserInfoWidget(appModel: appModel,),
      },
    );
  }
}

