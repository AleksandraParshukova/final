import 'package:flutter/material.dart';

import '../models/app_model.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key, required this.appModel})
      : super(key: key);

  final AppModel appModel;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Center(
              child: Text(
                'Заголовок',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.login_outlined),
            title: const Text('Выйти из учетной записи'),
            onTap: () {
              AppModel.logOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, 'authorization', (route) => false);
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
