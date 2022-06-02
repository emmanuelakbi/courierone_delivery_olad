import 'package:json_annotation/json_annotation.dart';
part 'vendor_meta.g.dart';

@JsonSerializable()
class VendorMeta {
  final String type;
  final String prop1;

  VendorMeta(this.type, this.prop1);

  factory VendorMeta.fromJson(Map<String, dynamic> json) =>
      _$VendorMetaFromJson(json);

  Map<String, dynamic> toJson() => _$VendorMetaToJson(this);
}
