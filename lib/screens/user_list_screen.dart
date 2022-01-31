import 'dart:convert';

import 'package:final_flutter_project/consts/const.dart';
import 'package:final_flutter_project/models/user_info.dart';
import 'package:final_flutter_project/screens/user_info_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/app_model.dart';
import 'navigation_drawer_screen.dart';

Future<List<User>> fetchUsers(http.Client client) async {
  final response = await client.get(Uri.parse(usersUrl));
  return compute(parseUsers, response.body);
}

List<User> parseUsers(String responseBody) {
  final parsed = jsonDecode(responseBody) as List<dynamic>;
  return parsed.map((dynamic json) => User.fromJson(json)).toList();
}

class UserListWidget extends StatelessWidget {
  const UserListWidget({
    Key? key,
    required this.appModel,
  }) : super(key: key);

  final AppModel appModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Список пользователей'),
        ),
        drawer: NavigationDrawerWidget(appModel: appModel),
        body: Container(
          child: FutureBuilder<List<User>>(
            future: fetchUsers(http.Client()),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                      '${snapshot.error}'), //Text('Ошибка получения списка пользователей'),
                );
              } else if (snapshot.hasData) {
                return UserListView(
                    appModel: appModel, userList: snapshot.data!);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class UserListView extends StatelessWidget {
  const UserListView({Key? key, required this.appModel, required this.userList})
      : super(key: key);

  final List<User> userList;
  final AppModel appModel;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(5),
      itemCount: userList.length,
      itemBuilder: (BuildContext context, int index) {
        return _UserListItem(appModel: appModel, userInfo: userList[index]);
      },
    );
  }
}

class _UserListItem extends StatelessWidget {
  const _UserListItem({
    Key? key,
    required this.appModel,
    required this.userInfo,
  }) : super(key: key);

  final User userInfo;
  final AppModel appModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(3),
      color: Colors.blueGrey[10],
      shadowColor: Colors.blueGrey,
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      UserInfoWidget(appModel: appModel, userInfo: userInfo)));
           },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.info_outline, color: Colors.blue, size: 45),
              title: Column(
                children: [
                  Row(
                    children: [
                      const Text('id: '),
                      Text((userInfo.id).toString()),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text('Name: '),
                      Text(userInfo.name),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('e-mail: '),
                      Text((userInfo.email).toString()),
                    ],
                  ),
                ],
              ),
            ),
            //subtitle: Text('Modern Talking Album'),
          ],
        ),
      ),
    );
  }
}
