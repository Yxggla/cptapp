import 'package:flutter/material.dart';

/**
 * @author[dongbaba]
 * @version[创建日期，2024/5/11 11:37]
 * @function[功能简介 ]
 **/
class ysgl_main_adminPage extends StatefulWidget {
  const ysgl_main_adminPage({Key? key}) : super(key: key);

  @override
  _ysgl_main_adminPageState createState() => _ysgl_main_adminPageState();
}

class _ysgl_main_adminPageState extends State<ysgl_main_adminPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ysgl_main_admin"),
        ),
        body: Center(
          child: Column(),
        ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
