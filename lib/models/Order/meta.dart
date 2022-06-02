import 'package:json_annotation/json_annotation.dart';
import 'food_item.dart';

part 'meta.g.dart';

@JsonSerializable()
class MetaCustom {
  //coming from customer app
  final String lwh;
  final String courier_type;
  final List<FoodItem> foodItems;
  final bool signatureRequired;
  final String notes_url;
  @JsonKey(name: 'frangible')
  final dynamic dynamicFrangible;
  @JsonKey(name: 'weight')
  final dynamic dynamicWeight;
  @JsonKey(name: 'order_category')
  final dynamic dynamicOrderCategory;

  //seting from delivery app
  String estimated_time_pickup;
  String estimated_time_delivery;

  MetaCustom(
      this.lwh,
      this.courier_type,
      this.dynamicOrderCategory,
      this.foodItems,
      this.signatureRequired,
      this.notes_url,
      this.dynamicFrangible,
      this.dynamicWeight);

  bool get frangible => (dynamicFrangible != null && dynamicFrangible is bool)
      ? dynamicFrangible
      : (dynamicFrangible != null && dynamicFrangible is String)
          ? (dynamicFrangible as String).toLowerCase() == "true"
          : false;

  String get weight => (dynamicWeight != null && dynamicWeight is String)
      ? dynamicWeight
      : "$dynamicWeight";

  String get order_category =>
      dynamicOrderCategory != null && dynamicOrderCategory is String
          ? dynamicOrderCategory
          : "other";

  factory MetaCustom.fromJson(Map json) => _$MetaCustomFromJson(json);

  Map toJson() => _$MetaCustomToJson(this);
}
