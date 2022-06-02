import 'package:courieronedelivery/models/User/order_payment_method.dart';
import 'package:json_annotation/json_annotation.dart';
part 'order_payment.g.dart';

@JsonSerializable()
class OrderPayment{
  final int id;
  @JsonKey(name: 'payable_id')
  final int payableId;
  @JsonKey(name: 'payer_id')
  final int payerId;
  final int amount;
  final String status;

  @JsonKey(name: 'payment_method')
  OrderPaymentMethod paymentMethod;

  OrderPayment(this.id, this.payableId, this.payerId, this.amount, this.status);

  factory OrderPayment.fromJson(Map<String, dynamic> json) =>
      _$OrderPaymentFromJson(json);

  Map<String, dynamic> toJson() => _$OrderPaymentToJson(this);
}