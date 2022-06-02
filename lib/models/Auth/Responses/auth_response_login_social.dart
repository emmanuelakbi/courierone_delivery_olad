import 'package:courieronedelivery/models/Auth/Responses/login_response.dart';

class AuthResponseSocial {
  String userName, userEmail, userImageUrl;
  LoginResponse authResponse;

  AuthResponseSocial(
      this.userName, this.userEmail, this.userImageUrl, this.authResponse);
}
