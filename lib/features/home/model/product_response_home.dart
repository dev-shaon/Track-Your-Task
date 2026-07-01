import 'dart:convert';

class ProductResponseHome {
    bool? success;
    String? message;
    List<Datum>? data;

    ProductResponseHome({
        this.success,
        this.message,
        this.data,
    });

    ProductResponseHome copyWith({
        bool? success,
        String? message,
        List<Datum>? data,
    }) => 
        ProductResponseHome(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory ProductResponseHome.fromRawJson(String str) => ProductResponseHome.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ProductResponseHome.fromJson(Map<String, dynamic> json) => ProductResponseHome(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? name;
    String? location;
    String? shelfNumber;
    String? height;
    String? width;
    String? estimatedSalesValue;
    String? category;
    String? photo;

    Datum({
        this.id,
        this.name,
        this.location,
        this.shelfNumber,
        this.height,
        this.width,
        this.estimatedSalesValue,
        this.category,
        this.photo,
    });

    Datum copyWith({
        int? id,
        String? name,
        String? location,
        String? shelfNumber,
        String? height,
        String? width,
        String? estimatedSalesValue,
        String? category,
        String? photo,
    }) => 
        Datum(
            id: id ?? this.id,
            name: name ?? this.name,
            location: location ?? this.location,
            shelfNumber: shelfNumber ?? this.shelfNumber,
            height: height ?? this.height,
            width: width ?? this.width,
            estimatedSalesValue: estimatedSalesValue ?? this.estimatedSalesValue,
            category: category ?? this.category,
            photo: photo ?? this.photo,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        location: json["location"],
        shelfNumber: json["shelf_number"],
        height: json["height"],
        width: json["width"],
        estimatedSalesValue: json["estimated_sales_value"],
        category: json["category"],
        photo: json["photo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "location": location,
        "shelf_number": shelfNumber,
        "height": height,
        "width": width,
        "estimated_sales_value": estimatedSalesValue,
        "category": category,
        "photo": photo,
    };
}
