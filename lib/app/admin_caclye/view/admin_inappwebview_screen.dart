import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_smart_admin_windos/app/admin_caclye/view/all_pos_screens.dart';
import 'package:go_smart_admin_windos/app/auth_branches_caclye/view/login_screen.dart';
import 'package:go_smart_admin_windos/helpers/odoo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/navigation_helper.dart';
import '../../../../widget/loading_percent_dialog.dart';

class AdminWebviewScreen extends StatefulWidget {
  final String email;
  final String password;
  final String urlLink;
  final String branchNane;

  const AdminWebviewScreen({
    super.key,
    required this.email,
    required this.password,
    required this.branchNane,
    required this.urlLink,
  });

  @override
  State<AdminWebviewScreen> createState() => _AdminWebviewScreenState();
}

class _AdminWebviewScreenState extends State<AdminWebviewScreen> {
  InAppWebViewController? _controller;
  final CookieManager _cookieManager = CookieManager.instance();

  bool _isWebViewReady = false;
  bool _showingLoading = false;
  String _odooSessionId = '';
  double _progress = 0;

  FutureOr<void> _onGoBack(dynamic value) async {
    await _controller?.loadUrl(urlRequest: URLRequest(url: WebUri(widget.urlLink)));
  }

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _ensureSessionCookie() async {
    if (_odooSessionId.isEmpty) return;
    // Setting the cookie BEFORE any navigation
    await _cookieManager.setCookie(
      url: WebUri(widget.urlLink),
      domain: 'pos-c1.gosmart.eg',
      name: 'session_id',
      value: _odooSessionId,
      path: '/',
      isHttpOnly: false,
      // Do not set domain for IP if you pass url – InAppWebView will scope it correctly.
      // expiresDate: DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
      // isSecure: false, // http (not https); keep false to allow it to be accepted.
    );
  }

  Future<void> _initWebView() async {
    final odooSession = await Odoo().initOdooConnection(
      email: widget.email,
      password: widget.password,
      branch: widget.branchNane,
    );
    if (odooSession == null) return;

    _odooSessionId = odooSession.id;
    print('ODOO SESSION ID >> $_odooSessionId');

    await _ensureSessionCookie();

    setState(() {
      _isWebViewReady = true;
    });
  }

  void _maybeShowLoadingDialog() {
    if (!_showingLoading && mounted) {
      _showingLoading = true;
      showDialog(context: context, barrierDismissible: false, builder: (_) => const LoadingPercentDialog());
    }
  }

  void _maybeCloseLoadingDialog() {
    if (_showingLoading && mounted) {
      Navigation().closeDialog(context);
      _showingLoading = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _checkForPosConfig(String url) {
    return url.contains('pos.config');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isWebViewReady
          ? const Center(child: CircularProgressIndicator())
          : InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.urlLink)),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                // userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome Safari',
                useShouldOverrideUrlLoading: true,
                transparentBackground: true,
                cacheEnabled: true,
                allowsLinkPreview: false,
              ),
              onWebViewCreated: (controller) async {
                _controller = controller;
                // Re-ensure cookie at creation time (defensive)
                await _ensureSessionCookie();
              },
              shouldOverrideUrlLoading: (controller, navAction) async {
                final url = navAction.request.url?.toString() ?? '';
                print('NAV request: $url');
                if (_checkForPosConfig(url)) {
                  Navigation().goToScreenWithGoBack(context, (context) => const AllPosScreens(), _onGoBack);

                  await _controller?.loadUrl(urlRequest: URLRequest(url: WebUri(widget.urlLink)));
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              },
              onTitleChanged: (controller, title) async {
                print('Title changed: $title');
                if (title!.contains('Point of Sale')) {
                  // await _controller?.loadUrl(urlRequest: URLRequest(url: WebUri('https://pos-c1.gosmart.eg/web#action=312&model=product.template&view_type=kanban&cids=1&menu_id=191')));

                  Navigation().goToScreenWithGoBack(context, (context) => const AllPosScreens(), _onGoBack);
                }
              },
              onLoadStart: (controller, url) async {
                _maybeShowLoadingDialog();
                final u = url?.toString() ?? '';
                print('LoadStart: $u');
                // Make sure cookie exists for every top-level navigation.
                await _ensureSessionCookie();
                if (_checkForPosConfig(u)) {
                  Navigation().goToScreenWithGoBack(context, (context) => const AllPosScreens(), _onGoBack);
                }
              },
              onLoadStop: (controller, url) async {
                final u = url?.toString() ?? '';
                print('LoadStop: $u');
                _progress = 1.0;
                _maybeCloseLoadingDialog();

                // As a fallback, set cookie again and update document.cookie for the current document
                await _ensureSessionCookie();
                await controller.evaluateJavascript(
                  source:
                      """
                try {
                  document.cookie = "session_id=$_odooSessionId; path=/";
                } catch(e) {}
              """,
                );
              },
              onProgressChanged: (controller, progress) {
                // progress: 0..100
                _progress = (progress / 100.0).clamp(0.0, 1.0);
                if (_progress < 1.0) {
                  _maybeShowLoadingDialog();
                } else {
                  _maybeCloseLoadingDialog();
                }
              },
              onLoadError: (controller, url, code, message) {
                print('LoadError [$code]: $message @ ${url?.toString()}');
                _maybeCloseLoadingDialog();
              },
              onLoadHttpError: (controller, url, statusCode, description) {
                print('HTTPError [$statusCode]: $description @ ${url?.toString()}');
                _maybeCloseLoadingDialog();
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.logout),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          Navigation().goToScreenAndClearAll(context, (context) => const LoginScreen());
        },
      ),
    );
  }
}
