import 'dart:convert';

class DashBoardResponse {
  bool? success;
  String? message;
  Data? data;

  DashBoardResponse({this.success, this.message, this.data});

  DashBoardResponse copyWith({bool? success, String? message, Data? data}) =>
      DashBoardResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory DashBoardResponse.fromRawJson(String str) =>
      DashBoardResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DashBoardResponse.fromJson(Map<String, dynamic> json) =>
      DashBoardResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  TotalDashboardSummary? totalDashboardSummary;
  List<StockSummary>? stockSummary;

  Data({this.totalDashboardSummary, this.stockSummary});

  Data copyWith({
    TotalDashboardSummary? totalDashboardSummary,
    List<StockSummary>? stockSummary,
  }) => Data(
    totalDashboardSummary: totalDashboardSummary ?? this.totalDashboardSummary,
    stockSummary: stockSummary ?? this.stockSummary,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalDashboardSummary: json["total_dashboard_summary"] == null
        ? null
        : TotalDashboardSummary.fromJson(json["total_dashboard_summary"]),
    stockSummary: json["stock_summary"] == null
        ? []
        : List<StockSummary>.from(
            json["stock_summary"]!.map((x) => StockSummary.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "total_dashboard_summary": totalDashboardSummary?.toJson(),
    "stock_summary": stockSummary == null
        ? []
        : List<dynamic>.from(stockSummary!.map((x) => x.toJson())),
  };
}

class StockSummary {
  String? locationName;
  int? productCount;
  dynamic buyingPrice;

  StockSummary({this.locationName, this.productCount, this.buyingPrice});

  StockSummary copyWith({
    String? locationName,
    int? productCount,
    dynamic buyingPrice,
  }) => StockSummary(
    locationName: locationName ?? this.locationName,
    productCount: productCount ?? this.productCount,
    buyingPrice: buyingPrice ?? this.buyingPrice,
  );

  factory StockSummary.fromRawJson(String str) =>
      StockSummary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StockSummary.fromJson(Map<String, dynamic> json) => StockSummary(
    locationName: json["location_name"],
    productCount: json["product_count"],
    buyingPrice: json["buying_price"],
  );

  Map<String, dynamic> toJson() => {
    "location_name": locationName,
    "product_count": productCount,
    "buying_price": buyingPrice,
  };
}

class TotalDashboardSummary {
  int? totalItemInstock;
  double? estimatedSalesValue;
  int? soldItems;
  String? totalSalesAmount;

  TotalDashboardSummary({
    this.totalItemInstock,
    this.estimatedSalesValue,
    this.soldItems,
    this.totalSalesAmount,
  });

  TotalDashboardSummary copyWith({
    int? totalItemInstock,
    double? estimatedSalesValue,
    int? soldItems,
    String? totalSalesAmount,
  }) => TotalDashboardSummary(
    totalItemInstock: totalItemInstock ?? this.totalItemInstock,
    estimatedSalesValue: estimatedSalesValue ?? this.estimatedSalesValue,
    soldItems: soldItems ?? this.soldItems,
    totalSalesAmount: totalSalesAmount ?? this.totalSalesAmount,
  );

  factory TotalDashboardSummary.fromRawJson(String str) =>
      TotalDashboardSummary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TotalDashboardSummary.fromJson(Map<String, dynamic> json) =>
      TotalDashboardSummary(
        totalItemInstock: json["total_item_instock"],
        estimatedSalesValue: json["estimated_sales_value"]?.toDouble(),
        soldItems: json["sold_items"],
        totalSalesAmount: json["total_sales_amount"],
      );

  Map<String, dynamic> toJson() => {
    "total_item_instock": totalItemInstock,
    "estimated_sales_value": estimatedSalesValue,
    "sold_items": soldItems,
    "total_sales_amount": totalSalesAmount,
  };
}
