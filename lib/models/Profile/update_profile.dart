import 'package:json_annotation/json_annotation.dart';
part 'update_profile.g.dart';

@JsonSerializable()
class UpdateProfileDelivery {
  @JsonKey(name: 'is_online')
  final bool isOnline;
  final double longitude;
  final double latitude;
  final String meta;

  UpdateProfileDelivery(this.isOnline, this.longitude, this.latitude, this.meta);

  factory UpdateProfileDelivery.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileDeliveryFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileDeliveryToJson(this);
}
