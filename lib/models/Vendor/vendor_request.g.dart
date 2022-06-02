// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorRequest _$VendorRequestFromJson(Map<String, dynamic> json) {
  return VendorRequest(
    json['name'] as String,
    json['tagline'] as String,
    json['details'] as String,
    json['minimum_order'] as int,
    json['delivery_fee'] as int,
    json['area'] as String,
    json['address'] as String,
    (json['longitude'] as num)?.toDouble(),
    (json['latitude'] as num)?.toDouble(),
    (json['categories'] as List)?.map((e) => e as int)?.toList(),
  );
}

Map<String, dynamic> _$VendorRequestToJson(VendorRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'tagline': instance.tagline,
      'details': instance.details,
      'minimum_order': instance.minimumOrder,
      'delivery_fee': instance.deliveryFee,
      'area': instance.area,
      'address': instance.address,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'categories': instance.categories,
    };
