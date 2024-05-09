import 'package:flutter/material.dart';
import 'package:cptapp/sign/SignUpPage.dart';
import 'package:cptapp/auth_service.dart';
import 'package:cptapp/home/HomeCwgl.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Transform.scale(
              scale: 1.1,
              child: Image.asset(
                "img/MyHomePage/BackGround@3x.png", // 用你的背景图路径替换此处
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 20.0),
                child: Text(
                  '登陆',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(flex: 2),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 20.0),
                child: Text(
                  '邮箱或用户名',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: emailController,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: '输入你的邮箱或手机号',
                      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 20.0),
                child: Text(
                  '密码',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: '请输入密码',
                      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(flex: 2),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    bool isLoggedIn = await AuthService.login(
                      emailController.text,
                      passwordController.text,
                    );
                    if (isLoggedIn) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(username: emailController.text)));
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('登录失败'),
                          content: Text('用户名或密码错误'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('关闭'),
                              style: TextButton.styleFrom(
                                primary: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Text(
                    '登陆',
                    style: TextStyle(
                      fontSize: 18, // 字体大小
                      fontWeight: FontWeight.bold, // 字体粗细
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // 按钮背景颜色
                    onPrimary: Colors.white, // 按钮文字颜色
                    elevation: 5, // 阴影高度
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 18), // 按钮内边距
                    shape: RoundedRectangleBorder( // 形状
                      borderRadius: BorderRadius.circular(15), // 圆角边框
                    ),
                    side: BorderSide(color: Colors.white, width: 1), // 边框颜色和宽度
                  ),

                ),
              ),
              Spacer(flex: 1),
              Center(
                child: TextButton(
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
                              opacity: curvedAnimation,
                              child: child,
                            );
                          },
                        ));
                  },
                  child: Text(
                    "还没有账号？   注册",
                    style: TextStyle(color: Colors.white,fontSize: 16),
                  ),
                ),
              ),
              Spacer(flex: 5),
            ],
          ),
        ],
      ),
    );
  }
}
