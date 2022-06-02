import 'package:json_annotation/json_annotation.dart';
import 'delivery_request_product.dart';
import 'delivery_request_vendor.dart';
part 'vendor_product.g.dart';

@JsonSerializable(anyMap: true)
class VendorProduct {
  final int id;
  final int price;
  @JsonKey(name: 'sale_price')
  final dynamic salePrice;
  @JsonKey(name: 'sale_price_from')
  final dynamic salePriceFrom;
  @JsonKey(name: 'sale_price_to')
  final dynamic salePriceTo;
  @JsonKey(name: 'stock_quantity')
  final int stockQuantity;
  @JsonKey(name: 'stock_low_threshold')
  final int stockLowThreshold;
  @JsonKey(name: 'product_id')
  final int productId;
  @JsonKey(name: 'vendor_id')
  final int vendorId;
  final DeliveryRequestVendor vendor;
  final DeliveryRequestProduct product;

  VendorProduct(
    this.id,
    this.price,
    this.salePrice,
    this.salePriceFrom,
    this.salePriceTo,
    this.stockQuantity,
    this.stockLowThreshold,
    this.productId,
    this.vendorId,
    this.vendor,
    this.product,
  );

  factory VendorProduct.fromJson(Map json) => _$VendorProductFromJson(json);

  Map toJson() => _$VendorProductToJson(this);
}
