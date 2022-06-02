// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorProductInfo _$VendorProductInfoFromJson(Map<String, dynamic> json) {
  return VendorProductInfo(
    json['id'] as int,
    json['title'] as String,
    json['detail'] as String,
    json['meta'],
    json['price'] as int,
    json['owner'] as String,
    json['parent_id'],
    json['attribute_term_id'],
    json['mediaurls'] as List,
    json['created_at'] as String,
    json['updated_at'] as String,
  );
}

Map<String, dynamic> _$VendorProductInfoToJson(VendorProductInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'detail': instance.detail,
      'meta': instance.meta,
      'price': instance.price,
      'owner': instance.owner,
      'parent_id': instance.parentId,
      'attribute_term_id': instance.attributeTermId,
      'mediaurls': instance.mediaurls,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
