import 'package:dio/dio.dart';
import 'savelingpai.dart';  // 导入令牌保存和获取的类
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://121.43.138.158:8080/api/v1',
    connectTimeout: 5000,  // 连接服务器超时时间，单位是毫秒.
    receiveTimeout: 3000,  // 接收数据的最长时限，单位是毫秒.
  ));

  DioClient() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await TokenStorage.getToken(); // 从存储中获取令牌
        if (token != null) {
          options.headers["token"] = token; // 将令牌加入请求头
          print("myToken: $token");
        } else {
          print("No token found, please login.");
        }
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        // 检查是否为登录请求并处理令牌
        if (response.requestOptions.path.endsWith("/user/login")&& response.statusCode == 200) {
          var token = response.data['data'];  // 假设令牌在data字段
          if (token != null) {
            await TokenStorage.saveToken(token);
            // 打印令牌
            print("Received token: $token");
          }
        }
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        // 更细粒度的错误处理
        if (e.response?.statusCode == 401) {
          // 处理401错误，例如令牌过期
          print("Error: Token expired or unauthorized");
        }
        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;


  //获取用户名
  Future<String?> getUsername() async {
    try {
      var response = await _dio.get('/user/get'); //
      print("HTTP Status Code: ${response.statusCode}"); // 打印状态码
      print("Response data: ${response.data}"); // 打印响应体内容
      if (response.statusCode == 200) {
        var username = response.data['data']['username']; // 假设用户名存储在响应的 'username' 字段
        print("Username extracted: $username"); // 打印提取的用户名
        return username;
      }
      return null;
    } catch (e) {
      print('获取用户名异常: $e');
      return null;
    }
  }

  //修改用户信息
  Future<bool> updateUserInfo(String password, String? newPassword, String? newUsername) async {
    var formData = FormData.fromMap({
      'password': password,
      // 只有当参数非空时才添加到表单数据中
      if (newPassword != null) 'newPassword': newPassword,
      if (newUsername != null) 'newUsername': newUsername,
    });

    try {
      var response = await _dio.post('/user/update', data: formData);
      if (response.statusCode == 200) {
        print('用户信息更新成功');
        return true;
      } else {
        print('更新用户信息失败: ${response.data}');
        return false;
      }
    } catch (e) {
      print('更新用户信息异常: $e');
      return false;
    }
  }


}

