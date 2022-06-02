// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_delivery_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateDeliveryRequest _$UpdateDeliveryRequestFromJson(
    Map<String, dynamic> json) {
  return UpdateDeliveryRequest(
    json['status'] as String,
    json['meta'] as String,
  );
}

Map<String, dynamic> _$UpdateDeliveryRequestToJson(
        UpdateDeliveryRequest instance) =>
    <String, dynamic>{
      'status': instance.status,
      'meta': instance.meta,
    };
