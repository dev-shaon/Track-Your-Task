// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';

import 'package:rxdart/rxdart.dart';
import 'package:track_your_task/features/auth/data/rx_login/api.dart';
import 'package:track_your_task/features/auth/model/login_response.dart';
import 'package:track_your_task/helpers/toast.dart';
import 'package:track_your_task/networks/dio/dio.dart';

import '../../../../../../constants/app_constants.dart';
import '../../../../../../helpers/di.dart';
import '../../../../../../networks/rx_base.dart';

final class LoginRx extends RxResponseInt<LoginResponse> {
  String? errorMessage;
  String? refreshToken;
  final api = LoginApi.instance;

  LoginRx({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> login({required String email, required String password}) async {
    try {
      // final data = await api.login(id: id);
      // handleSuccessWithReturn(data);
      final data = await api.login(email: email, password: password);
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(LoginResponse data) {
    errorMessage = null;
    appData.write(kKeyAccessToken, data.token ?? "");
    appData.write(kKeyUserId, data.data?.email ?? "");
    appData.write(kKeyIsLoggedIn, true);
    // log("user id??????????????????????${data.data?.id}");
    // appData.write(kkIsUserId, data.data?.id);
    // refreshToken = data?.refresh ?? "";
    // log("RESFRESS TOKEN IS >>>>$refreshToken");

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
