import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:new_app/constants.dart';
import 'package:new_app/timings_table.dart';
import 'package:intl/intl.dart';

import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              // bodyColor: Color(0xFF3f16c3),
              bodyColor: Colors.teal[900],

              displayColor: Color(0xFF1a01b9),
            ),
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Prayer Timings'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  final audioPlayer = AudioPlayer();

  static AudioCache player;

  var _timeings = {};

  String convertToPmAm(String time) {
    return DateFormat.jm().format(DateFormat('hh:mm').parse(time));
  }

  Future<void> _getData() async {
    var parameters = {
      'city': 'Jeddah',
      'country': 'KSA',
      // 'state': 'makkah',
      'method': jsonEncode(4),
      'midnightMode': jsonEncode(1),
    };
    var url = Uri.https('api.aladhan.com',
        '/v1/timingsByCity/:date_or_timeingstamp', parameters);

    return await http.get(url);

    // _timeings = jsonDecode(response.body)['data']['timings'] as Map;

    // setState(() {});
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

  Future<void> _triggerAt(String time) {
    var now = DateFormat('h:mm a').format(DateTime.now());
    var timing = DateFormat.jm().format(DateFormat('hh:mm').parse('21:19'));

    print(now);
    print(timing);
    print(timing == now);
    player.play('azan1.mp3');

    if (timing == now) {}
  }

  @override
  Widget build(BuildContext context) {
// in your State
    player = new AudioCache(fixedPlayer: audioPlayer);

    var keys = _timeings.keys.toList();
    var values = _timeings.values.toList();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline5,
        ),
        actions: [
          IconButton(
              onPressed: () {
                audioPlayer.stop();
              },
              icon: Icon(Icons.stop))
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: primaryGradient),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: secondaryGradient),
          ),
          FutureBuilder(
              future: _getData(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  _timeings =
                      jsonDecode(snapshot.data.body)['data']['timings'] as Map;
                  return SizedBox.expand(
                    child: LayoutBuilder(
                      builder: (ctx, constraints) {
                        var biggest = constraints.biggest;

                        return TimingsTable(
                            buildListOfDataRaw: _buildListOfDataRaw,
                            size: biggest,
                            timingsLength: _timeings.length);
                      },
                    ),
                  );
                }
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _triggerAt('08:01');
        },
        tooltip: 'getData',
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: primaryGradient,
          ),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  List<DataRow> _buildListOfDataRaw(BuildContext context) {
    return List.generate(_timeings.length, (index) {
      var keys = _timeings.keys.toList();
      var values = _timeings.values.toList();
      return DataRow(
        cells: [
          DataCell(
            Text(
              keys[index],
              style:
                  Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 27),
            ),
          ),
          DataCell(
            Text(
              convertToPmAm(
                values[index],
              ),
              style:
                  Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 27),
            ),
          ),
        ],
      );
    });
  }

  Container _buildOldTeable() {
    return Container(
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
              var keys = _timeings.keys.toList();
              var values = _timeings.values.toList();
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
            itemCount: _timeings.length,
          ),
        ),
      ),
    );
  }
}
