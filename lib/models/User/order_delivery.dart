import 'package:courieronedelivery/models/DeliveryRequest/Get/delivery_profile.dart';
import 'package:json_annotation/json_annotation.dart';
part 'order_delivery.g.dart';

@JsonSerializable()
class OrderDelivery{
  final int id;
  final String status;
  final String orderId;
  DeliveryProfile delivery;

  OrderDelivery(this.id, this.status, this.orderId);

  factory OrderDelivery.fromJson(Map<String, dynamic> json) =>
      _$OrderDeliveryFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDeliveryToJson(this);
}