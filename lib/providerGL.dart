import 'package:flutter/material.dart';
import 'dio_client.dart'; // 确保导入DioClient类

class UserNotifier extends ChangeNotifier {
  String? _username;
  bool _isLoading = false;
  String? _error;

  String? get username => _username;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setUsername(String? username) {
    _username = username;
    notifyListeners();
  }

  Future<void> fetchUsername() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      var username = await DioClient().getUsername();
      if (username != null) {
        _username = username;
        _isLoading = false;
        notifyListeners();
      } else {
        _error = "Failed to load username";
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error fetching username: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
}
