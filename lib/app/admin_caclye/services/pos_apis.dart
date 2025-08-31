import 'package:go_smart_admin_windos/app/admin_caclye/models/db_name_record_data.dart';
import 'package:dio/dio.dart';
import 'package:go_smart_admin_windos/app/admin_caclye/models/all_pos.dart';
import 'package:go_smart_admin_windos/app/admin_caclye/models/all_kiosk_orders.dart' as allkiosk;
import 'package:go_smart_admin_windos/app/admin_caclye/models/all_session_orders.dart';
import 'package:go_smart_admin_windos/app/admin_caclye/models/current_session.dart';
import 'package:go_smart_admin_windos/app/admin_caclye/models/generate_delivery_payment.dart';
import 'package:go_smart_admin_windos/app/admin_caclye/models/open_pos_session.dart';
import 'package:go_smart_admin_windos/app/admin_caclye/models/pos_sessions.dart';
import 'package:go_smart_admin_windos/app/admin_caclye/models/register_delivery_payment.dart';
import 'package:go_smart_admin_windos/helpers/dio_client.dart';

class PosApis {
  static const int _maxRetries = 20;
  static const Duration _retryDelay = Duration(seconds: 2);
  static String urlLink = "";

  /// Ensure urlLink is set before making API calls
  String _ensureUrlLink() {
    if (urlLink.isEmpty) {
      throw '❌ urlLink not set. Call getLinkUrlBranch() first.';
    }
    return urlLink;
  }

  /// Generic helper for retrying requests on status 500
  Future<T?> _retryRequest<T>(Future<Response> Function() request, T Function(dynamic data) parser, {int retryCount = 0}) async {
    try {
      final response = await request();

      if (response.statusCode == 200) {
        return parser(response.data);
      } else if (response.statusCode == 500 && retryCount < _maxRetries) {
        await Future.delayed(_retryDelay);
        return _retryRequest(request, parser, retryCount: retryCount + 1);
      } else {
        return null;
      }
    } catch (e) {
      if (retryCount < _maxRetries) {
        await Future.delayed(_retryDelay);
        return _retryRequest(request, parser, retryCount: retryCount + 1);
      } else {
        throw 'API error after $_maxRetries retries >> $e';
      }
    }
  }

  /// Always update urlLink here
  Future<String?> getLinkUrlBranch({required String dbName}) async {
    final url = 'http://65.109.226.255:12000/get_db_name_record_data/';
    try {
      final response = await Client.client.post(url, data: {"dummy": "string", "db_name": dbName});

      if (response.statusCode == 200) {
        final newUrl = DbNameRecordData.fromJson(response.data).result!;
        urlLink = newUrl;
        print("db name is $dbName");
        return urlLink;
      }
      return null;
    } catch (e) {
      throw 'getLinkUrlBranch error >> $e';
    }
  }

  Future<RegisterDeliveryPayment?> generateAndRegisterDeliveryOrder(int orderId, int journalId) async {
    final base = _ensureUrlLink();
    return _retryRequest(() async {
      final response = await Client.client.get('$base/generate_delivery_order_invoice/$orderId');

      if (response.statusCode == 200) {
        final generateDeliveryPayment = GenerateDeliveryPayment.fromJson(response.data);
        if (generateDeliveryPayment.status == 1) {
          return await Client.client.post(
            '$base/register_delivery_order_payment',
            data: {"invoice_id": generateDeliveryPayment.invoiceId, "journal_id": journalId},
          );
        }
      }
      return response;
    }, (data) => RegisterDeliveryPayment.fromJson(data));
  }

  Future<AllSessionOrders?> getAllSessionOrders(int sessionId) async {
    final base = _ensureUrlLink();
    return _retryRequest(
      () => Client.client.get('$base/get_session_orders/$sessionId'),
      (data) => AllSessionOrders.fromJson(data),
    );
  }

  Future<AllPos?> getAllPos() async {
    final base = _ensureUrlLink();
    return _retryRequest(() => Client.client.get('$base/get_all_pos'), (data) => AllPos.fromJson(data));
  }

  Future<PosSessions?> getPosSessions(int posId) async {
    final base = _ensureUrlLink();
    return _retryRequest(() => Client.client.get('$base/get_pos_sessions/$posId'), (data) => PosSessions.fromJson(data));
  }

  // Future<OpenPosSession?> openNewPosSession(
  //   int posId,
  //   int cashierId,
  //   int currencyId,
  //   double openingBalance,
  //   String openingNote,
  // ) async {
  //   final base = _ensureUrlLink();
  //   return _retryRequest(
  //     () => Client.client.post(
  //       '$base/open_pos_session',
  //       data: {
  //         "pos_id": posId,
  //         "cashier_id": cashierId,
  //         "currency_id": currencyId,
  //         "opening_balance": openingBalance,
  //         "opening_notes": openingNote,
  //       },
  //     ),
  //     (data) => OpenPosSession.fromJson(data),
  //   );
  // }

  Future<CurrentSession?> getCurrentSessionData(int posId) async {
    final base = _ensureUrlLink();
    return _retryRequest(() => Client.client.get('$base/get_pos_latest_session/$posId'), (data) => CurrentSession.fromJson(data));
  }

  Future<allkiosk.AllKioskOrders?> getAllKioskOrders(int sessionId) async {
    final base = _ensureUrlLink();
    return _retryRequest(
      () => Client.client.get('$base/get_session_all_kiosk_orders/$sessionId'),
      (data) => allkiosk.AllKioskOrders.fromJson(data),
    );
  }

  // Future<int?> getCustomerID() async {
  //   final base = _ensureUrlLink();
  //   return _retryRequest(() => Client.client.get('$base/get_customer_account'), (data) => data['data'] as int);
  // }
}
