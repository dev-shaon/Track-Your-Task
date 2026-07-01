// ignore_for_file: constant_identifier_names

// const String url = String.fromEnvironment("BASE_URL");
// const String url = "http://192.168.40.77:8000";
// const String url = "https://henock.softvencefsd.xyz";
// const String url = "https://puppy.softvencefsd.xyz/api";
const String url = "https://admin.boxmyart.com/api";

final class NetworkConstants {
  NetworkConstants._();
  static const ACCEPT = "Accept";
  static const APP_KEY = "App-Key";
  static const ACCEPT_LANGUAGE = "Accept-Language";
  static const ACCEPT_LANGUAGE_VALUE = "pt";
  static const APP_KEY_VALUE = String.fromEnvironment("APP_KEY_VALUE");
  static const ACCEPT_TYPE = "application/json";
  static const AUTHORIZATION = "Authorization";
  static const CONTENT_TYPE = "content-Type";
}

final class EndPoints {
  EndPoints._();
  static String login() => "/login";
  static String signUp() => "/register";
  static String userVerify() => "/verify-otp";
  static String forgetPassword() => "/forget-password";
  static String otpVerify() => "/otp-token";
  static String resetPassword() => "/reset-password";
  static String logOut() => "/logout";
  static String userProfile() => "/me";
  static String editProfile() => "/update-profile";

  //dashBoard APi
  static String dashBoard() => "/dashboard/data";
  static String product(int page) => "/product/products?per_page=6&page=$page";
  static String productSearch() => "/product/search-products";
  static String productFilter(String location,String category,String selfNumber,String sold) => "/product/search-products?location=$location&category=$category&shelf_number=$selfNumber&status=$sold";
  static String location() => "/locations";
  static String addLocation() => "/locations/add";
  static String productDetails(int id) => "/product/show/$id";
  static String deleteProduct(int id) => "/product/delete/$id";

  // salles summery
  static String sallesSummery() => "/dashboard";
  static String salesReport(String startDate, String endDate) =>
      "/sales-dashboard?start_date=$startDate&end_date=$endDate";
  // expense
  static String addExpense() => "/expense";
  static String addAdjustment() => "/adjustment";
  static String userList() => "/user-list";

  // sale Product

  static String saleProduct(int id) => "/sale/product/$id";
  static String saveProdcut() => "/sale/save";
}
