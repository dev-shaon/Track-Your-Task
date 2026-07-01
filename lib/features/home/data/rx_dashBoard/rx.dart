import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:rxdart/streams.dart';
import 'package:track_your_task/constants/app_constants.dart';
import 'package:track_your_task/features/home/data/rx_dashBoard/api.dart';
import 'package:track_your_task/features/home/model/dash_board_response.dart';
import 'package:track_your_task/helpers/di.dart';
import 'package:track_your_task/helpers/toast.dart';
import 'package:track_your_task/networks/stream_cleaner.dart';

import '../../../../../../networks/rx_base.dart';

final class GetDashBoardRx extends RxResponseInt<DashBoardResponse> {
  GetDashBoardRx({required super.empty, required super.dataFetcher});

  ValueStream get getDashBoardStream => dataFetcher.stream;
  final api = GetDashBoardApi.instance;

  Future<bool> getDashBoard() async {
    try {
      final data = await api.getDashBoard();
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleErrorWithReturn(dynamic error) {
    if (error is DioException) {
      if (error.response!.statusCode == 401) {
        totalDataClean();
        appData.write(kKeyIsLoggedIn, false);
        // NavigationService.navigateToReplacementUntil(Routes.signinScreen);
      } else {
        ToastUtil.showLongToast(error.response!.data["message"]);
      }
    }
    log(error.toString());
    dataFetcher.sink.addError(error);
    return false;
  }
}
