// auth_service.dart

class AuthService {
  static Future<bool> login(String username, String password) async {

    await Future.delayed(Duration(seconds: 1)); // 模拟网络延迟
    if (username == 'admin' && password == '123') {
      return true; // 登录成功
    }
    return false; // 登录失败
  }
}
