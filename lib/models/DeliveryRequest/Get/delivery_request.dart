import 'package:json_annotation/json_annotation.dart';
import 'delivery_profile.dart';
import 'package:courieronedelivery/models/Order/order_data.dart';

part 'delivery_request.g.dart';

@JsonSerializable(anyMap: true)
class DeliveryRequest {
  DeliveryRequest(
    this.id,
    this.order,
    this.delivery,
    this.status,
    this.createdAt,
    this.updatedAt,
  );

  final int id;
  OrderData order;
  final DeliveryProfile delivery;
  final String status;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_id')
  final String updatedAt;

  factory DeliveryRequest.fromJson(Map json) => _$DeliveryRequestFromJson(json);

  Map toJson() => _$DeliveryRequestToJson(this);

  @override
  String toString() {
    return 'DeliveryRequest{id: $id, order: $order, status: $status, createdAt: $createdAt}';
  }

  bool isComplete() {
    return status == "rejected" || status == "accepted";
  }
}
