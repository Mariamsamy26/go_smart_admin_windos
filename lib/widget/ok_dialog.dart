import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_smart_admin_windos/helpers/navigation_helper.dart';
import 'package:go_smart_admin_windos/styles/colors.dart';
import 'package:go_smart_admin_windos/styles/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

class OkDialog extends StatelessWidget {
  final String text;

  const OkDialog({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(text, textAlign: TextAlign.center, style: mediumText.copyWith(fontSize: 18)),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.h),
          TextButton(
            style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(goSmartBlue),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            ),
            onPressed: () {
              Navigation().closeDialog(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                'ok'.tr(),
                textAlign: TextAlign.center,
                style: mediumText.copyWith(color: white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
