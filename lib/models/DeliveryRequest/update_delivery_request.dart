import 'package:json_annotation/json_annotation.dart';
part 'update_delivery_request.g.dart';

@JsonSerializable()
class UpdateDeliveryRequest {
  final String status;
  final String meta;

  UpdateDeliveryRequest(this.status, this.meta);

  factory UpdateDeliveryRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateDeliveryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateDeliveryRequestToJson(this);
}
