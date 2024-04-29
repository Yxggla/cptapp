import 'package:flutter/material.dart';
import 'sign/SignInPage.dart';
import 'sign/SignUpPage.dart';

class SecondPage extends StatelessWidget {
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
            Spacer(flex: 6), // 使用Spacer来分配空间
            Image.asset("img/MyHomePage/logo1@3x.png", width: 130),
            Text(
              '财票通', // 你的首页标题或者其他文本
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold),
            ),
            Spacer(flex: 5), // 调整空间分配
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          SignInPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
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
                    ));
              },
              child: Text('登录',style: TextStyle(fontSize: 20),),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // 设置按钮背景颜色
                onPrimary: Colors.white, // 设置按钮文本颜色
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                minimumSize: Size(180, 50), // 设置按钮的大小
              ),
            ),
            SizedBox(height: 20), // 添加按钮之间的间隔
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          SignUpPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
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
                    ));
              },
              child: Text('注册',style: TextStyle(fontSize: 20),),
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // 设置按钮背景颜色
                onPrimary: Colors.blue, // 设置按钮文本颜色
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: Colors.blue), // 设置边框颜色
                ),
                minimumSize: Size(180, 50), // 设置按钮的大小
              ),
            ),
            SizedBox(height: 20), // 添加额外的间隔
            Spacer(flex: 3), // 使用Spacer来分配空间
          ],
        ),
      ),
    ]));
  }

  Widget _buildTextInput(String hintText) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50), // 水平边距
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTextButton(String text) {
    return TextButton(
      onPressed: () {
        // 在这里添加你按钮的功能，例如页面跳转等
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
