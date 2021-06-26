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
        primarySwatch: Colors.blue,
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
              Colors.green[200],
              Colors.green[300],
            ],
          ),
          border: Border.all(
            width: 2,
            color: Colors.green,
          ),
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
        //         Colors.green[300],
        //       ],
        //     ),
        //   ),
        // ),
      ),
      body: Center(
          child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: keys
                  .map(
                    (e) => buildCellContainer(
                        padding: 16,
                        child:
                            FittedBox(fit: BoxFit.scaleDown, child: Text(e))),
                  )
                  .toList(),
            ),
          ),
          Flexible(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: values
                  .map(
                    (e) => buildCellContainer(
                        padding: 16,
                        child: Text(
                          e,
                          textAlign: TextAlign.center,
                        )),
                  )
                  .toList(),
            ),
          ),
        ],
      )
          // GridView.builder(
          //   gridDelegate:
          //       SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          //   itemBuilder: (ctx, index) {
          //     var keys = _times.keys.toList();
          //     var values = _times.values.toList();
          //     return buildCellContainer(
          //         padding: 0,
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //             buildCellContainer(
          //               child: Text(keys[index]),
          //               padding: 0,
          //             ),
          //             Expanded(
          //               child: buildCellContainer(
          //                 child: Text(values[index]),
          //                 padding: 0,
          //               ),
          //             )
          //           ],
          //         ));
          //   },
          //   itemCount: _times.length,
          // ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getData,
        tooltip: 'getData',
        child: Icon(Icons.add),
      ),
    );
  }
}
