// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_request_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryRequestMeta _$DeliveryRequestMetaFromJson(Map<String, dynamic> json) {
  return DeliveryRequestMeta(
    json['setTime'] as String,
    json['currentTime'] as String,
  );
}

Map<String, dynamic> _$DeliveryRequestMetaToJson(
        DeliveryRequestMeta instance) =>
    <String, dynamic>{
      'setTime': instance.setTime,
      'currentTime': instance.currentTime,
    };
