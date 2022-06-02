import 'package:json_annotation/json_annotation.dart';
part 'update_profile_request.g.dart';

@JsonSerializable()
class UpdateProfile{
  // @JsonKey(name: 'is_online')
  final String name;
  @JsonKey(name: 'image_url')
  final String imageUrl;

  UpdateProfile(this.name, this.imageUrl);

  factory UpdateProfile.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateProfileToJson(this);
}
