// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:rxdart/rxdart.dart';
import 'package:track_your_task/constants/app_constants.dart';
import 'package:track_your_task/features/auth/data/rx_user_verify/api.dart';
import 'package:track_your_task/features/auth/model/login_response.dart';
import 'package:track_your_task/helpers/di.dart';
import 'package:track_your_task/helpers/toast.dart';
import 'package:track_your_task/networks/dio/dio.dart';

import '../../../../../../networks/rx_base.dart';

final class UserVerifyOtpRx extends RxResponseInt<LoginResponse> {
  String? errorMessage;
  final api = UserVerifyOtpApi.instance;

  UserVerifyOtpRx({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> userVerifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final data = await api.userVerifyOtp(email: email, otp: otp);
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(LoginResponse data) {
    appData.write(kKeyAccessToken, data.token ?? "");
    appData.write(kKeyIsLoggedIn, true);
    //log("token save${appData.write(kKeyIsLoggedIn, true)}");
    // String token = appData.read(kKeyAccessToken);
    log("the token is ${data.token ?? ""}");
    DioSingleton.instance.update(data.token ?? "");
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  handleErrorWithReturn(error) {
    if (error is DioException) {
      if (error.response!.statusCode == 400) {
        ToastUtil.showLongToast(error.response!.data['message']);
      } else if (error.response!.data['code'] == 403) {
        ToastUtil.showLongToast(error.response!.data['message']);
      } else {
        ToastUtil.showLongToast(error.response!.data['message']);
      }
    }
    // log(error.toString());
    dataFetcher.sink.addError(error);
    return false;
  }
}

// import 'package:dio/dio.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:williamwu13_app/features/auth/data/rx_user_verify_otp/api.dart';
// import 'package:williamwu13_app/helpers/toast.dart';

// import '../../../../../../networks/rx_base.dart';

// final class UserVerifyOtpRx extends RxResponseInt<Map> {
//   String? errorMessage;
//   final api = UserVerifyOtpApi.instance;

//   UserVerifyOtpRx({required super.empty, required super.dataFetcher});

//   ValueStream get getFileData => dataFetcher.stream;

//   Future<bool> userVerifyOtp({
//     required String email,
//     required String otp,
//   }) async {
//     try {
//       final data = await api.userVerifyOtp(email: email, otp: otp);
//       handleSuccessWithReturn(data);
//       return true;
//     } catch (error) {
//       return handleErrorWithReturn(error);
//     }
//   }

//   @override
//   handleErrorWithReturn(error) {
//     if (error is DioException) {
//       if (error.response!.statusCode == 400) {
//         ToastUtil.showLongToast(errorMessage = error.response!.data['message']);
//       } else if (error.response!.data['code'] == 403) {
//         ToastUtil.showLongToast(errorMessage = error.response!.data['message']);
//       } else {
//         ToastUtil.showLongToast(errorMessage = error.response!.data['message']);
//       }
//     }
//     // log(error.toString());
//     dataFetcher.sink.addError(error);
//     return false;
//   }
// }
