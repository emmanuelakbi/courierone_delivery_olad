import 'package:courieronedelivery/Authentication/AuthRepo/auth_interceptor.dart';
import 'package:courieronedelivery/Authentication/AuthRepo/test_status_code.dart';
import 'package:courieronedelivery/models/Order/order_data.dart';
import 'package:courieronedelivery/models/DeliveryRequest/Get/delivery_request.dart';
import 'package:courieronedelivery/models/base_list_response.dart';
import 'package:courieronedelivery/models/wallet_balance.dart';
import 'package:courieronedelivery/models/wallet_transaction.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'home_client.dart';

class HomeRepository {
  final Dio dio;
  final HomeClient client;

  HomeRepository._(this.dio, this.client);

  factory HomeRepository() {
    Dio dio = Dio();
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    dio.interceptors.add(AuthInterceptor());
    HomeClient client = HomeClient(dio);
    dio.options.headers = {
      "content-type": "application/json",
      'Accept': 'application/json',
    };
    return HomeRepository._(dio, client);
  }

  DatabaseReference _firebaseDbRef = FirebaseDatabase.instance.reference();

  Future<BaseListResponse<OrderData>> getNewDeliveries(
      int deliveryId, int pageNum) async {
    return client.getNewDeliveries(deliveryId, pageNum);
  }

  Future<BaseListResponse<OrderData>> getPastDeliveries(
      int deliveryId, int pageNum) async {
    return client.getPastDeliveries(deliveryId, pageNum);
  }

  Future<WalletBalance> getBalance(CancelToken cancelToken) {
    return client.getBalance("", cancelToken);
  }

  Future<BaseListResponse<WalletTransaction>> walletTransactions(
      int pageNo, CancelToken cancelToken) {
    return client.walletTransactions(pageNo, "", cancelToken);
  }

  Future<DeliveryRequest> getDeliveryRequest(int deliveryId) async {
    return client
        .getDeliveryRequest(deliveryId)
        .then((value) => value)
        .catchError(
          (Object obj) => null,
          test: (obj) => TestStatusCode.check(obj, 404),
        );
  }

  Stream<Event> getOrderRequestFirebaseDbRef(int deliveryId) async* {
    yield* _firebaseDbRef.child('deliveries/$deliveryId/order-request').onValue;
  }

  Stream<Event> getDeliveryLocationFirebaseDbRef(int deliveryId) async* {
    print("getDeliveryLocationFirebaseDbRef: $deliveryId");
    yield* _firebaseDbRef.child("deliveries/$deliveryId/location").onValue;
  }

  Future<void> removeFirebaseOrderRequest(int deliveryProfileId) async {
    print("removeFirebaseOrderRequest: $deliveryProfileId");
    await _firebaseDbRef
        .child('deliveries/$deliveryProfileId/order-request')
        .remove();
  }

  Future<DeliveryRequest> updateOrderRequest(
      int requestId, Map<String, String> requestBody) async {
    dynamic udrResponse =
        await client.updateDeliveryRequest(requestId, requestBody);
    DeliveryRequest deliveryRequestAssigned;
    try {
      deliveryRequestAssigned = DeliveryRequest.fromJson(udrResponse);
      _firebaseDbRef
          .child(
              'deliveries/${deliveryRequestAssigned.delivery.id}/order-request/status')
          .set(deliveryRequestAssigned.status);
    } catch (e) {
      print("updateOrderRequest: $e");
    }
    return deliveryRequestAssigned;
  }

  Future<OrderData> updateOrder(int orderId, Map<String, String> requestBody) {
    return client.updateOrder(orderId.toString(), requestBody);
  }

  Future<OrderData> getCurrentOrder(int deliveryId) async {
    print('delivery id: ' + deliveryId.toString());
    return client.getCurrentOrder(deliveryId).then((value) => value).catchError(
          (Object obj) => null,
          test: (obj) => TestStatusCode.check(obj, 404),
        );
  }
}
