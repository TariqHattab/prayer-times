import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _times = {};
  String convertToPmAm(String time) {
    var firstTwoNums = int.parse(time.substring(0, 2));
    var theRest = time.substring(2);

    if (firstTwoNums > 12) {
      firstTwoNums -= 12;
      return firstTwoNums.toString() + theRest + ' Pm';
    }
    return time + ' Am';
  }

  Future<void> _getData() async {
    var parameters = {
      'city': 'Jeddah',
      'country': 'KSA',
      // 'state': 'makkah',
      'method': jsonEncode(4),
      'midnightMode': jsonEncode(1),
    };
    var url = Uri.https(
        'api.aladhan.com', '/v1/timingsByCity/:date_or_timestamp', parameters);

    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    _times = jsonDecode(response.body)['data']['timings'] as Map;
    print('Response body: ${_times}');

    setState(() {});
    print(_times.values);
  }

  Widget buildCellContainer({
    Widget child,
    double padding,
  }) {
    return Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green[200].withOpacity(.2),
              Colors.green[300].withOpacity(.2),
            ],
          ),
          // border: Border.all(
          //   width: 1,
          //   color: Colors.green,
          // ),
        ),
        child: child);
  }

  @override
  Widget build(BuildContext context) {
    var keys = _times.keys.toList();
    var values = _times.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.centerRight,
        //       end: Alignment.centerLeft,
        //       colors: [
        //         Colors.green[200],
        //         Colors.blue[100],
        //       ],
        //     ),
        //   ),
        // ),
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/images/pic-for-flutter-times.jpg"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Center(
          child: Container(
            width: double.infinity,
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              itemBuilder: (ctx, index) {
                var keys = _times.keys.toList();
                var values = _times.values.toList();
                return Column(
                  children: [
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: buildCellContainer(
                              child: Text(keys[index]),
                              padding: 16,
                            ),
                          ),
                          VerticalDivider(
                            width: 0,
                            thickness: 1,
                            color: Colors.green,
                            endIndent: 0,
                            indent: 0,
                          ),
                          Expanded(
                            flex: 3,
                            child: buildCellContainer(
                              child: Text(convertToPmAm(values[index])),
                              padding: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      indent: 0,
                      endIndent: 0,
                      thickness: 1,
                      color: Colors.green,
                      height: 0,
                    )
                  ],
                );
              },
              itemCount: _times.length,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getData,
        tooltip: 'getData',
        child: Icon(Icons.add),
      ),
    );
  }
}
