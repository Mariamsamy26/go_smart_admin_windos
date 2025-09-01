import 'package:dio/dio.dart';
import 'package:go_smart_admin_windos/app/auth_branches_caclye/model/check_admin_login.dart';
import 'package:go_smart_admin_windos/app/auth_branches_caclye/model/login_model.dart';
import 'package:go_smart_admin_windos/helpers/dio_client.dart';

class AuthApis {
  Future<CheckAdminLogin?> checkAdminLogin(String email, String password) async {
    return Client().retryRequest(
      () => Client.client.post('http://65.109.226.255:12000/check_admin_login', data: {"email": email, "password": password}),
      (data) => CheckAdminLogin.fromJson(data),
    );
  }

  // Future<CheckAdminLogin?> checkAdminLogin(String email, String password) async {
  //   String url = 'http://65.109.226.255:12000/check_admin_login';

  //   try {
  //     final response = await Client.client.post(url, data: {"email": email, "password": password});
  //     if (response.statusCode == 200) {
  //       CheckAdminLogin checkAdminCheckAdminLogin = CheckAdminLogin.fromJson(response.data);
  //       return checkAdminCheckAdminLogin;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     throw 'login error >> $e';
  //   }
  // }
  Future<Login?> login(String email, String password, String uniqueId) async {
    return Client().retryRequest(
      () => Client.client.post(
        'http://65.109.226.255:12000/windows_signin',
        data: {"email": email, "password": password, "unique_id": uniqueId},
      ),
      (data) => Login.fromJson(data),
    );
  }
  // Future<Login?> login(String email, String password, String uniqueId) async {
  //   String url = 'http://65.109.226.255:12000/windows_signin';

  //   print(url);

  //   try {
  //     final response = await Client.client.post(url, data: {"email": email, "password": password, "unique_id": uniqueId});
  //     if (response.statusCode == 200) {
  //       Login login = Login.fromJson(response.data);
  //       return login;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     throw 'login error >> $e';
  //   }
  // }

  setClientuniqueId(String email, String uniqueId) async {
    return Client().retryRequest(
      () => Client.client.post('http://65.109.226.255:12000/set_client_unique_id', data: {"email": email, "unique_id": uniqueId}),
      (data) => Login.fromJson(data),
    );
  }
  // setClientuniqueId(String email, String uniqueId) async {
  //   String url = 'http://65.109.226.255:12000/set_client_unique_id';

  //   print(url);

  //   try {
  //     final response = await Client.client.post(url, data: {"email": email, "unique_id": uniqueId});
  //     if (response.statusCode == 200) {
  //       Login login = Login.fromJson(response.data);
  //       return login;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     throw 'setClientuniqueId >> $e';
  //   }
  // }
}
