// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorProduct _$VendorProductFromJson(Map<String, dynamic> json) {
  return VendorProduct(
    json['id'] as int,
    json['price'] as int,
    json['sale_price'],
    json['sale_price_from'],
    json['sale_price_to'],
    json['stock_quantity'],
    json['stock_low_threshold'],
    json['product_id'],
    json['vendor_id'],
  )
    ..vendor = json['vendor'] == null
        ? null
        : VendorData.fromJson(json['vendor'] as Map<String, dynamic>)
    ..product = json['product'] == null
        ? null
        : VendorProductInfo.fromJson(json['product'] as Map<String, dynamic>);
}

Map<String, dynamic> _$VendorProductToJson(VendorProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'sale_price': instance.salePrice,
      'sale_price_from': instance.salePriceFrom,
      'sale_price_to': instance.salePriceTo,
      'stock_quantity': instance.stockQuantity,
      'stock_low_threshold': instance.stockLowThreshold,
      'product_id': instance.productId,
      'vendor_id': instance.vendorId,
      'vendor': instance.vendor,
      'product': instance.product,
    };
