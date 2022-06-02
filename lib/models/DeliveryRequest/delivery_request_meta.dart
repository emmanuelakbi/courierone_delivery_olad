import 'package:json_annotation/json_annotation.dart';
part 'delivery_request_meta.g.dart';

@JsonSerializable()
class DeliveryRequestMeta {
  final String setTime;
  final String currentTime;

  DeliveryRequestMeta(this.setTime, this.currentTime);

  factory DeliveryRequestMeta.fromJson(Map<String, dynamic> json) =>
      _$DeliveryRequestMetaFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryRequestMetaToJson(this);
}
