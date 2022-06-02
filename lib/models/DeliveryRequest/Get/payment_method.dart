import 'package:json_annotation/json_annotation.dart';
part 'payment_method.g.dart';

@JsonSerializable(anyMap: true)
class PaymentMethod {
  PaymentMethod(
    this.id,
    this.slug,
    this.title,
    this.enabled,
    this.type,
  );

  final int id;
  final String slug;
  final String title;
  final int enabled;
  final String type;

  factory PaymentMethod.fromJson(Map json) => _$PaymentMethodFromJson(json);

  Map toJson() => _$PaymentMethodToJson(this);
}
