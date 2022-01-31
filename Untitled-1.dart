import 'package:flutter/material.dart';

void main() {
  runApp(StickyApp());
}

class StickyApp extends StatefulWidget {
  @override
  _StickyAppState createState() => _StickyAppState();
}

class _StickyAppState extends State<StickyApp> {
  ScrollController _mainScrollController = ScrollController();
  ScrollController _subScrollController = ScrollController();

  double _removableWidgetSize = 200;
  bool _isStickyOnTop = false;

  @override
  void initState() {
    super.initState();
    _mainScrollController.addListener(() {
      if (_mainScrollController.offset >= _removableWidgetSize &&
          !_isStickyOnTop) {
        _isStickyOnTop = true;
        setState(() {});
      } else if (_mainScrollController.offset < _removableWidgetSize &&
          _isStickyOnTop) {
        _isStickyOnTop = false;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: Colors.blueGrey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: 20),
                height: 100,
                color: Colors.pink,
                child: Text(
                  'header'.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Flexible(
                child: Stack(
                  children: [
                    ListView(
                        controller: _mainScrollController,
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: _removableWidgetSize,
                            color: Colors.yellow,
                            child: Text(
                              'scrollable area'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _getStickyWidget(),
                          ListView.builder(
                              controller: _subScrollController,
                              padding: EdgeInsets.only(top: 4),
                              shrinkWrap: true,
                              itemCount: 33,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  margin: EdgeInsets.only(
                                    bottom: 4,
                                  ),
                                  color: Colors.white.withOpacity(0.3),
                                  child: Text(
                                    '$index',
                                    // textAlign: TextAlign.,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              })
                        ]),
                    if (_isStickyOnTop) _getStickyWidget()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _getStickyWidget() {
    return Container(
      alignment: Alignment.center,
      height: 80,
      color: Colors.green,
      child: Text(
        'sticky sub header'.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
