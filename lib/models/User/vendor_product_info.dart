import 'package:json_annotation/json_annotation.dart';
part 'vendor_product_info.g.dart';

@JsonSerializable()
class VendorProductInfo{
  final int id;
  final String title;
  final String detail;
  final meta;
  final int price;
  final String owner;
  @JsonKey(name: 'parent_id')
  final parentId;
  @JsonKey(name: 'attribute_term_id')
  final attributeTermId;
  final List<dynamic> mediaurls;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  VendorProductInfo(this.id, this.title, this.detail, this.meta, this.price, this.owner, this.parentId, this.attributeTermId, this.mediaurls, this.createdAt, this.updatedAt);

  factory VendorProductInfo.fromJson(Map<String, dynamic> json) =>
      _$VendorProductInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VendorProductInfoToJson(this);
}