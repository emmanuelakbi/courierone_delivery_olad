// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderAddress _$OrderAddressFromJson(Map<String, dynamic> json) {
  return OrderAddress(
    json['id'] as int,
    json['formatted_address'] as String,
    (json['longitude'] as num)?.toDouble(),
    (json['latitude'] as num)?.toDouble(),
    json['order_id'] as int,
  );
}

Map<String, dynamic> _$OrderAddressToJson(OrderAddress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'formatted_address': instance.formattedAddress,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'order_id': instance.orderId,
    };
