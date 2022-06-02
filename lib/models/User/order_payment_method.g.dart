// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderPaymentMethod _$OrderPaymentMethodFromJson(Map<String, dynamic> json) {
  return OrderPaymentMethod(
    json['id'] as int,
    json['slug'] as String,
    json['title'] as String,
    json['enabled'] as bool,
    json['type'] as String,
  );
}

Map<String, dynamic> _$OrderPaymentMethodToJson(OrderPaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'enabled': instance.enabled,
      'type': instance.type,
    };
