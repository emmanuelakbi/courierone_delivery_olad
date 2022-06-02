import 'package:json_annotation/json_annotation.dart';
import 'vendor_product.dart';
part 'product.g.dart';

@JsonSerializable(anyMap: true)
class Product {
  final int id;
  final int quantity;
  final int total;
  final dynamic subtotal;
  @JsonKey(name: 'order_id')
  final int orderId;
  @JsonKey(name: 'vendor_product_id')
  final dynamic vendorProductId;
  @JsonKey(name: 'vendor_product')
  final VendorProduct vendorProduct;
  @JsonKey(name: 'addon_choices')
  final List<dynamic> addonChoices;

  Product(
    this.id,
    this.quantity,
    this.total,
    this.subtotal,
    this.orderId,
    this.vendorProductId,
    this.vendorProduct,
    this.addonChoices,
  );

  factory Product.fromJson(Map json) => _$ProductFromJson(json);

  Map toJson() => _$ProductToJson(this);
}
