import 'package:go_smart_admin_windos/app/admin_caclye/view/all_sessions_screen.dart';
import 'package:go_smart_admin_windos/app/admin_caclye/provider/pos_provider.dart';
import 'package:go_smart_admin_windos/styles/colors.dart';

import 'package:provider/provider.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_smart_admin_windos/helpers/navigation_helper.dart';
import 'package:go_smart_admin_windos/styles/text_style.dart';

class PosItemWidget extends StatelessWidget {
  final int id;
  final String name;
  final bool isActive;
  final bool hasActiveSession;
  final String currentSession;
  final int currentSessionId;
  final String lastSessionClosingDate;
  final double lastSessionClosingCash;
  final String lastSessionUsername;
  final String lastSessionState;
  final String lastSessionDuration;

  const PosItemWidget({
    super.key,
    required this.id,
    required this.name,
    required this.isActive,
    required this.hasActiveSession,
    required this.currentSession,
    required this.currentSessionId,
    required this.lastSessionClosingDate,
    required this.lastSessionClosingCash,
    required this.lastSessionUsername,
    required this.lastSessionState,
    required this.lastSessionDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
        side: const BorderSide(color: Color(0xffFFDFBD)),
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          // border: Border.all(
          //   color: const Color(0xffFFDFBD),
          // ),
          gradient: const LinearGradient(
            colors: [Color(0xffFEF2E7), Color(0xffFBFBFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: Text(name, textAlign: TextAlign.center, maxLines: 2, style: mediumText),
                ),
                // const Spacer(),
                GestureDetector(
                  onTap: () async {
                    Navigation().showLoadingGifDialog(context);
                    //*
                    await context.read<PosProvider>().getPosSessions(id);
                    //*
                    Navigation().closeDialog(context);
                    //*

                    Navigation().goToScreen(context, (context) => AllSessionsScreen());
                  },
                  child: const Icon(Icons.info, color: goSmartBlue),
                ),
              ],
            ),
            const Divider(color: Color(0xffFFDFBD)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 30.h,
                  width: 30.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: hasActiveSession ? Colors.green.shade100 : Colors.red.shade100,
                  ),
                  child: Text(
                    lastSessionUsername.isEmpty ? '' : lastSessionUsername[0],
                    textAlign: TextAlign.center,
                    style: mediumText.copyWith(color: Colors.green),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('balance'.tr(), style: mediumText),
                const Spacer(),
                Text('$lastSessionClosingCash ${'egp'.tr()}', style: mediumText.copyWith(color: Colors.grey[700])),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('closing_date'.tr(), style: mediumText),
                const Spacer(),
                Text(
                  lastSessionClosingDate.isEmpty ? '' : DateFormat('dd/MM/yyyy').format(DateTime.parse(lastSessionClosingDate)),
                  style: mediumText.copyWith(color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('current_session'.tr(), style: mediumText),
                const Spacer(),
                Text(currentSession, style: mediumText.copyWith(color: Colors.grey[700])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
