import 'package:json_annotation/json_annotation.dart';
part 'vendor_request.g.dart';

@JsonSerializable()
class VendorRequest {
  final String name;
  final String tagline;
  final String details;
  @JsonKey(name: 'minimum_order')
  final int minimumOrder;
  @JsonKey(name: 'delivery_fee')
  final int deliveryFee;
  final String area;
  final String address;
  final double longitude;
  final double latitude;
  final List<int> categories;

  VendorRequest(
      this.name,
      this.tagline,
      this.details,
      this.minimumOrder,
      this.deliveryFee,
      this.area,
      this.address,
      this.longitude,
      this.latitude,
      this.categories);

  factory VendorRequest.fromJson(Map<String, dynamic> json) =>
      _$VendorRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VendorRequestToJson(this);
}