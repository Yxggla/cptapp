import 'package:flutter/material.dart';
import 'package:cptapp/SecondPage.dart'; // 确保这个路径匹配你的文件结构

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => SecondPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var curve = Curves.easeIn;
            var curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return FadeTransition(
              opacity: curvedAnimation, // 使用CurvedAnimation来应用曲线效果
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Positioned.fill(
          child: Transform.scale(
            scale: 1.1,
            child: Image.asset(
              "img/MyHomePage/BackGround@3x.png", // 用你的背景图路径替换此处
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(flex: 4), // 使用Spacer来分配空间
              Image.asset("img/MyHomePage/logo1@3x.png", width: 130),
              Spacer(
                flex: 3,
              ), // 使用Spacer来分配空间
              Text(
                '财票通', // 你的首页标题或者其他文本
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(flex: 3), // 使用Spacer来分配空间
            ],
          ),
        ),
      ]),
    );
  }
}
