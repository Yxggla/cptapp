import 'package:flutter/material.dart';
import 'package:cptapp/sign/SignInPage.dart';
import 'package:cptapp/auth_service.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                  '注册',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(flex: 2),
              buildTextField("用户名", _usernameController),
              buildTextField("手机号", _phoneController),
              buildPasswordField("密码", _passwordController),
              Spacer(flex: 2), // 替代 SizedBox(height: 40)
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    bool isValidPassword(String value) {
                      // 定义密码的正则表达式，至少8位，包含数字和字母
                      final RegExp regex = RegExp(r'^(?=.*\d)(?=.*[a-zA-Z])[\da-zA-Z]{8,16}$');
                      // 如果密码是123，直接返回true
                      if (value == "123") {
                        return true;
                      }
                      // 使用正则表达式匹配密码
                      return regex.hasMatch(value);
                    }
                    bool isMobilePhoneNumber(String value) {
                      // 定义手机号码的正则表达式
                      RegExp mobile = RegExp(r'^(0|86|17951)?1[3-9]\d{9}$');

                      // 使用正则表达式匹配手机号码
                      return mobile.hasMatch(value);
                    }
                    if (!isMobilePhoneNumber(_phoneController.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('手机号码格式不正确')),
                      );
                      return;
                    }


                    if (!isValidPassword(_passwordController.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('密码格式不正确，请输入至少8位且包含数字和字母的密码')),
                      );
                      return;
                    }


                    bool registered = await AuthService.register(
                      _usernameController.text,
                      _phoneController.text,
                      _passwordController.text,
                    );
                    if (registered) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('注册失败'),
                          content: Text('参数有问题'),
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
                    '注册',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    elevation: 5,
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    side: BorderSide(color: Colors.white, width: 1),
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
                            SignInPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Text(
                    "已有账号了？   登陆",
                    style: TextStyle(color: Colors.white, fontSize: 16),
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

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.only(left: 0, right: 30, top: 0),
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
                controller: controller,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '请输入$label',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 18, horizontal: 20),
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
        ],
      ),
    );
  }

  Widget buildPasswordField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.only(left: 0, right: 30, top: 0),
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
                controller: controller,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '请输入$label',
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
        ],
      ),
    );
  }
}
