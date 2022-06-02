// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_request_vendor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryRequestVendor _$DeliveryRequestVendorFromJson(Map json) {
  return DeliveryRequestVendor(
    json['id'] as int,
    json['name'] as String,
    json['tagline'] as String,
    json['details'] as String,
    json['meta'],
    json['mediaurls'] == null
        ? null
        : MediaLibrary.fromJson((json['mediaurls'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    json['minimum_order'] as int,
    json['delivery_fee'] as int,
    json['area'] as String,
    json['address'] as String,
    (json['longitude'] as num)?.toDouble(),
    (json['latitude'] as num)?.toDouble(),
    json['is_verified'] as int,
    json['user_id'] as int,
    json['created_at'] as String,
    json['updated_at'] as String,
    json['user'] == null
        ? null
        : DeliveryRequestUser.fromJson(json['user'] as Map),
    json['ratings'] as int,
    json['ratings_count'] as int,
    json['favourite_count'] as int,
    json['is_favourite'] as bool,
  );
}

Map<String, dynamic> _$DeliveryRequestVendorToJson(
        DeliveryRequestVendor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tagline': instance.tagline,
      'details': instance.details,
      'meta': instance.meta,
      'mediaurls': instance.mediaurls,
      'minimum_order': instance.minimumOrder,
      'delivery_fee': instance.deliveryFee,
      'area': instance.area,
      'address': instance.address,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'is_verified': instance.isVerified,
      'user_id': instance.userId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'user': instance.user,
      'ratings': instance.ratings,
      'ratings_count': instance.ratingsCount,
      'favourite_count': instance.favouriteCount,
      'is_favourite': instance.isFavourite,
    };
