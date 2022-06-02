import 'package:courieronedelivery/models/Auth/Responses/user_info.dart';
import 'package:courieronedelivery/models/DeliveryRequest/Get/delivery_data.dart';
import 'package:courieronedelivery/models/DeliveryRequest/Get/payment.dart';
import 'package:courieronedelivery/models/DeliveryRequest/Get/product.dart';
import 'package:courieronedelivery/models/Order/address.dart';
import 'package:courieronedelivery/models/Order/delivery_mode.dart';
import 'package:courieronedelivery/models/Order/meta.dart';
import 'package:courieronedelivery/models/Order/vendor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_data.g.dart';

@JsonSerializable()
class OrderData {
  final int id;
  final String notes;
  final MetaCustom meta;
  final int subtotal;
  final double taxes;
  @JsonKey(name: 'delivery_fee')
  final int deliveryFee;
  final double total;
  final double discount;
  @JsonKey(name: 'order_type')
  final String orderType;
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
  final String updatedAt;
  final List<Product> products;
  final Vendor vendor;
  final UserInformation user;
  final Address address;
  @JsonKey(name: 'source_address')
  final Address sourceAddress;
  final DeliveryData delivery;
  final Payment payment;
  @JsonKey(name: 'delivery_mode')
  final DeliveryMode deliveryMode;
  String statusToUpdate;

  OrderData(
      this.id,
      this.notes,
      this.meta,
      this.subtotal,
      this.taxes,
      this.deliveryFee,
      this.total,
      this.discount,
      this.orderType,
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
      this.sourceAddress,
      this.delivery,
      this.payment,
      this.deliveryMode);

  factory OrderData.fromJson(Map<String, dynamic> json) =>
      _$OrderDataFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDataToJson(this);

  //responsible for setting action button's Text and Action.
  String getStatusToShow() {
    switch (status) {
      case "new":
      case "pending":
        {
          statusToUpdate = "accepted";
          return "order_status_action_pending";
        }
      case "accepted":
      case "preparing":
      case "prepared":
        {
          statusToUpdate = "dispatched";
          return "order_status_action_accepted";
        }
      case "dispatched":
      case "intransit":
        {
          statusToUpdate = "complete";
          return "order_status_action_dispatched";
        }
      default:
        {
          statusToUpdate = null;
          return "order_status_" + status;
        }
    }
  }

  bool isComplete() {
    return status == "complete" ||
        status == "cancelled" ||
        status == "rejected" ||
        status == "refund" ||
        status == "failed";
  }

  @override
  String toString() {
    return 'OrderData{id: $id, status: $status, vendorId: $vendorId, userId: $userId, createdAt: $createdAt}';
  }
}
