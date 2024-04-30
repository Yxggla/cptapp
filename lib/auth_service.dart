// auth_service.dart

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
