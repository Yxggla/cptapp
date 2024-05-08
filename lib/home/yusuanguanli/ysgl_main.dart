import 'package:flutter/material.dart';

/**
 * @author[dongbaba]
 * @version[创建日期，2024/5/8 15:31]
 * @function[功能简介 ]
 **/
class ysgl_mainPage extends StatefulWidget {
  const ysgl_mainPage({Key? key}) : super(key: key);

  @override
  _ysgl_mainPageState createState() => _ysgl_mainPageState();
}

class _ysgl_mainPageState extends State<ysgl_mainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ysgl_main"),
        ),
        body: Center(
          child: Column(),
        ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
