import 'package:go_smart_admin_windos/app/auth_branches_caclye/model/check_admin_login.dart';
import 'package:go_smart_admin_windos/app/auth_branches_caclye/services/auth_apis.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  int _loadingPercentage = 0;
  CheckAdminLogin _checkAdminLogin = CheckAdminLogin();
  // Login _loginData = Login();

  //* GETTERS

  int get loadingPercentage => _loadingPercentage;
  CheckAdminLogin get checkAdminLogin => _checkAdminLogin;
  // Login get loginData => _loginData;

  set setLoadingPercentage(int value) {
    _loadingPercentage = value;
    notifyListeners();
  }

  Future<void> checkAdminLoginCase(String email, String password) async {
    _checkAdminLogin = (await AuthApis().checkAdminLogin(email, password))!;

    notifyListeners();
  }
}
