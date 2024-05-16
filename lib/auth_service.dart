// auth_service.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'savelingpai.dart';
import 'services/dio_client.dart';
import 'package:dio/dio.dart';

class AuthService {
  //登陆
  static Future<bool> login(String phone, String password) async {
    DioClient dioClient = DioClient();
    var url = '/user/login';
    var formData = FormData.fromMap({
      'phone': phone,
      'password': password,
    });
    print("Request URL: ${dioClient.dio.options.baseUrl}$url");

    try {
      var response = await dioClient.dio.post(url, data: formData);
      if (response.statusCode == 200) {
        var data = response.data;
        return data['success'];
      } else {
        print('登录失败: ${response.data}');
        return false;
      }
    } catch (e) {
      print('登录异常: $e');
      return false;
    }
  }


  //注册
  static Future<bool> register(String username, String phone, String password) async {
    var url = Uri.parse('http://121.43.138.158:8080/api/v1/user/register');
    try {
      var response = await http.post(url, body: {
        'username': username,
        'password': password,
        'phone': phone,
      });
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['success']; // 假设成功标识为'success'
      } else {
        print('注册失败: ${response.body}');
        return false;
      }
    } catch (e) {
      print('注册错误: $e');
      return false;
    }
  }

}




