import 'package:flutter/material.dart';

/**
 * @author[dongbaba]
 * @version[创建日期，2024/5/8 15:36]
 * @function[功能简介 ]
 **/
class bbsc_mainPage extends StatefulWidget {
  const bbsc_mainPage({Key? key}) : super(key: key);

  @override
  _bbsc_mainPageState createState() => _bbsc_mainPageState();
}

class _bbsc_mainPageState extends State<bbsc_mainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("bbsc_main"),
        ),
        body: Center(
          child: Column(),
        ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
