import 'package:courieronedelivery/models/User/user_information.dart';
import 'package:json_annotation/json_annotation.dart';
part 'my_profile_response.g.dart';

@JsonSerializable()
class MyProfileResponse{
  final String id;
  final meta;
  @JsonKey(name: 'is_verified')
  final int isVerified;
  @JsonKey(name: 'is_online')
  final int isOnline;
  final int assigned;
  final double longitude;
  final double latitude;

  final MyProfileUser user;

  MyProfileResponse(this.id, this.meta, this.isVerified, this.isOnline, this.assigned, this.longitude, this.latitude, this.user);

  factory MyProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$MyProfileResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MyProfileResponseToJson(this);
}