// auth_service.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  //登陆
  static Future<bool> login(String username, String password) async {

    await Future.delayed(Duration(seconds: 1)); // 模拟网络延迟
    if (username == 'admin' && password == '123') {
      return true; // 登录成功
    }
    return false; // 登录失败
  }
  //注册
  static Future<bool> register(String username, String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); // 模拟网络延迟

    // 这里只是一个简单的示例验证
    if (username.isNotEmpty && email.contains('@') && password.length >= 3) {
      return true; // 注册成功
    }
    return false; // 注册失败
  }
}




class User with ChangeNotifier {
  String username;
  String phone;

  User({required this.username, required this.phone});

  Future<void> fetchAndSetUser() async {
    final response = await http.get(Uri.parse('https://your-api-url.com/login'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      username = data['username'];
      phone = data['phone'];
      notifyListeners();
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
