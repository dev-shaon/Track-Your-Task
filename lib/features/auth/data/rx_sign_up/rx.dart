// ignore_for_file: use_build_context_synchronously


import 'package:dio/dio.dart';

import 'package:rxdart/rxdart.dart';
import 'package:track_your_task/features/auth/data/rx_sign_up/api.dart';
import 'package:track_your_task/helpers/toast.dart';

import '../../../../../../networks/rx_base.dart';

final class SignupRx extends RxResponseInt<Map> {
  String? errorMessage;
  String? savePass;
  String? otp;
  final api = SignupApi.instance;

  SignupRx({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> signup({
    required String name,
    required String email,
    required String role,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final data = await api.signup(
        name: name,
        email: email,
        password: password, role: role, confirmPassword: confirmPassword,
      );
      handleSuccessWithReturn(data);
      savePass = password;
      // otp = data['data']['otp'].toString();
      // log(" otp>>>>>>>>>>>>>>>>>>>>>>>> $otp");

      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleErrorWithReturn(error) {
    if (error is DioException) {
      if (error.response!.statusCode == 400) {
        ToastUtil.showLongToast(errorMessage = error.response!.data['message']);
      } else if (error.response!.data['code'] == 403) {
        ToastUtil.showLongToast(errorMessage = error.response!.data['message']);
      } else {
        ToastUtil.showLongToast(errorMessage = error.response!.data['message']);
      }
    }
    // log(error.toString());
    dataFetcher.sink.addError(error);
    return false;
  }
}