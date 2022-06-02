// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorProduct _$VendorProductFromJson(Map json) {
  return VendorProduct(
    json['id'] as int,
    json['price'] as int,
    json['sale_price'],
    json['sale_price_from'],
    json['sale_price_to'],
    json['stock_quantity'] as int,
    json['stock_low_threshold'] as int,
    json['product_id'] as int,
    json['vendor_id'] as int,
    json['vendor'] == null
        ? null
        : DeliveryRequestVendor.fromJson(json['vendor'] as Map),
    json['product'] == null
        ? null
        : DeliveryRequestProduct.fromJson(json['product'] as Map),
  );
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
