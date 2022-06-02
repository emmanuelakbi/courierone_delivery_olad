// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductInfo _$ProductInfoFromJson(Map<String, dynamic> json) {
  return ProductInfo(
    json['id'] as int,
    json['quantity'] as int,
    json['total'] as int,
    json['subtotal'],
    json['order_id'] as int,
    json['vendor_product_id'],
    json['addon_choices'],
  )..vendorProduct = json['vendor_product'] == null
      ? null
      : VendorProduct.fromJson(json['vendor_product'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ProductInfoToJson(ProductInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'total': instance.total,
      'subtotal': instance.subtotal,
      'order_id': instance.orderId,
      'vendor_product_id': instance.vendorProductId,
      'vendor_product': instance.vendorProduct,
      'addon_choices': instance.addonChoices,
    };
