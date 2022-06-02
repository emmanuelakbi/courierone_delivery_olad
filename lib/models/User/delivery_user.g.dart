// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryUser _$DeliveryUserFromJson(Map<String, dynamic> json) {
  return DeliveryUser(
    json['id'] as int,
    json['name'] as String,
    json['email'] as String,
    json['password'] as String,
    json['mobile_number'] as String,
    json['mobile_verified'] as int,
    json['active'] as int,
    json['language'] as String,
    json['notification'],
    json['meta'],
    json['mediaurls'] as List,
  );
}

Map<String, dynamic> _$DeliveryUserToJson(DeliveryUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'mobile_number': instance.mobileNumber,
      'mobile_verified': instance.mobileVerified,
      'active': instance.active,
      'language': instance.language,
      'notification': instance.notification,
      'meta': instance.meta,
      'mediaurls': instance.mediaurls,
    };
