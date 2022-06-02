import 'package:courieronedelivery/models/DeliveryRequest/Get/payment_method.dart';
import 'package:json_annotation/json_annotation.dart';
part 'payment.g.dart';

@JsonSerializable(anyMap: true)
class Payment {
  Payment(
    this.id,
    this.payableId,
    this.payerId,
    this.amount,
    this.status,
    this.paymentMethod,
  );

  final int id;
  @JsonKey(name: 'payable_id')
  final int payableId;
  @JsonKey(name: 'payer_id')
  final int payerId;
  final int amount;
  final String status;
  @JsonKey(name: 'payment_method')
  final PaymentMethod paymentMethod;

  factory Payment.fromJson(Map json) => _$PaymentFromJson(json);

  Map toJson() => _$PaymentToJson(this);
}
