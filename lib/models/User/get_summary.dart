import 'package:courieronedelivery/models/User/orders_chart_data.dart';
import 'package:json_annotation/json_annotation.dart';
part 'get_summary.g.dart';

@JsonSerializable()
class Summary{
  @JsonKey(name: 'orders_count')
  final int ordersCount;
  @JsonKey(name: 'distance_travelled')
  final int distanceTravelled;
  final int earnings;

  @JsonKey(name: 'orders_chart_data')
  final List<OrdersChartData> ordersChartData;

  Summary(this.ordersCount, this.distanceTravelled, this.earnings, this.ordersChartData);

  factory Summary.fromJson(Map<String, dynamic> json) =>
      _$SummaryFromJson(json);
  Map<String, dynamic> toJson() => _$SummaryToJson(this);
}

