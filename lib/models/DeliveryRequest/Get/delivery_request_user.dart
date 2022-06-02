import 'package:json_annotation/json_annotation.dart';
part 'delivery_request_user.g.dart';

@JsonSerializable(anyMap: true)
class DeliveryRequestUser {
  final int id;
  final String name;

  final String email;
  @JsonKey(name: 'mobile_number')
  final String mobileNumber;
  @JsonKey(name: 'mobile_verified')
  final int mobileVerified;
  final int active;
  final String language;
  final notification;
  final meta;
  @JsonKey(name: 'remember_token')
  final rememberToken;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  DeliveryRequestUser(
    this.id,
    this.name,
    this.email,
    this.mobileNumber,
    this.mobileVerified,
    this.active,
    this.language,
    this.notification,
    this.meta,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
  );

  factory DeliveryRequestUser.fromJson(Map json) =>
      _$DeliveryRequestUserFromJson(json);

  Map toJson() => _$DeliveryRequestUserToJson(this);
}
