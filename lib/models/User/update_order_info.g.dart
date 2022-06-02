// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_order_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateOrderInfo _$UpdateOrderInfoFromJson(Map<String, dynamic> json) {
  return UpdateOrderInfo(
    json['id'] as int,
    json['notes'],
    json['meta'],
    json['subtotal'] as int,
    json['taxes'] as int,
    json['delivery_fee'] as int,
    json['total'] as int,
    json['discount'] as int,
    json['type'] as String,
    json['scheduled_on'] as String,
    json['status'] as String,
    json['vendor_id'] as int,
    json['user_id'] as int,
    json['created_at'] as String,
    json['updated_at'] as int,
    (json['products'] as List)
        ?.map((e) =>
            e == null ? null : ProductInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['vendor'] == null
        ? null
        : VendorData.fromJson(json['vendor'] as Map<String, dynamic>),
    json['user'] == null
        ? null
        : MyProfileUser.fromJson(json['user'] as Map<String, dynamic>),
    json['address'] == null
        ? null
        : OrderAddress.fromJson(json['address'] as Map<String, dynamic>),
    json['delivery'] == null
        ? null
        : OrderDelivery.fromJson(json['delivery'] as Map<String, dynamic>),
    json['payment'] == null
        ? null
        : OrderPayment.fromJson(json['payment'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UpdateOrderInfoToJson(UpdateOrderInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notes': instance.notes,
      'meta': instance.meta,
      'subtotal': instance.subtotal,
      'taxes': instance.taxes,
      'delivery_fee': instance.deliveryFee,
      'total': instance.total,
      'discount': instance.discount,
      'type': instance.type,
      'scheduled_on': instance.scheduledOn,
      'status': instance.status,
      'vendor_id': instance.vendorId,
      'user_id': instance.userId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'products': instance.products,
      'vendor': instance.vendor,
      'user': instance.user,
      'address': instance.address,
      'delivery': instance.delivery,
      'payment': instance.payment,
    };
