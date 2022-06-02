import 'package:json_annotation/json_annotation.dart';
part 'order_payment_method.g.dart';

@JsonSerializable()
class OrderPaymentMethod{
  final int id;
  final String slug;
  final String title;
  final bool enabled;
  final String type;

  OrderPaymentMethod(this.id, this.slug, this.title, this.enabled, this.type);

  factory OrderPaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$OrderPaymentMethodFromJson(json);

  Map<String, dynamic> toJson() => _$OrderPaymentMethodToJson(this);
}