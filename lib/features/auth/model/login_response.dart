import 'dart:convert';

class LoginResponse {
    bool? status;
    String? message;
    int? code;
    String? tokenType;
    String? token;
    int? expiresIn;
    Data? data;

    LoginResponse({
        this.status,
        this.message,
        this.code,
        this.tokenType,
        this.token,
        this.expiresIn,
        this.data,
    });

    factory LoginResponse.fromRawJson(String str) => LoginResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        tokenType: json["token_type"],
        token: json["token"],
        expiresIn: json["expires_in"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "code": code,
        "token_type": tokenType,
        "token": token,
        "expires_in": expiresIn,
        "data": data?.toJson(),
    };
}

class Data {
    int? id;
    String? name;
    String? email;
    dynamic avatar;
    DateTime? otpVerifiedAt;
    DateTime? lastActivityAt;
    bool? isOnline;
    int? balance;

    Data({
        this.id,
        this.name,
        this.email,
        this.avatar,
        this.otpVerifiedAt,
        this.lastActivityAt,
        this.isOnline,
        this.balance,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        avatar: json["avatar"],
        otpVerifiedAt: json["otp_verified_at"] == null ? null : DateTime.parse(json["otp_verified_at"]),
        lastActivityAt: json["last_activity_at"] == null ? null : DateTime.parse(json["last_activity_at"]),
        isOnline: json["is_online"],
        balance: json["balance"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "avatar": avatar,
        "otp_verified_at": otpVerifiedAt?.toIso8601String(),
        "last_activity_at": lastActivityAt?.toIso8601String(),
        "is_online": isOnline,
        "balance": balance,
    };
}
