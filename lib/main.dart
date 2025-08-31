import 'dart:convert';
import 'package:go_smart_admin_windos/app/admin_caclye/provider/pos_provider.dart';
import 'package:go_smart_admin_windos/app/auth_branches_caclye/view/branches_screen.dart';
import 'package:go_smart_admin_windos/app/auth_branches_caclye/view/login_screen.dart';
import 'package:go_smart_admin_windos/app/auth_branches_caclye/model/check_admin_login.dart';
import 'package:go_smart_admin_windos/app/auth_branches_caclye/providers/auth_provider.dart';
import 'package:go_smart_admin_windos/styles/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(title: "GO Smart Admin");
  final prefs = await SharedPreferences.getInstance();
  final savedEmail = prefs.getString('saved_email') ?? '';
  final password = prefs.getString('password') ?? '';
  final accountType = prefs.getString('account_Type') ?? '';
  final branchesJson = prefs.getString('branches');

  List<Branch> savedBranches = [];

  if (branchesJson != null && branchesJson.isNotEmpty) {
    final List decoded = jsonDecode(branchesJson) as List;
    savedBranches = decoded.map((e) => Branch.fromJson(e as Map<String, dynamic>)).toList();
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', ''), Locale('ar', '')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', ''),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => PosProvider()),
        ],
        child: MyApp(savedEmail: savedEmail, password: password, branchesList: savedBranches, accountType: accountType),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String accountType;
  final String savedEmail;
  final String password;
  final List<Branch> branchesList;

  const MyApp({
    super.key,
    required this.savedEmail,
    required this.password,
    required this.branchesList,
    required this.accountType,
  });

  @override
  Widget build(BuildContext context) {
    context.setLocale(Locale('ar'));
    return ScreenUtilInit(
      designSize: const Size(1280, 740),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
          theme: ThemeData(
            useMaterial3: false,
            fontFamily: context.locale == const Locale('ar') ? 'Tajawal' : GoogleFonts.roboto().fontFamily,
            colorScheme: ColorScheme.fromSeed(seedColor: goSmartBlue, primary: goSmartBlue, secondary: goSmartBlue),
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: black),
              centerTitle: true,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 1,
            ),
          ),
          home: child,
        );
      },
      // child:NestleScreen()
      child: (savedEmail.isNotEmpty && password.isNotEmpty)
          ? BranchesScreen(email: savedEmail, password: password, branches: branchesList, accountType: accountType)
          : const LoginScreen(),
    );
  }
}
