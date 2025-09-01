import 'package:dio/dio.dart';

class Client {
  static var client = Dio();

  static const int _maxRetries = 20;
  static const Duration _retryDelay = Duration(seconds: 1);

  /// Generic helper for retrying requests on status 500
  Future<T?> retryRequest<T>(Future<Response> Function() request, T Function(dynamic data) parser, {int retryCount = 0}) async {
    try {
      final response = await request();

      print(
        'API Response [Attempt ${retryCount + 1}]: ${response.statusCode} - ${response.data} - ${response.requestOptions.uri}',
      );

      if (response.statusCode == 200) {
        return parser(response.data);
      } else if (response.statusCode == 500 && retryCount < _maxRetries) {
        await Future.delayed(_retryDelay);
        return retryRequest(request, parser, retryCount: retryCount + 1);
      } else {
        return null;
      }
    } catch (e) {
      if (retryCount < _maxRetries) {
        await Future.delayed(_retryDelay);
        return retryRequest(request, parser, retryCount: retryCount + 1);
      } else {
        print('API error after $_maxRetries retries >> $e');
        return null;
      }
    }
  }
}
