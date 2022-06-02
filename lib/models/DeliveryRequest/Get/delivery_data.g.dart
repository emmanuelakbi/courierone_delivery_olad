// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryData _$DeliveryDataFromJson(Map json) {
  return DeliveryData(
    json['id'] as int,
    json['status'] as String,
    json['order_id'] as int,
    json['delivery'] == null
        ? null
        : DeliveryProfile.fromJson((json['delivery'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
  );
}

Map<String, dynamic> _$DeliveryDataToJson(DeliveryData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'order_id': instance.orderId,
      'delivery': instance.delivery?.toJson(),
    };
