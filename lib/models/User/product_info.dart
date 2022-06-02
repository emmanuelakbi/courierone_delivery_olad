import 'package:courieronedelivery/models/User/vendor_product.dart';
import 'package:json_annotation/json_annotation.dart';
part 'product_info.g.dart';

@JsonSerializable()
class ProductInfo{
  final int id;
  final int quantity;
  final int total;
  final subtotal;
  @JsonKey(name: 'order_id')
  final int orderId;
  @JsonKey(name: 'vendor_product_id')
  final vendorProductId;

  @JsonKey(name: 'vendor_product')
  VendorProduct vendorProduct;

  @JsonKey(name: 'addon_choices')
  final addonChoices;

  ProductInfo(this.id, this.quantity, this.total, this.subtotal, this.orderId, this.vendorProductId, this.addonChoices);

  factory ProductInfo.fromJson(Map<String, dynamic> json) =>
      _$ProductInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductInfoToJson(this);
}