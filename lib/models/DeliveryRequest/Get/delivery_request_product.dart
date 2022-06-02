import 'package:courieronedelivery/models/Vendor/media_library.dart';
import 'package:json_annotation/json_annotation.dart';
part 'delivery_request_product.g.dart';

@JsonSerializable(anyMap: true)
class DeliveryRequestProduct {
  final int id;
  final String title;
  final String detail;
  final dynamic meta;
  final int price;
  final String owner;
  @JsonKey(name: 'parent_id')
  final dynamic parentId;
  @JsonKey(name: 'attribute_term_id')
  final dynamic attributeTermId;
  final MediaLibrary mediaurls;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  DeliveryRequestProduct(
    this.id,
    this.title,
    this.detail,
    this.meta,
    this.price,
    this.owner,
    this.parentId,
    this.attributeTermId,
    this.mediaurls,
    this.createdAt,
    this.updatedAt,
  );

  factory DeliveryRequestProduct.fromJson(Map json) =>
      _$DeliveryRequestProductFromJson(json);

  Map toJson() => _$DeliveryRequestProductToJson(this);
}
