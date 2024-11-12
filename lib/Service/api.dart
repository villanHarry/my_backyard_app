//Class: returns the urls thorughout the app.

class API {
  /// [url] : Base url for apis.
  static String url = "https://admin.mybackyardusa.com/public/api";
  static String public_url = "https://admin.mybackyardusa.com/public/";

  //timeout Duraiton
  static Duration timeout = const Duration(seconds: 20);

  //**End points**//

  // General
  static const CONTENT_ENDPOINT = "/content";

  // Auth
  static const SIGN_IN_ENDPOINT = "/login";
  static const VERIFY_ACCOUNT_ENDPOINT = "/verification";
  static const COMPLETE_PROFILE_ENDPOINT = "/completeProfile";
  static const RESEND_OTP_ENDPOINT = "/re_send_code";
  static const SIGN_OUT_ENDPOINT = "/logout";
  static const SOCIAL_LOGIN_ENDPOINT = "/socialLogin";
  static const DELETE_ACCOUNT_ENDPOINT = "/delete_account";

  // categories
  static const CATEGORIES_ENDPOINT = "/categories";

  //buses
  static const GET_BUSES_ENDPOINT = '/getBuses';
  static const GET_OFFERS_ENDPOINT = '/getOffers';

  //**End points**//
}
