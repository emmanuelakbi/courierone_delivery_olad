import 'package:courieronedelivery/models/Vendor/image_data.dart';
import 'package:json_annotation/json_annotation.dart';
part 'media_library.g.dart';


@JsonSerializable()
class MediaLibrary {
  final List<ImageData> images;

  MediaLibrary(this.images);

  factory MediaLibrary.fromJson(Map<String, dynamic> json) =>
      _$MediaLibraryFromJson(json);
  Map<String, dynamic> toJson() => _$MediaLibraryToJson(this);
}

enum MediaImageSize { thumb, small, medium, large }