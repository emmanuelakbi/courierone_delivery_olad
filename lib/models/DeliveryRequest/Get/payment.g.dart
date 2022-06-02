// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map json) {
  return Payment(
    json['id'] as int,
    json['payable_id'] as int,
    json['payer_id'] as int,
    json['amount'] as int,
    json['status'] as String,
    json['payment_method'] == null
        ? null
        : PaymentMethod.fromJson(json['payment_method'] as Map),
  );
}

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'id': instance.id,
      'payable_id': instance.payableId,
      'payer_id': instance.payerId,
      'amount': instance.amount,
      'status': instance.status,
      'payment_method': instance.paymentMethod,
    };
