import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_smart_admin_windos/app/admin_caclye/models/all_pos.dart';
import 'package:go_smart_admin_windos/app/admin_caclye/models/all_kiosk_orders.dart' as allkiosk;
import 'package:go_smart_admin_windos/app/admin_caclye/models/all_session_orders.dart' as allsessionorders;
import 'package:go_smart_admin_windos/app/admin_caclye/models/all_users.dart' as du;
import 'package:go_smart_admin_windos/app/admin_caclye/models/current_session.dart';
import 'package:go_smart_admin_windos/app/admin_caclye/models/pos_sessions.dart' as ps;
import 'package:go_smart_admin_windos/app/admin_caclye/services/pos_apis.dart';
import 'package:go_smart_admin_windos/app/auth_branches_caclye/model/login_model.dart';

// import 'package:gosmart_pos/app/pos_cycle/models/search_by_receipt.dart' as refundorder;

class PosProvider with ChangeNotifier {
  final bool _connectState = true;

  int _loadingPercentage = 0;

  AllPos _allPos = AllPos();
  Login _loginData = Login();

  Login get loginData => _loginData;
  //* FOR REFUND
  // refundorder.Datum _refundOrderDetails = refundorder.Datum();

  int _customerId = 0;
  int get customerId => _customerId;
  set setCustomerId(int value) {
    _customerId = value;
    notifyListeners();
  }

  int _adminId = 0;
  int get adminId => _adminId;
  set setAdminId(int value) {
    _adminId = value;
    notifyListeners();
  }

  List<allsessionorders.Datum> _allOrdersSearchResults = [];
  List<allsessionorders.Datum> get allOrdersSearchResults => _allOrdersSearchResults;

  set setLoginData(Login value) {
    _loginData = value;
    notifyListeners();
  }
  // refundorder.Datum get refundOrderDetails => _refundOrderDetails;

  // set setRefundOrderDetails(refundorder.Datum value) {
  //   _refundOrderDetails = value;
  //   notifyListeners();
  // }

  //   Future<void> refundOrder(int adminId, int orderId, int posId, bool currentPosActiveSessionState, int currentPosActiveSessionId,
  //       BuildContext context) async {
  //     //* FIRST CHECK FOR ACTIVE SESSION
  //     if (currentPosActiveSessionState == false) {
  //       print('SESSION CLOSED REFUND');
  //       //* CLOSED THEN OPEN SESSION > REFUND > CLOSE SESSION

  //       await PosApis().openNewPosSession(posId, adminId, currencyId, 0.0, 'refund').then((openSession) async {
  //         if (openSession!.status == 1) {
  // //*
  //           await PosApis().draftRefundOrderFirst(orderId).then((first) async {
  //             if (first!.status == 1) {
  //               await PosApis().refundOrderPaymentSecond(posId, openSession.sessionId!, first.refundOrderId!).then((second) async {
  //                 if (second!.status == 1) {
  //                   await PosApis()
  //                       .reverseRefundOrderInvoiceThird(posId, openSession.sessionId!, first.refundOrderId!)
  //                       .then((third) async {
  //                     //*
  //                     await PosApis().closeSession(openSession.sessionId!, 0.0, 'refund');
  //                     //*
  //                     showDialog(
  //                         context: context,
  //                         builder: (context) => UnClosableOkDialog(
  //                             text: third!.messageAr!,
  //                             onPressed: () {
  //                               Navigation().closeDialog(context);
  //                               Navigation().closeDialog(context);
  //                               Navigation().closeDialog(context);
  //                               Navigation().closeDialog(context);
  //                               Navigation().closeDialog(context);
  //                             }));
  //                   });
  //                 }
  //               });
  //             }
  //           });
  // //*
  //         }
  //       });
  //     } else {
  //       await PosApis().draftRefundOrderFirst(orderId).then((first) async {
  //         if (first!.status == 1) {
  //           await PosApis().refundOrderPaymentSecond(posId, currentPosActiveSessionId, first.refundOrderId!).then((second) async {
  //             if (second!.status == 1) {
  //               await PosApis()
  //                   .reverseRefundOrderInvoiceThird(posId, currentPosActiveSessionId, first.refundOrderId!)
  //                   .then((third) {
  //                 //*
  //                 showDialog(
  //                     context: context,
  //                     builder: (context) => UnClosableOkDialog(
  //                         text: third!.messageAr!,
  //                         onPressed: () {
  //                           Navigation().closeDialog(context);
  //                           Navigation().closeDialog(context);
  //                           Navigation().closeDialog(context);
  //                           Navigation().closeDialog(context);
  //                           Navigation().closeDialog(context);
  //                         }));
  //               });
  //             }
  //           });
  //         }
  //       });
  //     }
  //   }

  //* //* SEARCH ALL ORDERS
  void clearSearchAllOrdersList() {
    _allOrdersSearchResults = [];
    _isSearching = false;
    notifyListeners();
  }

  void onSearchAllOrdersTextChanged(String text) async {
    _allOrdersSearchResults = [];
    if (text.isNotEmpty && _allSessionOrders.data!.isNotEmpty) {
      _allOrdersSearchResults.clear();
      if (text.isEmpty) {
        return;
      }
      for (var result in _allSessionOrders.data!) {
        if (result.posReference.toString().toLowerCase().contains(text.toLowerCase())) {
          _allOrdersSearchResults.add(result);
        }
      }

      _isSearching = true;
      notifyListeners();
    }
    //* TO HIDE THE SEARCH RESULT BOX
    if (text.isEmpty) {
      _allOrdersSearchResults = [];
      _isSearching = false;
      notifyListeners();
    }
  }

  //* //* SEARCH
  bool get connectState => _connectState;
  ps.PosSessions _posSessions = ps.PosSessions();
  bool _isSearchingSessions = false;

  List<ps.Datum> _allSessionsSearchResult = [];

  // final OpenPosSession _openPosSession = OpenPosSession();

  CurrentSession _currentSession = CurrentSession();
  allkiosk.AllKioskOrders _allKioskOrders = allkiosk.AllKioskOrders();

  // final AvailablePaymentMethods _availablePaymentMethods = AvailablePaymentMethods();
  final int _selectedPaymentMethodId = 0;
  final String _selectedPaymentMethodName = '';

  final du.DeliveryUsers _deliveryUsers = du.DeliveryUsers(data: [], status: 0);
  final bool _isDeliveryOrder = false;
  allsessionorders.AllSessionOrders get allSessionOrders => _allSessionOrders;

  //* //* SEARCH SESSION ORDERS
  allsessionorders.AllSessionOrders _allSessionOrders = allsessionorders.AllSessionOrders();

  bool _isSearching = false;
  double _kioskOrderTotal = 0.0;

  String _latestOrderRefrence = '';
  String _latestOrderNumber = '';

  bool _discountApplied = false;
  bool _promotionApplied = false;

  bool get discountApplied => _discountApplied;
  bool get promotionApplied => _promotionApplied;
  allkiosk.AllKioskOrders get allKioskOrders => _allKioskOrders;
  List<ps.Datum> get allSessionsSearchResult => _allSessionsSearchResult;

  ps.PosSessions get posSessions => _posSessions;

  set setDiscountApplied(bool value) {
    _discountApplied = value;
    notifyListeners();
  }

  set setPromotionApplied(bool value) {
    _promotionApplied = value;
    notifyListeners();
  }

  String get latestOrderRefrence => _latestOrderRefrence;
  String get latestOrderNumber => _latestOrderNumber;

  set setLatestOrderRefrence(String value) {
    _latestOrderRefrence = value;
    notifyListeners();
  }

  set setLatestOrderNumber(String value) {
    _latestOrderNumber = value;
    notifyListeners();
  }

  //* FOR REFUND

  //* USB PRINTER
  bool _usePrinter = true;
  bool get usePrinter => _usePrinter;
  set setUsePrinter(bool value) {
    _usePrinter = value;
    notifyListeners();
  }

  bool _isUSBPrinter = false;
  int _vendorId = -1;
  int _productId = -1;

  //* //*
  bool get isUSBPrinter => _isUSBPrinter;
  int get vendorId => _vendorId;
  int get productId => _productId;

  //*mariam
  String _printName = '';
  String get printName => _printName;

  set setVendorId(int value) {
    _vendorId = value;
    notifyListeners();
  }

  set setProductId(int value) {
    _productId = value;
    notifyListeners();
  }

  set setIsUSBPrinter(bool value) {
    _isUSBPrinter = value;
    notifyListeners();
  }

  //* GETTERS

  int get loadingPercentage => _loadingPercentage;

  AllPos get allPos => _allPos;
  bool get isSearchingSessions => _isSearchingSessions;

  int get selectedPaymentMethodId => _selectedPaymentMethodId;
  String get selectedPaymentMethodName => _selectedPaymentMethodName;

  bool get isDeliveryOrder => _isDeliveryOrder;
  bool get isSearching => _isSearching;

  set setIsSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  double get kioskOrderTotal => _kioskOrderTotal;

  set setKioskOrderTotal(double value) {
    _kioskOrderTotal = value;
    notifyListeners();
  }

  //* SETTERS

  set setLoadingPercentage(int value) {
    _loadingPercentage = value;
    notifyListeners();
  }

  Future<void> getAllPos() async {
    _allPos = (await PosApis().getAllPos())!;

    notifyListeners();
  }

  Future<void> getPosSessions(int posId) async {
    _posSessions = (await PosApis().getPosSessions(posId))!;

    notifyListeners();
  }

  // Future<void> addNewPos(String posName) async {
  //   await PosApis().addNewPos(posName);

  //   getAllPos();
  // }

  // Future<void> openNewPosSession(int posId, int cashierId, int currencyId, double openingBalance, String openingNote) async {
  //   _openPosSession = (await PosApis().openNewPosSession(posId, cashierId, currencyId, openingBalance, openingNote))!;

  //   await getCurrentSessionData(posId);

  //   //  notifyListeners();
  // }

  Future<Map<String, dynamic>> checkForActiveSessions(int posId, int cashierId) async {
    // Future<bool> checkForActiveSessions(int posId, int cashierId) async {
    await getPosSessions(posId);

    //* Check for first time for this POS

    if (_posSessions.status == 0 && _posSessions.data!.isEmpty) {
      //* this is the first use for this pos

      print('FIRST TIME USE POS');

      return {"has_active_session": false, "same_user": true};
    }
    //* //*
    else {
      if (_posSessions.data![0].state == 'Opened/Active' && _posSessions.data![0].cashierId == cashierId) {
        print('POS HAS ACTIVE SESSION WITH SAME USER');
        return {"has_active_session": true, "same_user": true};
      } else if (_posSessions.data![0].state == 'Opened/Active' && _posSessions.data![0].cashierId != cashierId) {
        print('POS DOES NOT HAS ACTIVE SESSION WITH DIFF USER');
        return {"has_active_session": true, "same_user": false};
      } else {
        return {"has_active_session": false, "same_user": false};
      }
    }
  }

  Future<void> getCurrentSessionData(int posId) async {
    _currentSession = (await PosApis().getCurrentSessionData(posId))!;

    if (_currentSession.status != 0) {
      print('CURRENT SESSION ID: ${_currentSession.data![0].id!}');
    }

    notifyListeners();
  }

  Future<void> getAllSessionOrders(int sessionId) async {
    _allSessionOrders = (await PosApis().getAllSessionOrders(sessionId))!;

    notifyListeners();
  }

  // Future<void> generateAndRegisterDeliveryOrder(int orderId, int journalId, int sessionId) async {
  //   await PosApis().generateAndRegisterDeliveryOrder(orderId, journalId);
  //   await getAllSessionOrders(sessionId);
  // }

  //* //* SEARCH ALL ORDERS* //*

  //* SEARCH ALL SESSIONS

  void clearSearchAllSessionsList() {
    _allSessionsSearchResult = [];
    _isSearchingSessions = false;
    notifyListeners();
  }

  void onSearchAllSessionsTextChanged(String text) async {
    _allSessionsSearchResult = [];
    if (text.isNotEmpty && _posSessions.data!.isNotEmpty) {
      _allSessionsSearchResult.clear();
      if (text.isEmpty) {
        return;
      }
      for (var result in _posSessions.data!) {
        if (result.name.toString().toLowerCase().contains(text.toLowerCase()) ||
            result.cashierName.toString().toLowerCase().contains(text.toLowerCase()) ||
            result.posName.toString().toLowerCase().contains(text.toLowerCase())) {
          _allSessionsSearchResult.add(result);
        }
      }

      _isSearching = true;
      notifyListeners();
    }
    //* TO HIDE THE SEARCH RESULT BOX
    if (text.isEmpty) {
      _allSessionsSearchResult = [];
      _isSearching = false;
      notifyListeners();
    }
  }

  //*//*//*//* mariam
  set setPrintName(String value) {
    _printName = value;
    notifyListeners();
  }

  Future<void> getAllKioskOrders(int sessionId) async {
    _allKioskOrders = (await PosApis().getAllKioskOrders(sessionId))!;
    notifyListeners();
  }

  // Future<void> processKioskOrder(int orderId, int sessionId) async {
  //   await PosApis().processKioskOrder(orderId);
  //   await getAllKioskOrders(sessionId);
  // }

  void sortAllSessionOrders({required String filterChoice, required bool sortUp}) {
    print('filterChoice: $filterChoice');

    if (filterChoice == 'price'.tr()) {
      _allSessionOrders.data!.sort((a, b) {
        if (!sortUp) {
          return a.amountPaid!.compareTo(b.amountPaid!);
        } else {
          return b.amountPaid!.compareTo(a.amountPaid!);
        }
      });
    }

    if (filterChoice == 'date'.tr()) {
      _allSessionOrders.data!.sort((a, b) {
        if (!sortUp) {
          return a.dateOrder!.compareTo(b.dateOrder!);
        } else {
          return b.dateOrder!.compareTo(a.dateOrder!);
        }
      });
    }

    notifyListeners();
  }

  Future<void> generateAndRegisterDeliveryOrder(int orderId, int journalId, int sessionId) async {
    await PosApis().generateAndRegisterDeliveryOrder(orderId, journalId);
    await getAllSessionOrders(sessionId);
  }
}
