// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryProfile _$DeliveryProfileFromJson(Map json) {
  return DeliveryProfile(
    json['id'] as int,
    json['meta'],
    json['is_verified'] as int,
    json['is_online'] as int,
    json['assigned'] as int,
    (json['longitude'] as num)?.toDouble(),
    (json['latitude'] as num)?.toDouble(),
    json['user'] == null
        ? null
        : UserInformation.fromJson((json['user'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
  )..isFresh = json['isFresh'] as bool;
}

Map<String, dynamic> _$DeliveryProfileToJson(DeliveryProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'meta': instance.meta,
      'is_verified': instance.isVerified,
      'is_online': instance.isOnline,
      'assigned': instance.assigned,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'user': instance.user,
      'isFresh': instance.isFresh,
    };
