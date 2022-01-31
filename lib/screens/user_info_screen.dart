import 'dart:convert';

import 'package:final_flutter_project/models/app_model.dart';
import 'package:final_flutter_project/models/user_info.dart';
import 'package:final_flutter_project/models/user_todo.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'navigation_drawer_screen.dart';

Future<List<Todo>> fetchUsersToDoList(http.Client client, int userId) async {
  var url = 'https://jsonplaceholder.typicode.com/todos?userId=$userId';
  final response = await client.get(Uri.parse(url));

  return compute(parseToDoList, response.body);
}

List<Todo> parseToDoList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Todo>((json) => Todo.fromJson(json)).toList();
}

class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget(
      {Key? key, required this.appModel, @required this.userInfo})
      : super(key: key);

  final AppModel appModel;
  final User? userInfo;

  @override
  _UserInfoWidgetState createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  final ScrollController _userInfoScrollController = ScrollController();
  final double _removableWidgetSize = 600;
  bool _isStickyOnTop = false;

  @override
  void initState() {
    super.initState();
    _userInfoScrollController.addListener(() {
      if (_userInfoScrollController.offset >= _removableWidgetSize &&
          !_isStickyOnTop) {
        _isStickyOnTop = true;
        setState(() {});
      } else if (_userInfoScrollController.offset < _removableWidgetSize &&
          _isStickyOnTop) {
        _isStickyOnTop = false;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Информация о пользователе'),
        ),
        drawer: NavigationDrawerWidget(appModel: widget.appModel),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Stack(
                children: [
                  ListView(
                    padding: EdgeInsets.all(0),
                    controller: _userInfoScrollController,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: _removableWidgetSize,
                        child: _UserBasicInformationWidget(
                            userInfo: widget.userInfo),
                      ),
                      _getHeadingToDoListWidget(context),
                      _UserToDoListWidget(id: widget.userInfo!.id),
                    ],
                  ),
                  if (_isStickyOnTop) _getHeadingToDoListWidget(context)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserBasicInformationWidget extends StatelessWidget {
  const _UserBasicInformationWidget({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  final User? userInfo;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const _UserPhotoWidget(),
          Row(
            children: [
              Text(
                'id: ',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                '${userInfo?.id}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'name: ',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                '${userInfo?.name}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'email: ',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                '${userInfo?.email}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'phone: ',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                '${userInfo?.phone}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'website: ',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                '${userInfo?.website}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          _UserInfoAddressWidget(
            address: userInfo?.address,
          ),
          _UserInfoCompanyWidget(company: userInfo?.company),
        ],
      ),
    );
  }
}

class _UserInfoCompanyWidget extends StatelessWidget {
  const _UserInfoCompanyWidget({
    Key? key,
    required this.company,
  }) : super(key: key);

  final Company? company;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Company', style: Theme.of(context).textTheme.headline5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Name: ', style: Theme.of(context).textTheme.headline5),
            Text('${company?.name}',
                style: Theme.of(context).textTheme.headline6),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('BS: ', style: Theme.of(context).textTheme.headline5),
            Text('${company?.bs}',
                style: Theme.of(context).textTheme.headline6),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Catch phrase: ',
                style: Theme.of(context).textTheme.headline5),
            Expanded(
              child: Text(
                '${company?.catchPhrase}',
                style: Theme.of(context).textTheme.headline6,
                softWrap: true,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _UserInfoAddressWidget extends StatelessWidget {
  const _UserInfoAddressWidget({
    Key? key,
    required this.address,
  }) : super(key: key);

  final Address? address;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Address', style: Theme.of(context).textTheme.headline5),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Zipcode: ', style: Theme.of(context).textTheme.headline5),
            Text('${address?.zipcode}',
                style: Theme.of(context).textTheme.headline6),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('City: ', style: Theme.of(context).textTheme.headline5),
            Text('${address?.city}',
                style: Theme.of(context).textTheme.headline6),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Street: ', style: Theme.of(context).textTheme.headline5),
            Text('${address?.street}',
                style: Theme.of(context).textTheme.headline6),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Suite: ', style: Theme.of(context).textTheme.headline5),
            Text('${address?.suite}',
                style: Theme.of(context).textTheme.headline6),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Geo: lat ', style: Theme.of(context).textTheme.headline5),
            Text('${address?.geo.lat}',
                style: Theme.of(context).textTheme.headline6),
            Text(', lng: ', style: Theme.of(context).textTheme.headline5),
            Text('${address?.geo.lng}',
                style: Theme.of(context).textTheme.headline6),
          ],
        ),
      ],
    );
  }
}

class _UserPhotoWidget extends StatelessWidget {
  const _UserPhotoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const SizedBox(
        width: 150,
        height: 150,
        child: Image(
          image: AssetImage('assets/noavatarimage.png'),
        ),
      ),
    );
  }
}

class _UserToDoListView extends StatelessWidget {
  const _UserToDoListView({Key? key, required this.todoList}) : super(key: key);

  final List<Todo> todoList;

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.all(5),
      itemCount: todoList.length,
      itemBuilder: (BuildContext context, int index) {
        return _UserToDListItem(toDo: todoList[index]);
      },
    );
  }
}

class _UserToDListItem extends StatelessWidget {
  const _UserToDListItem({Key? key, required this.toDo}) : super(key: key);

  final Todo toDo;
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text(toDo.title), value: toDo.completed, onChanged: (value) {});
  }
}

class _UserToDoListWidget extends StatelessWidget {
  const _UserToDoListWidget({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Todo>>(
        future: fetchUsersToDoList(http.Client(), id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return _UserToDoListView(todoList: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

Container _getHeadingToDoListWidget(BuildContext context) {
  return Container(
    alignment: Alignment.center,
    height: 40,
    color: Colors.lightBlue,
    child: Text(
      'Список задач пользователя',
      style: Theme.of(context).textTheme.headline6,
      // style: TextStyle(
      //   color: Colors.white,
      //   fontSize: 16,
      //   fontWeight: FontWeight.bold,
      //),
    ),
  );
}
