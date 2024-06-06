import 'package:flutter/material.dart';
import 'package:cptapp/providerGL.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:cptapp/services/dio_client.dart';

class UserPagePage extends StatefulWidget {
  const UserPagePage({Key? key}) : super(key: key);

  @override
  _UserPagePageState createState() => _UserPagePageState();
}

class _UserPagePageState extends State<UserPagePage> {
  int _contentMode = 0;
  final TextEditingController _newUsernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  DioClient _dioClient = DioClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildHeader(),
          SizedBox(
            height: 20,
          ),
          _buildSelect(),
          _contentMode == 0 ? _buildUserName() : _buildUserPassword(),
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

  Widget _buildSelect() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      // 横向间隔
      mainAxisSpacing: 10,
      // 纵向间隔
      childAspectRatio: 1.8,
      // 调整子元素宽高比
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      children: <Widget>[
        _buildButton('修改用户名', Icons.person, 0),
        _buildButton('修改密码', Icons.lock, 1),
      ],
    );
  }

  Widget _buildButton(String text, IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _contentMode = index;
          _clear(); // 根据索引切换模式
        });
      },
      child: Container(
        padding: EdgeInsets.all(22), // 设置内部边距
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // 设置圆角
          boxShadow: [
            // 可选，添加阴影效果
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon,
                size: 24,
                color: _contentMode == index ? Colors.blue : Colors.black),
            // 图标颜色也进行区分
            SizedBox(height: 8),
            Text(text,
                style: TextStyle(
                    fontSize: 16,
                    color: _contentMode == index ? Colors.blue : Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildUserName() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 10),
              child: TextFormField(
                controller: _newUsernameController,
                style: TextStyle(fontSize: 16),
                // 调整字体大小
                decoration: InputDecoration(
                  labelText: '你的新用户名',
                  hintText: '输入你的新用户名',
                  prefixIcon: Icon(Icons.person),
                  // 添加图标
                  filled: true,
                  // 填充颜色
                  fillColor: Colors.white,
                  // 背景填充色
                  border: OutlineInputBorder(
                    // 标准边界
                    borderRadius: BorderRadius.circular(12), // 圆角边界
                    borderSide: BorderSide.none, // 无边框
                  ),
                  focusedBorder: OutlineInputBorder(
                    // 焦点时的边界样式
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    // 未获得焦点时的边界样式
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    // 错误状态的边界样式
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    // 焦点且错误状态的边界样式
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20), // 内边距
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入你的新用户名'; // 验证信息
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 40, right: 40, top: 18, bottom: 10),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(fontSize: 16),
                // 调整字体大小
                decoration: InputDecoration(
                  labelText: '你的密码',
                  hintText: '输入你的密码',
                  prefixIcon: Icon(Icons.lock_outline),
                  // 添加图标
                  filled: true,
                  // 填充颜色
                  fillColor: Colors.white,
                  // 背景填充色
                  border: OutlineInputBorder(
                    // 标准边界
                    borderRadius: BorderRadius.circular(12), // 圆角边界
                    borderSide: BorderSide.none, // 无边框
                  ),
                  focusedBorder: OutlineInputBorder(
                    // 焦点时的边界样式
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    // 未获得焦点时的边界样式
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    // 错误状态的边界样式
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    // 焦点且错误状态的边界样式
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20), // 内边距
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入你的密码'; // 验证信息
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 45, right: 45, top: 24, bottom: 10),
              child: ElevatedButton(
                onPressed: _updateUsername,
                child: Text(
                  '修改用户名',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.blue.shade900; // 按钮被按下时的深蓝色
                      return Colors.blue; // 默认颜色
                    },
                  ),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  // 设置文字颜色
                  elevation: MaterialStateProperty.all(10),
                  // 提升的阴影效果
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // 设置按钮的圆角更圆滑
                    side: BorderSide(color: Colors.blue.shade700), // 设置边框颜色稍深
                  )),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 16, horizontal: 30)),
                  // 调整内边距
                  overlayColor: MaterialStateProperty.all(
                      Colors.blue.shade700), // 覆盖颜色，提供视觉反馈
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserPassword() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 10),
              child: TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                style: TextStyle(fontSize: 16),
                // 调整字体大小
                decoration: InputDecoration(
                  labelText: '你的新密码',
                  hintText: '输入你的新密码',
                  prefixIcon: Icon(Icons.lock_outline),
                  // 添加图标
                  filled: true,
                  // 填充颜色
                  fillColor: Colors.white,
                  // 背景填充色
                  border: OutlineInputBorder(
                    // 标准边界
                    borderRadius: BorderRadius.circular(12), // 圆角边界
                    borderSide: BorderSide.none, // 无边框
                  ),
                  focusedBorder: OutlineInputBorder(
                    // 焦点时的边界样式
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    // 未获得焦点时的边界样式
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    // 错误状态的边界样式
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    // 焦点且错误状态的边界样式
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20), // 内边距
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入你的新密码'; // 验证信息
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 40, right: 40, top: 18, bottom: 10),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(fontSize: 16),
                // 调整字体大小
                decoration: InputDecoration(
                  labelText: '你的密码',
                  hintText: '输入你的密码',
                  prefixIcon: Icon(Icons.lock_outline),
                  // 添加图标
                  filled: true,
                  // 填充颜色
                  fillColor: Colors.white,
                  // 背景填充色
                  border: OutlineInputBorder(
                    // 标准边界
                    borderRadius: BorderRadius.circular(12), // 圆角边界
                    borderSide: BorderSide.none, // 无边框
                  ),
                  focusedBorder: OutlineInputBorder(
                    // 焦点时的边界样式
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    // 未获得焦点时的边界样式
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    // 错误状态的边界样式
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    // 焦点且错误状态的边界样式
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20), // 内边距
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入你的密码'; // 验证信息
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 45, right: 45, top: 24, bottom: 10),
              child: ElevatedButton(
                onPressed: _updatePassword,
                child: Text(
                  '修改密码',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.blue.shade900; // 按钮被按下时的深蓝色
                      return Colors.blue; // 默认颜色
                    },
                  ),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  // 设置文字颜色
                  elevation: MaterialStateProperty.all(10),
                  // 提升的阴影效果
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // 设置按钮的圆角更圆滑
                    side: BorderSide(color: Colors.blue.shade700), // 设置边框颜色稍深
                  )),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 16, horizontal: 30)),
                  // 调整内边距
                  overlayColor: MaterialStateProperty.all(
                      Colors.blue.shade700), // 覆盖颜色，提供视觉反馈
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 62, vertical: 10), // 如果需要边距
      child: ElevatedButton.icon(
        onPressed: _logout,
        icon: Icon(Icons.exit_to_app, size: 24),
        label: Text('退出登录',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return Colors.red.shade900; // 按钮被按下时的深蓝色
              return Colors.red; // 默认颜色
            },
          ),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          // 设置文字颜色
          elevation: MaterialStateProperty.all(10),
          // 提升的阴影效果
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // 设置按钮的圆角更圆滑
            side: BorderSide(color: Colors.red.shade700), // 设置边框颜色稍深
          )),
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: 16, horizontal: 30)),
          // 调整内边距
          overlayColor:
              MaterialStateProperty.all(Colors.red.shade700), // 覆盖颜色，提供视觉反馈
        ),
      ),
    );
  }

  void _updateUsername() async {
    if (_newUsernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请输入新用户名')),
      );
      return;
    }
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请输入密码')),
      );
      return;
    }
    try{
      bool updated = await _dioClient.updateUserInfo(
          _passwordController.text, null, _newUsernameController.text);
      if (updated) {
        print('用户名已更新为: ${_newUsernameController.text}');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("用户名更新成功！")));
        Provider.of<UserNotifier>(context, listen: false)
            .setUsername(_newUsernameController.text);
        _clear();
      } else {
        print('更新用户名失败');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("用户名更新失败！")));
      }
    }catch (e) {
      // 处理异常
      print('更新过程中发生异常: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('更新过程中发生异常')),
      );
    }
  }

  void _updatePassword() async {
    if (_newPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请输入新密码')),
      );
      return;
    }
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请输入密码')),
      );
      return;
    }
    try{
      bool updated = await _dioClient.updateUserInfo(
          _passwordController.text, _newPasswordController.text, null);
      if (updated) {
        print('密码已更新为: ${_newPasswordController.text}');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("密码更新成功！")));
        _clear();
      } else {
        print('更新密码失败');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("密码更新失败！")));
      }
    }catch (e) {
      // 处理异常
      print('更新过程中发生异常: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('更新过程中发生异常')),
      );
    }
  }

  void _logout() {
    print('用户登出');
    Navigator.of(context).pop(); // Or redirect to login screen
  }

  void _clear() {
    _newUsernameController.clear();
    _passwordController.clear();
    _newPasswordController.clear();
  }
}
