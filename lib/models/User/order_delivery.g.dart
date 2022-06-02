// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_delivery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDelivery _$OrderDeliveryFromJson(Map<String, dynamic> json) {
  return OrderDelivery(
    json['id'] as int,
    json['status'] as String,
    json['orderId'] as String,
  )..delivery = json['delivery'] == null
      ? null
      : DeliveryProfile.fromJson(json['delivery'] as Map<String, dynamic>);
}

Map<String, dynamic> _$OrderDeliveryToJson(OrderDelivery instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'orderId': instance.orderId,
      'delivery': instance.delivery,
    };
