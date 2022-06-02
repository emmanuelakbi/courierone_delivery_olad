//import 'package:courieronedelivery/models/User/order_address.dart';
//import 'package:courieronedelivery/models/User/order_payment.dart';
//import 'package:courieronedelivery/models/User/product_info.dart';
//import 'package:courieronedelivery/models/User/user_information.dart';
//import 'package:courieronedelivery/models/Vendor/vendor_data.dart';
//import 'package:json_annotation/json_annotation.dart';
//part 'order_info.g.dart';
//
//@JsonSerializable()
//class OrderInfo{
//  final int id;
//  final notes;
//  final meta;
//  final int subtotal;
//  final int taxes;
//  @JsonKey(name: 'delivery_fee')
//  final int deliveryFee;
//  final int total;
//  final int discount;
//  final String type;
//  @JsonKey(name: 'scheduled_on')
//  final String scheduledOn;
//  final String status;
//  @JsonKey(name: 'vendor_id')
//  final int vendorId;
//  @JsonKey(name: 'user_id')
//  final int userId;
//  @JsonKey(name: 'created_at')
//  final String createdAt;
//  @JsonKey(name: 'updated_at')
//  final int updatedAt;
//  final List<ProductInfo> products;
//  final VendorData vendor;
//  final MyProfileUser user;
//
//  final OrderAddress address;
//
//  final delivery;
//
//  final OrderPayment payment;
//
//  OrderInfo(this.id, this.notes, this.meta, this.subtotal, this.taxes, this.deliveryFee, this.total, this.discount, this.type, this.scheduledOn, this.status, this.vendorId, this.userId, this.createdAt, this.updatedAt, this.delivery, this.products, this.vendor, this.user, this.address, this.payment);
//
//
//  factory OrderInfo.fromJson(Map<String, dynamic> json) =>
//      _$OrderInfoFromJson(json);
//
//  Map<String, dynamic> toJson() => _$OrderInfoToJson(this);
//}
