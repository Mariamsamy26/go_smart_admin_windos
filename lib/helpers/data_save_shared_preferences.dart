import 'dart:convert';
import 'package:go_smart_admin_windos/app/auth_branches_caclye/model/check_admin_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataSaveSharedPreferences {
  String savedEmail = '';
  String password = '';
  String accountType = '';
  List<Branch> savedBranches = [];

  /// Load data from SharedPreferences
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    savedEmail = prefs.getString('saved_email') ?? '';
    password = prefs.getString('password') ?? '';
    accountType = prefs.getString('account_Type') ?? '';

    final branchesJson = prefs.getString('branches');
    if (branchesJson != null && branchesJson.isNotEmpty) {
      final List decoded = jsonDecode(branchesJson) as List;
      savedBranches = decoded.map((e) => Branch.fromJson(e as Map<String, dynamic>)).toList();
    }
  }

  /// Save data into SharedPreferences
  Future<void> saveData({
    required String email,
    required String pass,
    required String type,
    required List<Branch> branches,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('saved_email', email);
    await prefs.setString('password', pass);
    await prefs.setString('account_Type', type);
    await prefs.setString('branches', jsonEncode(branches.map((e) => e.toJson()).toList()));
  }

  /// Clear saved data
  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
