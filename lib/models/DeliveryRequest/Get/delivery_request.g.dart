// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryRequest _$DeliveryRequestFromJson(Map json) {
  return DeliveryRequest(
    json['id'] as int,
    json['order'] == null
        ? null
        : OrderData.fromJson((json['order'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    json['delivery'] == null
        ? null
        : DeliveryProfile.fromJson((json['delivery'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    json['status'] as String,
    json['created_at'] as String,
    json['updated_id'] as String,
  );
}

Map<String, dynamic> _$DeliveryRequestToJson(DeliveryRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'delivery': instance.delivery,
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_id': instance.updatedAt,
    };
