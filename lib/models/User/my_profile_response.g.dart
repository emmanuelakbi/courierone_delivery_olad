// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyProfileResponse _$MyProfileResponseFromJson(Map<String, dynamic> json) {
  return MyProfileResponse(
    json['id'] as String,
    json['meta'],
    json['is_verified'] as int,
    json['is_online'] as int,
    json['assigned'] as int,
    (json['longitude'] as num)?.toDouble(),
    (json['latitude'] as num)?.toDouble(),
    json['user'] == null
        ? null
        : MyProfileUser.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MyProfileResponseToJson(MyProfileResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'meta': instance.meta,
      'is_verified': instance.isVerified,
      'is_online': instance.isOnline,
      'assigned': instance.assigned,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'user': instance.user,
    };
