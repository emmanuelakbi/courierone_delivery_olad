// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfileDelivery _$UpdateProfileDeliveryFromJson(
    Map<String, dynamic> json) {
  return UpdateProfileDelivery(
    json['is_online'] as bool,
    (json['longitude'] as num)?.toDouble(),
    (json['latitude'] as num)?.toDouble(),
    json['meta'] as String,
  );
}

Map<String, dynamic> _$UpdateProfileDeliveryToJson(
        UpdateProfileDelivery instance) =>
    <String, dynamic>{
      'is_online': instance.isOnline,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'meta': instance.meta,
    };
