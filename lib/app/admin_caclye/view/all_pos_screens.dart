import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_smart_admin_windos/app/admin_caclye/pos_item_widget.dart';
import 'package:go_smart_admin_windos/app/admin_caclye/provider/pos_provider.dart';
import 'package:go_smart_admin_windos/helpers/application_dimentions.dart';
import 'package:go_smart_admin_windos/styles/text_style.dart';
import 'package:provider/provider.dart';

import '../../../../styles/colors.dart';

class AllPosScreens extends StatefulWidget {
  const AllPosScreens({super.key});

  @override
  State<AllPosScreens> createState() => _AllPosScreensState();
}

class _AllPosScreensState extends State<AllPosScreens> {
  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<PosProvider>().getAllPos();

      dataLoaded = true;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    AppDimentions().appDimentionsInit(context);

    final posProviderWatch = context.watch<PosProvider>();
    final posProviderRead = context.read<PosProvider>();

    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SizedBox(
          height: AppDimentions().availableheightWithAppBar,
          width: AppDimentions().availableWidth,
          child: dataLoaded
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10.h),

                    SizedBox(
                      height: AppDimentions().availableheightNoAppBar * 0.09,
                      child: Directionality(
                        textDirection: context.locale.languageCode == 'ar' ? TextDirection.ltr : TextDirection.ltr,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(width: 30.w),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Image.asset('assets/images/grid.png', color: Colors.grey[500], height: 25.h, width: 25.w),
                            ),

                            Spacer(),
                            Text('GO Smart ', style: mediumText),
                            Text('POS', style: mediumText.copyWith(color: goSmartBlue)),
                            //*
                            SizedBox(width: 10.w),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset('assets/images/gg.png', height: 50.h, width: 50.w),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //* //*
                    SizedBox(height: 5.h),
                    const Divider(indent: 20, endIndent: 20),
                    SizedBox(height: 5.h),
                    //* //*
                    //* START OF POS TREE
                    Expanded(
                      child: Directionality(
                        textDirection: context.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('pos'.tr(), style: boldText),
                              SizedBox(height: 10.h),
                              // Expanded(
                              //   child: GridView(
                              //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              //         crossAxisCount: 4, childAspectRatio: 1.1, mainAxisSpacing: 30),
                              //     children: const [
                              //       PosItemWidget(),
                              //       PosItemWidgetTwo(),
                              //       PosItemWidget(),
                              //       PosItemWidgetTwo(),
                              //     ],
                              //   ),
                              // ),
                              Expanded(
                                child: GridView.builder(
                                  itemCount: posProviderWatch.allPos.data!.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 1.4.w,
                                    mainAxisSpacing: 30.w,
                                  ),
                                  itemBuilder: (context, index) {
                                    return PosItemWidget(
                                      key: ValueKey(posProviderWatch.allPos.data![index].id),
                                      id: posProviderWatch.allPos.data![index].id!,
                                      name: posProviderWatch.allPos.data![index].name!,
                                      currentSession: posProviderWatch.allPos.data![index].currentSession!,
                                      currentSessionId: posProviderWatch.allPos.data![index].currentSessionId!,
                                      hasActiveSession: posProviderWatch.allPos.data![index].hasActiveSession!,
                                      isActive: posProviderWatch.allPos.data![index].active!,
                                      lastSessionClosingCash: posProviderWatch.allPos.data![index].lastSessionClosingCash!,
                                      lastSessionClosingDate: posProviderWatch.allPos.data![index].lastSessionClosingDate!,
                                      lastSessionDuration: posProviderWatch.allPos.data![index].lastSessionDuration!,
                                      lastSessionState: posProviderWatch.allPos.data![index].lastSessionState!,
                                      lastSessionUsername: posProviderWatch.allPos.data![index].lastSessionUsername!,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator(color: goSmartBlue)),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     showDialog(context: context, builder: (context) => const AddNewPosSessionDialog());
        //   },
        //   backgroundColor: goSmartBlue,
        //   child: const Icon(
        //     Icons.add,
        //     size: 30,
        //   ),
        // ),
      ),
    );
  }
}
