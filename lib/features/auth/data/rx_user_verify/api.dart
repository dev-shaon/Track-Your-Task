import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:track_your_task/features/auth/model/login_response.dart';

import '/networks/endpoints.dart';
import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/exception_handler/data_source.dart';

final class UserVerifyOtpApi {
  static final UserVerifyOtpApi _singleton = UserVerifyOtpApi._internal();
  UserVerifyOtpApi._internal();
  static UserVerifyOtpApi get instance => _singleton;

  Future<LoginResponse> userVerifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      Map data = {"email": email, "otp": otp};

      Response response = await postHttp(EndPoints.userVerify(), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = LoginResponse.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}