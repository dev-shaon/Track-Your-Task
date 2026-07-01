
import 'package:rxdart/rxdart.dart';
import 'package:track_your_task/features/auth/data/rx_sign_up/rx.dart';
import 'package:track_your_task/features/auth/data/rx_user_verify/rx.dart';
import 'package:track_your_task/features/auth/model/login_response.dart';

SignupRx signupRx = SignupRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
UserVerifyOtpRx userVerifyOtpRx = UserVerifyOtpRx(
  empty: LoginResponse(),
  dataFetcher: BehaviorSubject<LoginResponse>(),
);



// LogoutRx logoutRx = LogoutRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
