import 'package:courieronedelivery/models/Vendor/media_library.dart';
import 'package:json_annotation/json_annotation.dart';
import 'delivery_request_user.dart';
part 'delivery_request_vendor.g.dart';

@JsonSerializable(anyMap: true)
class DeliveryRequestVendor {
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
  final DeliveryRequestUser user;
  final int ratings;
  @JsonKey(name: 'ratings_count')
  final int ratingsCount;
  @JsonKey(name: 'favourite_count')
  final int favouriteCount;
  @JsonKey(name: 'is_favourite')
  final bool isFavourite;

  DeliveryRequestVendor(
    this.id,
    this.name,
    this.tagline,
    this.details,
    this.meta,
    this.mediaurls,
    this.minimumOrder,
    this.deliveryFee,
    this.area,
    this.address,
    this.longitude,
    this.latitude,
    this.isVerified,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.ratings,
    this.ratingsCount,
    this.favouriteCount,
    this.isFavourite,
  );

  factory DeliveryRequestVendor.fromJson(Map json) =>
      _$DeliveryRequestVendorFromJson(json);

  Map toJson() => _$DeliveryRequestVendorToJson(this);
}
