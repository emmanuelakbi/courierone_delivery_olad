import 'package:json_annotation/json_annotation.dart';
part 'order_address.g.dart';

@JsonSerializable()
class OrderAddress{
  final int id;
  @JsonKey(name: 'formatted_address')
  final String formattedAddress;
  final double longitude;
  final double latitude;
  @JsonKey(name: 'order_id')
  final int orderId;

  OrderAddress(this.id, this.formattedAddress, this.longitude, this.latitude, this.orderId);

  factory OrderAddress.fromJson(Map<String, dynamic> json) =>
      _$OrderAddressFromJson(json);

  Map<String, dynamic> toJson() => _$OrderAddressToJson(this);
}