import 'package:courieronedelivery/models/Auth/Responses/user_info.dart';
import 'package:courieronedelivery/models/Vendor/media_library.dart';
import 'package:json_annotation/json_annotation.dart';
part 'vendor_data.g.dart';

@JsonSerializable()
class VendorData {
  final int id;
  final String name;
  final String tagline;
  final String details;

  final meta;
  final MediaLibrary mediaurls;

  @JsonKey(name: 'minimum_order')
  final int minimumOrder;

  @JsonKey(name: 'delivery_fee')
  final int deliveryFee;

  final String area;
  final String address;
  final double longitude;
  final double latitude;

  @JsonKey(name: 'is_verified')
  final int isVerified;

  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  final UserInformation user;
  final int ratings;

  @JsonKey(name: 'ratings_count')
  final int ratingsCount;

  @JsonKey(name: 'favourite_count')
  final int favouriteCount;

  @JsonKey(name: 'is_favourite')
  final bool isFavourite;

  VendorData(this.id, this.name, this.tagline, this.details, this.meta, this.mediaurls, this.minimumOrder, this.deliveryFee, this.area, this.address, this.longitude, this.latitude, this.isVerified, this.userId, this.createdAt, this.updatedAt, this.user, this.ratings, this.ratingsCount, this.favouriteCount, this.isFavourite);


  factory VendorData.fromJson(Map<String, dynamic> json) =>
      _$VendorDataFromJson(json);

  Map<String, dynamic> toJson() => _$VendorDataToJson(this);
}

//flutter pub run build_runner build
