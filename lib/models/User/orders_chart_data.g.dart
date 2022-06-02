// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_chart_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdersChartData _$OrdersChartDataFromJson(Map<String, dynamic> json) {
  return OrdersChartData(
    json['period'] as int,
    json['total'] as int,
  );
}

Map<String, dynamic> _$OrdersChartDataToJson(OrdersChartData instance) =>
    <String, dynamic>{
      'period': instance.period,
      'total': instance.total,
    };
