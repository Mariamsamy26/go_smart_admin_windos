// import 'package:easy_localization/easy_localization.dart' as ez;
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_smart_admin_windos/app/auth_cycle/views/login_screen.dart';
// import 'package:go_smart_admin_windos/app/pos_cycle/services/pos_apis.dart';
// import 'package:go_smart_admin_windos/app/pos_cycle/views/home_screen.dart';
// import 'package:go_smart_admin_windos/helpers/application_dimentions.dart';
// import 'package:go_smart_admin_windos/helpers/navigation_helper.dart';
// import 'package:go_smart_admin_windos/styles/colors.dart';
// import 'package:go_smart_admin_windos/widget/buttons.dart';
// import 'package:go_smart_admin_windos/widget/unclosable_ok_dialog.dart';

// import '../../../styles/text_style.dart';

// class CloseSessionDialog extends StatefulWidget {
//   final int sessionId;
//   final String posName;
//   final String sessionName;
//   final String cashierName;
//   final double openingCash;
//   final double closingCash;
//   final String state;
//   final String startAt;
//   final String closeAt;
//   final String openingNote;
//   final String closingNote;
//   final int orderCount;
//   final double totalPaymentsAmount;
//   //*
//   final bool isAdmin;

//   const CloseSessionDialog(
//       {super.key,
//       required this.sessionId,
//       required this.posName,
//       required this.sessionName,
//       required this.cashierName,
//       required this.openingCash,
//       required this.closingCash,
//       required this.state,
//       required this.startAt,
//       required this.closeAt,
//       required this.openingNote,
//       required this.orderCount,
//       required this.totalPaymentsAmount,
//       required this.closingNote,
//       required this.isAdmin});

//   @override
//   State<CloseSessionDialog> createState() => _CloseSessionDialogState();
// }

// class _CloseSessionDialogState extends State<CloseSessionDialog> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _closingCashController = TextEditingController();
//   final TextEditingController _closingNoteController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     AppDimentions().appDimentionsInit(context);

//     return AlertDialog(
//       backgroundColor: bgColor,
//       content: Directionality(
//         textDirection: context.locale == const Locale('ar') ? TextDirection.rtl : TextDirection.ltr,
//         child: Form(
//           key: _formKey,
//           child: SizedBox(
//             width: AppDimentions().availableWidth * 0.7,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         '${'session'.tr()}: ',
//                         style: boldText,
//                       ),
//                       Text(
//                         widget.sessionName,
//                       ),
//                       const Spacer(),
//                       Container(
//                         alignment: Alignment.topLeft,
//                         child: IconButton(
//                             onPressed: () {
//                               Navigation().closeDialog(context);
//                             },
//                             icon: const Icon(Icons.close, color: Colors.black)),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20.h),
//                   Card(
//                     elevation: 3,
//                     color: white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.r),
//                     ),
//                     child: Container(
//                       padding: const EdgeInsets.all(20),
//                       width: AppDimentions().availableWidth * 0.7,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(5),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8.r),
//                                   border: Border.all(color: goSmartBlue),
//                                 ),
//                                 child: Text(
//                                   'sales_information'.tr(),
//                                   style: mediumText,
//                                 ),
//                               ),
//                               const Spacer(),
//                               Container(
//                                 alignment: Alignment.center,
//                                 //width: 80.w,
//                                 padding: const EdgeInsets.all(5),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8.r),
//                                   color: widget.state.toLowerCase() == 'closed' ? Colors.red.shade100 : Colors.green.shade100,
//                                 ),
//                                 child: Text(
//                                   widget.state,
//                                   style: mediumText.copyWith(
//                                       color: widget.state.toLowerCase() == 'closed' ? Colors.red : Colors.green),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 20.h),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Image.asset(
//                                 'assets/images/dollar_two.png',
//                                 height: 15.h,
//                                 width: 15.w,
//                               ),
//                               SizedBox(width: 20.w),
//                               Text(
//                                 '${'balance'.tr()}: ${widget.totalPaymentsAmount} ${'egp'.tr()}',
//                                 style: mediumText,
//                               ),
//                               SizedBox(width: 100.w),
//                               Image.asset(
//                                 'assets/images/orders.png',
//                                 height: 15.h,
//                                 width: 15.w,
//                               ),
//                               SizedBox(width: 20.w),
//                               Text(
//                                 '${'orders'.tr()}: ${widget.orderCount}',
//                                 style: mediumText,
//                               ),
//                             ],
//                           ),
//                           const Divider(),
//                           SizedBox(height: 20.h),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Expanded(
//                                 flex: 2,
//                                 child: ColumnDataItem(label: 'pos'.tr(), data: widget.posName),
//                               ),
//                               Expanded(
//                                 flex: 2,
//                                 child: ColumnDataItem(label: 'cashier'.tr(), data: widget.cashierName),
//                               ),
//                               Expanded(
//                                 flex: 2,
//                                 child: ColumnDataItem(
//                                     label: 'opening_date'.tr(),
//                                     data: widget.startAt.isEmpty
//                                         ? ''
//                                         : ez.DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(widget.startAt))),
//                               ),
//                               Expanded(
//                                 flex: 2,
//                                 child: ColumnDataItem(
//                                     label: 'closing_date'.tr(),
//                                     data: widget.closeAt.isEmpty
//                                         ? ''
//                                         : ez.DateFormat('dd/MM/yyyy h:m a').format(DateTime.parse(widget.closeAt))),
//                               ),
//                             ],
//                           ),
//                           const Divider(),
//                           SizedBox(height: 20.h),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Expanded(
//                                 flex: 2,
//                                 child: ColumnDataItem(label: 'opening_cash'.tr(), data: '${widget.openingCash} ${'egp'.tr()}'),
//                               ),
//                               Expanded(
//                                 flex: 2,
//                                 child:

//                                     //   ColumnDataItem(label: 'Closing Balance', data: '$closingCash EGP')
//                                     Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                       'closing_cash'.tr(),
//                                       style: mediumText.copyWith(fontSize: 16.sp, color: goSmartBlue),
//                                     ),
//                                     SizedBox(height: 10.h),
//                                     Container(
//                                       height: 50.h,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10.r),
//                                         border: Border.all(
//                                           color: Colors.grey[300]!,
//                                         ),
//                                       ),
//                                       child: TextFormField(
//                                         controller: _closingCashController,
//                                         validator: (value) {
//                                           if (value == null || value.isEmpty) {
//                                             return 'required_field'.tr();
//                                           }
//                                           if (double.tryParse(value) == null) {
//                                             return 'invalid_number'.tr();
//                                           }
//                                           return null;
//                                         },
//                                         textInputAction: TextInputAction.done,
//                                         keyboardType: TextInputType.number,
//                                         decoration: InputDecoration(
//                                           //   isDense: true,
//                                           //   hintText: 'closing_cash'.tr(),
//                                           hintStyle: mediumText.copyWith(
//                                               color: const Color(0xffA6B3BA).withOpacity(0.5), fontSize: 17.sp),
//                                           // border: textBorder,
//                                           // errorBorder: textBorder,
//                                           // enabledBorder: textBorder,
//                                           // focusedBorder: textBorder,
//                                           border: InputBorder.none,
//                                           errorBorder: InputBorder.none,
//                                           enabledBorder: InputBorder.none,
//                                           focusedBorder: InputBorder.none,
//                                           contentPadding: const EdgeInsets.symmetric(vertical: 8),
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const Divider(),
//                           SizedBox(height: 20.h),
//                           ColumnDataItem(label: 'opening_note'.tr(), data: widget.openingNote),
//                           SizedBox(height: 10.h),
//                           Text(
//                             'closing_note'.tr(),
//                             style: mediumText.copyWith(fontSize: 16.sp, color: goSmartBlue),
//                           ),
//                           SizedBox(height: 10.h),
//                           Container(
//                             height: 50.h,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10.r),
//                               border: Border.all(
//                                 color: Colors.grey[300]!,
//                               ),
//                             ),
//                             child: TextFormField(
//                               decoration: InputDecoration(
//                                 isDense: true,
//                                 hintText: 'closing_note'.tr(),
//                                 hintStyle: mediumText.copyWith(color: const Color(0xffA6B3BA).withOpacity(0.5), fontSize: 17.sp),
//                                 // border: textBorder,
//                                 // errorBorder: textBorder,
//                                 // enabledBorder: textBorder,
//                                 // focusedBorder: textBorder,
//                                 border: InputBorder.none,
//                                 errorBorder: InputBorder.none,
//                                 enabledBorder: InputBorder.none,
//                                 focusedBorder: InputBorder.none,
//                                 contentPadding: const EdgeInsets.symmetric(vertical: 8),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 20.h),
//                           Container(
//                             height: 35.h,
//                             padding: EdgeInsets.symmetric(horizontal: AppDimentions().availableWidth * 0.2),
//                             child: BlueButton(
//                                 label: 'close_shift'.tr(),
//                                 onPressed: () async {
//                                   //  Navigation().closeDialog(context);
//                                   if (_formKey.currentState!.validate()) {
//                                     //*
//                                     Navigation().showLoadingGifDialog(context);

//                                     await PosApis()
//                                         .closeSession(widget.sessionId, double.parse(_closingCashController.text),
//                                             _closingNoteController.text)
//                                         .then((value) {
//                                       if (value!.status == 1) {
//                                         showDialog(
//                                           context: context,
//                                           builder: (context) => UnClosableOkDialog(
//                                             text: value.messageAr!,
//                                             onPressed: () {
//                                               if (widget.isAdmin) {
//                                                 Navigation().closeDialog(context);
//                                                 Navigation().closeDialog(context);
//                                                 Navigation().closeDialog(context);
//                                                 Navigation().goToScreen(context, (context) => HomeScreen(isAdmin: true));
//                                               } else {
//                                                 Navigation().goToScreenAndClearAll(context, (context) => const LoginScreen());
//                                               }
//                                             },
//                                           ),
//                                         );
//                                       }
//                                     });
//                                     //*
//                                   }
//                                 }),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ColumnDataItem extends StatelessWidget {
//   final String label;
//   final String data;

//   const ColumnDataItem({super.key, required this.label, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           label,
//           style: mediumText.copyWith(fontSize: 16.sp, color: goSmartBlue),
//         ),
//         Text(
//           data,
//           style: mediumText.copyWith(fontSize: 14.sp, color: Colors.grey[700]),
//         ),
//       ],
//     );
//   }
// }
