// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Summary _$SummaryFromJson(Map<String, dynamic> json) {
  return Summary(
    json['orders_count'] as int,
    json['distance_travelled'] as int,
    json['earnings'] as int,
    (json['orders_chart_data'] as List)
        ?.map((e) => e == null
            ? null
            : OrdersChartData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SummaryToJson(Summary instance) => <String, dynamic>{
      'orders_count': instance.ordersCount,
      'distance_travelled': instance.distanceTravelled,
      'earnings': instance.earnings,
      'orders_chart_data': instance.ordersChartData,
    };
