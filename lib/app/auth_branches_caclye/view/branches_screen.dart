import 'package:go_smart_admin_windos/app/admin_caclye/services/pos_apis.dart';
import 'package:go_smart_admin_windos/app/admin_caclye/view/admin_inappwebview_screen.dart';
import 'package:go_smart_admin_windos/helpers/navigation_helper.dart';
import 'package:go_smart_admin_windos/app/auth_branches_caclye/view/login_screen.dart';
import 'package:go_smart_admin_windos/app/auth_branches_caclye/model/check_admin_login.dart';
import 'package:go_smart_admin_windos/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BranchesScreen extends StatefulWidget {
  final String accountType;
  final String email;
  final String password;
  final List<Branch> branches;

  const BranchesScreen({
    super.key,
    required this.email,
    required this.password,
    required this.branches,
    required this.accountType,
  });

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  late List<Branch> _filtered;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = List<Branch>.from(widget.branches);
    _searchCtrl.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_applyFilter);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _applyFilter() {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => _filtered = List<Branch>.from(widget.branches));
      return;
    }
    setState(() {
      _filtered = widget.branches.where((b) {
        final name = (b.businessName!).toLowerCase();
        final area = (b.branchArea)!.toLowerCase();
        return name.contains(q) || area.contains(q);
      }).toList();
    });
  }

  String _domain(String url) {
    try {
      final u = Uri.parse(url);
      return u.host.isNotEmpty ? u.host : url;
    } catch (_) {
      return url;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الفروع',
          style: TextStyle(color: white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: goSmartBlue,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (!mounted) return;
              Navigation().goToScreenAndClearAll(context, (c) => const LoginScreen());
            },
            icon: const Icon(Icons.logout_outlined, color: white),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset("assets/images/Go_Smart-outout.png", fit: BoxFit.contain),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'ابحث عن الفرع',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: theme.colorScheme.surface.withOpacity(0.4),
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
          ),

          // List
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Text('لم يتم العثور على  الفرع', style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                      mainAxisExtent: 0.2.sh,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final branch = _filtered[index];
                      final name = branch.branchArea!;
                      final url = branch.odooUrl!;

                      return InkWell(
                        onTap: () {
                          PosApis().getLinkUrlBranch(dbName: branch.dbName!);
                          Navigation().goToScreen(
                            context,
                            (c) => AdminWebviewScreen(
                              email: widget.email,
                              password: widget.password,
                              urlLink: url,
                              branchNane: branch.dbName!,
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: _BranchAvatar(imageUrl: branch.image!),
                            ),
                            const SizedBox(height: 6),
                            Text(name, maxLines: 2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _BranchAvatar extends StatelessWidget {
  final String imageUrl;
  const _BranchAvatar({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final hasNet = imageUrl.trim().isNotEmpty && (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));

    return SizedBox(
      width: 75.w,
      height: 80.h,
      child: hasNet
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Image.asset("assets/images/icon_ice_cream.jpeg", fit: BoxFit.cover);
              },
            )
          : Image.asset("assets/images/icon_ice_cream.jpeg", fit: BoxFit.cover),
    );
  }
}
