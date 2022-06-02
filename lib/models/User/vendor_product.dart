import 'package:courieronedelivery/models/User/vendor_product_info.dart';
import 'package:courieronedelivery/models/Vendor/vendor_data.dart';
import 'package:json_annotation/json_annotation.dart';
part 'vendor_product.g.dart';

@JsonSerializable()
class VendorProduct{
  final int id;
  final int price;
  @JsonKey(name: 'sale_price')
  final salePrice;
  @JsonKey(name: 'sale_price_from')
  final salePriceFrom;
  @JsonKey(name: 'sale_price_to')
  final salePriceTo;
  @JsonKey(name: 'stock_quantity')
  final stockQuantity;
  @JsonKey(name: 'stock_low_threshold')
  final stockLowThreshold;
  @JsonKey(name: 'product_id')
  final productId;
  @JsonKey(name: 'vendor_id')
  final vendorId;
  VendorData vendor;
  VendorProductInfo product;

  VendorProduct(this.id, this.price, this.salePrice, this.salePriceFrom, this.salePriceTo, this.stockQuantity, this.stockLowThreshold, this.productId, this.vendorId);

  factory VendorProduct.fromJson(Map<String, dynamic> json) =>
      _$VendorProductFromJson(json);

  Map<String, dynamic> toJson() => _$VendorProductToJson(this);
}