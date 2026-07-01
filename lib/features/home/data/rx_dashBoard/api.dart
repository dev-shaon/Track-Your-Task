import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:track_your_task/features/home/model/dash_board_response.dart';
import 'package:track_your_task/networks/dio/dio.dart';
import 'package:track_your_task/networks/endpoints.dart';
import 'package:track_your_task/networks/exception_handler/data_source.dart';


final class GetDashBoardApi {
  static final GetDashBoardApi _singleton = GetDashBoardApi._internal();
  GetDashBoardApi._internal();

  static GetDashBoardApi get instance => _singleton;

  Future<DashBoardResponse> getDashBoard() async {
    try {
      Response response = await getHttp(EndPoints.dashBoard());
      if (response.statusCode == 200) {
        final data = DashBoardResponse.fromRawJson(json.encode(response.data));
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
