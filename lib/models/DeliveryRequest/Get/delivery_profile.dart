import 'package:courieronedelivery/models/Auth/Responses/user_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delivery_profile.g.dart';

@JsonSerializable(anyMap: true)
class DeliveryProfile {
  DeliveryProfile(
    this.id,
    this.meta,
    this.isVerified,
    this.isOnline,
    this.assigned,
    this.longitude,
    this.latitude,
    this.user,
  );

  final int id;
  final dynamic meta;
  @JsonKey(name: 'is_verified')
  final int isVerified;
  @JsonKey(name: 'is_online')
  final int isOnline;
  final int assigned;
  final double longitude;
  final double latitude;
  final UserInformation user;

  bool isFresh;

  /// A necessary factory constructor for creating a new DeliveryProfile instance
  /// from a map. Pass the map to the generated `_$DeliveryProfileFromJson()` constructor.
  /// The constructor is named after the source class, in this case, DeliveryProfile.
  factory DeliveryProfile.fromJson(Map<String, dynamic> json) =>
      _$DeliveryProfileFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$DeliveryProfileToJson`.
  Map<String, dynamic> toJson() => _$DeliveryProfileToJson(this);

  @override
  String toString() {
    return 'DeliveryProfile{id: $id, isOnline: $isOnline}';
  }
}
