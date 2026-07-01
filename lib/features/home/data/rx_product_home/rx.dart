import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:rxdart/streams.dart';
import 'package:track_your_task/constants/app_constants.dart';
import 'package:track_your_task/features/home/data/rx_product_home/api.dart';
import 'package:track_your_task/features/home/model/product_response_home.dart';
import 'package:track_your_task/helpers/di.dart';
import 'package:track_your_task/helpers/toast.dart';
import 'package:track_your_task/networks/stream_cleaner.dart';

import '../../../../../../networks/rx_base.dart';

final class GetProductRx extends RxResponseInt<ProductResponseHome> {
  GetProductRx({required super.empty, required super.dataFetcher});

  ValueStream get getProductStream => dataFetcher.stream;
  final api = GetProductApi.instance;

  Future<bool> getProduct({required int page}) async {
    try {
      final data = await api.getProduct(page: page);
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
