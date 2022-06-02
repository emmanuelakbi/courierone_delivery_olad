import 'package:courieronedelivery/models/User/order_delivery.dart';
import 'package:courieronedelivery/models/User/order_payment.dart';
import 'package:courieronedelivery/models/User/order_address.dart';
import 'package:courieronedelivery/models/User/product_info.dart';
import 'package:courieronedelivery/models/User/user_information.dart';
import 'package:courieronedelivery/models/Vendor/vendor_data.dart';
import 'package:json_annotation/json_annotation.dart';
part 'update_order_info.g.dart';

@JsonSerializable()
class UpdateOrderInfo {
  final int id;
  final notes;
  final meta;
  final int subtotal;
  final int taxes;
  @JsonKey(name: 'delivery_fee')
  final int deliveryFee;
  final int total;
  final int discount;
  final String type;
  @JsonKey(name: 'scheduled_on')
  final String scheduledOn;
  final String status;
  @JsonKey(name: 'vendor_id')
  final int vendorId;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final int updatedAt;
  final List<ProductInfo> products;
  final VendorData vendor;
  final MyProfileUser user;

  final OrderAddress address;
  final OrderDelivery delivery;
  final OrderPayment payment;

  UpdateOrderInfo(
      this.id,
      this.notes,
      this.meta,
      this.subtotal,
      this.taxes,
      this.deliveryFee,
      this.total,
      this.discount,
      this.type,
      this.scheduledOn,
      this.status,
      this.vendorId,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.products,
      this.vendor,
      this.user,
      this.address,
      this.delivery,
      this.payment);

  factory UpdateOrderInfo.fromJson(Map<String, dynamic> json) =>
      _$UpdateOrderInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateOrderInfoToJson(this);
}
