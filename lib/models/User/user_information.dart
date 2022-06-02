import 'package:courieronedelivery/models/Vendor/media_library.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_information.g.dart';

@JsonSerializable()
class MyProfileUser{
  final String id;
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
  final MediaLibrary mediaurls;

  MyProfileUser(this.id, this.name, this.email, this.password, this.mobileNumber, this.mobileVerified, this.active, this.language, this.notification, this.meta, this.mediaurls);

  factory MyProfileUser.fromJson(Map<String, dynamic> json) =>
      _$MyProfileUserFromJson(json);
  Map<String, dynamic> toJson() => _$MyProfileUserToJson(this);
}