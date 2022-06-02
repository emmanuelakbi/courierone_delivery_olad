import 'package:courieronedelivery/config/app_config.dart';
import 'package:courieronedelivery/models/Auth/Responses/login_response.dart';
import 'package:courieronedelivery/models/Auth/Responses/user_info.dart';
import 'package:courieronedelivery/models/Auth/auth_request_check_existence.dart';
import 'package:courieronedelivery/models/Auth/auth_request_login.dart';
import 'package:courieronedelivery/models/Auth/auth_request_login_social.dart';
import 'package:courieronedelivery/models/Auth/auth_request_register.dart';
import 'package:courieronedelivery/models/DeliveryRequest/Get/delivery_profile.dart';
import 'package:courieronedelivery/models/setting.dart';
import 'package:courieronedelivery/models/support.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_client.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class AuthClient {
  factory AuthClient(Dio dio, {String baseUrl}) = _AuthClient;

  @POST('api/check-user')
  Future<void> checkUser(@Body() AuthRequestCheckExistence checkUser);

  @POST('api/register')
  Future<LoginResponse> registerUser(@Body() AuthRequestRegister registerUser);

  @POST('api/login')
  Future<LoginResponse> login(@Body() AuthRequestLogin login);

  @POST('api/social/login')
  Future<LoginResponse> socialLogin(
      @Body() AuthRequestLoginSocial socialLoginUser);

  @POST('api/support')
  Future<void> createSupport(@Body() Support support);

  @GET('api/delivery')
  Future<DeliveryProfile> getDeliveryUserByToken(
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @PUT('api/delivery/{profileId}')
  Future<DeliveryProfile> updateDeliveryUser(
      @Path() String profileId,
      @Body() Map<String, String> map,
      @Header(HeaderKeys.authHeaderKey) String token);

  @PUT('api/user')
  Future<UserInformation> updateUser(
      @Body() Map<String, String> updateUserRequest,
      @Header("Authorization") String bearerToken);

  @PUT('api/user')
  Future<UserInformation> updateUserNotification(
      @Body() Map<String, String> updateUserNotificationRequest,
      @Header("Authorization") String bearerToken);

  @GET('api/user')
  Future<UserInformation> getUser(@Header("Authorization") String bearerToken);

  @GET('api/settings')
  Future<List<Setting>> getSettings();

// @PUT('api/user')
// Future<void> updateNotificationId(@Body() Notification notification,
//     [@Header(HeaderKeys.authHeaderKey) String token]);
}
