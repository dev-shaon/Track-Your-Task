import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:track_your_task/features/home/model/product_response_home.dart';
import 'package:track_your_task/networks/dio/dio.dart';
import 'package:track_your_task/networks/endpoints.dart';
import 'package:track_your_task/networks/exception_handler/data_source.dart';


final class GetProductApi {
  static final GetProductApi _singleton = GetProductApi._internal();
  GetProductApi._internal();

  static GetProductApi get instance => _singleton;

  Future<ProductResponseHome> getProduct({required int page}) async {
    try {
      Response response = await getHttp(EndPoints.product(page));
      if (response.statusCode == 200) {
        final data = ProductResponseHome.fromRawJson(
          json.encode(response.data),
        );
        return data;
      } else {
        log('Error: ${response.statusCode}');
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (e) {
      rethrow;
    }
  }
}
