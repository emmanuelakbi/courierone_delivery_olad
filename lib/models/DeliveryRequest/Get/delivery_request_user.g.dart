// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_request_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryRequestUser _$DeliveryRequestUserFromJson(Map json) {
  return DeliveryRequestUser(
    json['id'] as int,
    json['name'] as String,
    json['email'] as String,
    json['mobile_number'] as String,
    json['mobile_verified'] as int,
    json['active'] as int,
    json['language'] as String,
    json['notification'],
    json['meta'],
    json['remember_token'],
    json['created_at'] as String,
    json['updated_at'] as String,
  );
}

Map<String, dynamic> _$DeliveryRequestUserToJson(
        DeliveryRequestUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'mobile_number': instance.mobileNumber,
      'mobile_verified': instance.mobileVerified,
      'active': instance.active,
      'language': instance.language,
      'notification': instance.notification,
      'meta': instance.meta,
      'remember_token': instance.rememberToken,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
