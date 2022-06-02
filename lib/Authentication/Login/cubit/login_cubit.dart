import 'package:courieronedelivery/Authentication/AuthRepo/auth_repository.dart';
import 'package:courieronedelivery/models/Auth/Responses/auth_response_login_social.dart';
import 'package:courieronedelivery/models/Auth/Responses/login_response.dart';
import 'package:courieronedelivery/models/phone_number.dart';
import 'package:courieronedelivery/utils/helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  AuthRepo _authRepo = AuthRepo();

  LoginCubit() : super(LoginInitial());

  void initLoginPhone(String dialCode, String mobileNumber) async {
    if (dialCode != null &&
        dialCode.isNotEmpty &&
        mobileNumber != null &&
        mobileNumber.isNotEmpty) {
      emit(LoginLoading());
      try {
        String normalizedNumber = dialCode + mobileNumber;
        bool isRegistered = await _authRepo.isRegistered(normalizedNumber);
        emit(LoginExistsLoaded(isRegistered,
            PhoneNumber(dialCode, mobileNumber, normalizedNumber)));
      } catch (e) {
        print("initLoginPhone: $e");
        emit(LoginError("Something went wrong", "something_wrong"));
      }
      // bool isValid = await PhoneNumberUtil.isValidPhoneNumber(
      //     phoneNumber: mobileNumber, isoCode: isoCode);
      // if (isValid) {
      //   try {
      //     String normalizedNumber = await PhoneNumberUtil.normalizePhoneNumber(
      //         phoneNumber: mobileNumber, isoCode: isoCode);
      //     bool isRegistered = await _authRepo.isRegistered(normalizedNumber);
      //     emit(LoginExistsLoaded(isRegistered,
      //         PhoneNumber(isoCode, mobileNumber, normalizedNumber)));
      //   } catch (e) {
      //     print("initLoginPhone: $e");
      //     emit(LoginError("Something went wrong", "something_wrong"));
      //   }
      // } else {
      //   emit(LoginError("Invalid phone number", "invalid_phone"));
      // }
    } else {
      emit(LoginError("Invalid phone number", "invalid_phone"));
    }
  }

  void initLoginGoogle() async {
    emit(LoginLoading());
    try {
      final AuthResponseSocial loggedInResponseSocial =
          await _authRepo.signInWithGoogle();
      if (loggedInResponseSocial.authResponse != null) {
        await Helper().saveAuthResponse(loggedInResponseSocial.authResponse);
        emit(LoginLoaded(loggedInResponseSocial.authResponse));
      } else if (loggedInResponseSocial.userName != null ||
          loggedInResponseSocial.userEmail != null) {
        emit(LoginErrorSocial(
            loggedInResponseSocial.userName,
            loggedInResponseSocial.userEmail,
            loggedInResponseSocial.userImageUrl,
            "User doesn't exist",
            "social_user_na"));
      } else {
        emit(LoginError("Something went wrong", "something_wrong"));
      }
    } catch (e) {
      print(e);
      emit(LoginError("Something went wrong", "something_wrong"));
    }
  }

  // void initLoginFacebook() async {
  //   emit(LoginLoading());
  //   try {
  //     final AuthResponseSocial loggedInResponseSocial =
  //         await _authRepo.signInWithFacebook();
  //     if (loggedInResponseSocial.authResponse != null) {
  //       await Helper().saveAuthResponse(loggedInResponseSocial.authResponse);
  //       emit(LoginLoaded(loggedInResponseSocial.authResponse));
  //     } else if (loggedInResponseSocial.userName != null ||
  //         loggedInResponseSocial.userEmail != null) {
  //       emit(LoginErrorSocial(
  //           loggedInResponseSocial.userName,
  //           loggedInResponseSocial.userEmail,
  //           loggedInResponseSocial.userImageUrl,
  //           "User doesn't exist",
  //           "social_user_na"));
  //     } else {
  //       emit(LoginError("Something went wrong", "something_wrong"));
  //     }
  //   } catch (e) {
  //     print(e);
  //     emit(LoginError("Something went wrong", "something_wrong"));
  //   }
  // }
}
