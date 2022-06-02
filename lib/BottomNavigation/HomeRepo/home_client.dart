import 'package:courieronedelivery/config/app_config.dart';
import 'package:courieronedelivery/models/DeliveryRequest/Get/delivery_profile.dart';
import 'package:courieronedelivery/models/DeliveryRequest/update_delivery_request.dart';
import 'package:courieronedelivery/models/Order/order_data.dart';
import 'package:courieronedelivery/models/Profile/update_profile.dart';
import 'package:courieronedelivery/models/DeliveryRequest/Get/delivery_request.dart';
import 'package:courieronedelivery/models/base_list_response.dart';
import 'package:courieronedelivery/models/wallet_balance.dart';
import 'package:courieronedelivery/models/wallet_transaction.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'home_client.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class HomeClient {
  factory HomeClient(Dio dio, {String baseUrl}) = _HomeClient;

  @GET('api/orders?active=1')
  Future<BaseListResponse<OrderData>> getNewDeliveries(
      @Query('delivery_profile') int id, @Query('page') int page,
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/orders?past=1')
  Future<BaseListResponse<OrderData>> getPastDeliveries(
      @Query('delivery_profile') int id, @Query('page') int page,
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/user/wallet/balance')
  Future<WalletBalance> getBalance(
      [@Header(HeaderKeys.authHeaderKey) String token,
      @CancelRequest() CancelToken cancelToken]);

  @GET('api/user/wallet/transactions')
  Future<BaseListResponse<WalletTransaction>> walletTransactions(
      @Query('page') int page,
      [@Header(HeaderKeys.authHeaderKey) String token,
      @CancelRequest() CancelToken cancelToken]);

  @GET('api/delivery/{id}/request')
  Future<DeliveryRequest> getDeliveryRequest(@Path('id') int id,
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @PUT('api/delivery/request/{id}')
  Future<dynamic> updateDeliveryRequest(
      @Path('id') int id, @Body() Map<String, String> requestBody,
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @PUT('api/delivery/{id}')
  Future<DeliveryProfile> updateDeliveryProfile(
      @Path('id') int deliveryId, @Body() UpdateProfileDelivery updateProfile,
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/delivery/{id}/order')
  Future<OrderData> getCurrentOrder(@Path('id') int id,
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @PUT('api/orders/{orderId}')
  Future<OrderData> updateOrder(
      @Path('orderId') String orderId, @Body() Map<String, String> requestBody,
      [@Header(HeaderKeys.authHeaderKey) String token]);
}
