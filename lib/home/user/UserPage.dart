import 'package:flutter/material.dart';
import 'package:cptapp/providerGL.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:cptapp/dio_client.dart';

class UserPagePage extends StatefulWidget {
  const UserPagePage({Key? key}) : super(key: key);

  @override
  _UserPagePageState createState() => _UserPagePageState();
}

class _UserPagePageState extends State<UserPagePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  DioClient _dioClient = DioClient();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserNotifier>(context, listen: false).fetchUsername();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          _buildHeader(),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 0, top: 10, bottom: 16),
            // 这里设定了所有方向的外边距为16像素
            child: Text(
              '修改你的用户信息',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          _buildUserCard(),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final username = Provider.of<UserNotifier>(context).username;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      // 设置左右边距为16.0
      child: ListTile(
        title: Text(
          'hi $username',
          style: TextStyle(fontSize: 60),
        ),
        subtitle: Text('修改信息', style: TextStyle(fontSize: 18)),
      ),
    );
  }
  Widget _buildUserCard() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: '新用户名',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入用户名';
                }
                return null;
              },
            ),
            Padding(
              padding:
              EdgeInsets.only(left: 50, right: 50, top: 20, bottom: 50),
              child: ElevatedButton(
                onPressed: _updateUsername,
                child: Text('更新用户名',style: TextStyle(fontSize: 18),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue), // 设置按钮背景色
                  foregroundColor: MaterialStateProperty.all(Colors.white), // 设置文字颜色
                  elevation: MaterialStateProperty.all(8), // 设置阴影
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0), // 设置按钮的圆角
                        side: BorderSide(color: Colors.blue), // 设置边框颜色
                      )
                  ),
                  padding: MaterialStateProperty.all(EdgeInsets.all(16)), // 设置内边距
                ),
              ),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: '旧密码',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入旧密码';
                }
                return null;
              },
            ),
            SizedBox(height: 24,),
            TextFormField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: '新密码',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入密码';
                }
                return null;
              },
            ),
            Padding(
              padding:
              EdgeInsets.only(left: 50, right: 50, top: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: _updatePassword,
                child: Text('更新密码',style: TextStyle(fontSize: 18),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue), // 设置按钮背景色
                  foregroundColor: MaterialStateProperty.all(Colors.white), // 设置文字颜色
                  elevation: MaterialStateProperty.all(8), // 设置阴影
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0), // 设置按钮的圆角
                        side: BorderSide(color: Colors.blue), // 设置边框颜色
                      )
                  ),
                  padding: MaterialStateProperty.all(EdgeInsets.all(16)), // 设置内边距
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 16),
      child: ElevatedButton.icon(
        onPressed: _logout,
        icon: Icon(Icons.exit_to_app),
        label: Text('退出登录'),
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          padding: EdgeInsets.symmetric(vertical: 12),
          textStyle: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  void _updateUsername() {
    // Here you would also handle password updating
    print('用户名已更新为: ${_usernameController.text}');
  }

  void _updatePassword() async {
      bool updated = await _dioClient.updateUserInfo(_passwordController.text,_newPasswordController.text,null);
      if (updated) {
        print('密码已更新为: ${_newPasswordController.text}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("密码更新成功！")));
      } else {
        print('更新密码失败');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("密码更新失败！")));
      }
    }

  void _logout() {
    print('用户登出');
    Navigator.of(context).pop(); // Or redirect to login screen
  }
}
