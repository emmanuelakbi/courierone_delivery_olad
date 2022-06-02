// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfile _$UpdateProfileFromJson(Map<String, dynamic> json) {
  return UpdateProfile(
    json['name'] as String,
    json['image_url'] as String,
  );
}

Map<String, dynamic> _$UpdateProfileToJson(UpdateProfile instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image_url': instance.imageUrl,
    };
