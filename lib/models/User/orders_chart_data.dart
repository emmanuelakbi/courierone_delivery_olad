import 'package:json_annotation/json_annotation.dart';
part 'orders_chart_data.g.dart';

@JsonSerializable()
class OrdersChartData {
 final int period;
 final int total;

  OrdersChartData(this.period, this.total);

 factory OrdersChartData.fromJson(Map<String, dynamic> json) =>
     _$OrdersChartDataFromJson(json);
 Map<String, dynamic> toJson() => _$OrdersChartDataToJson(this);
}