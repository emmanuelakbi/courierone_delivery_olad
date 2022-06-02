// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _HomeClient implements HomeClient {
  _HomeClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://olad.org/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<BaseListResponse<OrderData>> getNewDeliveries(id, page,
      [token]) async {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(page, 'page');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'delivery_profile': id,
      r'page': page
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/orders?active=1',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = BaseListResponse<OrderData>.fromJson(
      _result.data,
      (json) => OrderData.fromJson(json),
    );
    return value;
  }

  @override
  Future<BaseListResponse<OrderData>> getPastDeliveries(id, page,
      [token]) async {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(page, 'page');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'delivery_profile': id,
      r'page': page
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/orders?past=1',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = BaseListResponse<OrderData>.fromJson(
      _result.data,
      (json) => OrderData.fromJson(json),
    );
    return value;
  }

  @override
  Future<WalletBalance> getBalance([token, cancelToken]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/user/wallet/balance',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data,
        cancelToken: cancelToken);
    final value = WalletBalance.fromJson(_result.data);
    return value;
  }

  @override
  Future<BaseListResponse<WalletTransaction>> walletTransactions(page,
      [token, cancelToken]) async {
    ArgumentError.checkNotNull(page, 'page');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'page': page};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/user/wallet/transactions',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data,
        cancelToken: cancelToken);
    final value = BaseListResponse<WalletTransaction>.fromJson(
      _result.data,
      (json) => WalletTransaction.fromJson(json),
    );
    return value;
  }

  @override
  Future<DeliveryRequest> getDeliveryRequest(id, [token]) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/delivery/$id/request',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = DeliveryRequest.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> updateDeliveryRequest(id, requestBody, [token]) async {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(requestBody, 'requestBody');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(requestBody ?? <String, dynamic>{});
    final _result = await _dio.request<void>('api/delivery/request/$id',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'PUT',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<DeliveryProfile> updateDeliveryProfile(deliveryId, updateProfile,
      [token]) async {
    ArgumentError.checkNotNull(deliveryId, 'deliveryId');
    ArgumentError.checkNotNull(updateProfile, 'updateProfile');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(updateProfile?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/delivery/$deliveryId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'PUT',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = DeliveryProfile.fromJson(_result.data);
    return value;
  }

  @override
  Future<OrderData> getCurrentOrder(id, [token]) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/delivery/$id/order',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = OrderData.fromJson(_result.data);
    return value;
  }

  @override
  Future<OrderData> updateOrder(orderId, requestBody, [token]) async {
    ArgumentError.checkNotNull(orderId, 'orderId');
    ArgumentError.checkNotNull(requestBody, 'requestBody');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(requestBody ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/orders/$orderId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'PUT',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = OrderData.fromJson(_result.data);
    return value;
  }
}
