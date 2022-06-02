// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListOrder _$ListOrderFromJson(Map<String, dynamic> json) {
  return ListOrder(
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : OrderData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ListOrderToJson(ListOrder instance) => <String, dynamic>{
      'data': instance.listOfOrder,
    };
