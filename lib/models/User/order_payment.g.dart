// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderPayment _$OrderPaymentFromJson(Map<String, dynamic> json) {
  return OrderPayment(
    json['id'] as int,
    json['payable_id'] as int,
    json['payer_id'] as int,
    json['amount'] as int,
    json['status'] as String,
  )..paymentMethod = json['payment_method'] == null
      ? null
      : OrderPaymentMethod.fromJson(
          json['payment_method'] as Map<String, dynamic>);
}

Map<String, dynamic> _$OrderPaymentToJson(OrderPayment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'payable_id': instance.payableId,
      'payer_id': instance.payerId,
      'amount': instance.amount,
      'status': instance.status,
      'payment_method': instance.paymentMethod,
    };
