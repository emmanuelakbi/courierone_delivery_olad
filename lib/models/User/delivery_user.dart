import 'package:json_annotation/json_annotation.dart';
part 'delivery_user.g.dart';

@JsonSerializable()
class DeliveryUser{
  final int id;
  final String name;
  final String email;
  final String password;
  @JsonKey(name: 'mobile_number')
  final String mobileNumber;

  @JsonKey(name: 'mobile_verified')
  final int mobileVerified;

  final int active;
  final String language;
  final notification;
  final meta;
  final List<dynamic> mediaurls;

  DeliveryUser(this.id, this.name, this.email, this.password, this.mobileNumber, this.mobileVerified, this.active, this.language, this.notification, this.meta, this.mediaurls);

  factory DeliveryUser.fromJson(Map<String, dynamic> json) =>
      _$DeliveryUserFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryUserToJson(this);
}
