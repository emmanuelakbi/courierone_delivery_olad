import 'package:courieronedelivery/components/my_map_widget.dart';
import 'package:courieronedelivery/models/DeliveryRequest/Get/delivery_request.dart';
import 'package:courieronedelivery/models/Order/order_data.dart';
import 'package:courieronedelivery/models/base_list_response.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/DeliveryRequest/Get/delivery_profile.dart';

abstract class OrdersState {
  const OrdersState();
}

class OrdersActiveState extends OrdersState {
  final DeliveryRequest deliveryRequest;
  final BaseListResponse<OrderData> orders;

  const OrdersActiveState(this.deliveryRequest, this.orders);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdersActiveState &&
          runtimeType == other.runtimeType &&
          deliveryRequest == other.deliveryRequest &&
          orders == other.orders;

  @override
  int get hashCode => deliveryRequest.hashCode ^ orders.hashCode;

  bool isEmpty() {
    return deliveryRequest == null &&
        (orders == null || orders.data == null || orders.data.isEmpty);
  }
}

class OrdersPastState extends OrdersState {
  final BaseListResponse<OrderData> orders;

  const OrdersPastState(this.orders);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdersPastState &&
          runtimeType == other.runtimeType &&
          orders == other.orders;

  @override
  int get hashCode => orders.hashCode;

  bool isEmpty() {
    return orders == null || orders.data == null || orders.data.isEmpty;
  }
}

class OrdersUpdatingState extends OrdersState {
  const OrdersUpdatingState();
}

class OrdersUpdatedState extends OrdersState {
  final OrderData orderData;

  const OrdersUpdatedState(this.orderData);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdersUpdatedState &&
          runtimeType == other.runtimeType &&
          orderData == other.orderData;

  @override
  int get hashCode => orderData.hashCode;
}

class OrderRequestLoadedState extends OrdersState {
  final DeliveryRequest deliveryRequest;

  OrderRequestLoadedState(this.deliveryRequest);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderRequestLoadedState &&
          runtimeType == other.runtimeType &&
          deliveryRequest == other.deliveryRequest;

  @override
  int get hashCode => deliveryRequest.hashCode;
}

class OrderMapLoadedState extends OrdersState {
  final MyMapData mapData;

  OrderMapLoadedState(this.mapData);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderMapLoadedState &&
          runtimeType == other.runtimeType &&
          mapData == other.mapData;

  @override
  int get hashCode => mapData.hashCode;
}

class OrderRequestUpdatedState extends OrdersState {
  final DeliveryRequest deliveryRequest;

  const OrderRequestUpdatedState(this.deliveryRequest);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderRequestUpdatedState &&
          runtimeType == other.runtimeType &&
          deliveryRequest == other.deliveryRequest;

  @override
  int get hashCode => deliveryRequest.hashCode;
}

class DeliveryLocationUpdatedState extends OrdersState {
  final LatLng latLng;

  const DeliveryLocationUpdatedState(this.latLng);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryLocationUpdatedState &&
          runtimeType == other.runtimeType &&
          latLng == other.latLng;

  @override
  int get hashCode => latLng.hashCode;
}

class OrdersUpdateFailState extends OrdersState {
  final String keyError;
  const OrdersUpdateFailState(this.keyError);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdersUpdateFailState &&
          runtimeType == other.runtimeType &&
          keyError == other.keyError;

  @override
  int get hashCode => keyError.hashCode;
}

class OrdersLoadingState extends OrdersState {
  const OrdersLoadingState();
}

class OrdersOfflineState extends OrdersState {
  const OrdersOfflineState();
}

abstract class DeliveryProfileState extends Equatable {}

class OrdersInitialState extends OrdersState {
  @override
  List<Object> get props => [];
}

class DeliveryProfileLoggedOutState extends DeliveryProfileState {
  @override
  List<Object> get props => [];
}

class DeliveryProfileInitialState extends DeliveryProfileState {
  @override
  List<Object> get props => [];
}

class DeliveryProfileLoadingState extends DeliveryProfileState {
  @override
  List<Object> get props => [];
}

class DeliveryProfileLoadedState extends DeliveryProfileState {
  @override
  List<Object> get props => [];
}

class DeliveryProfileErrorState extends DeliveryProfileState {
  final String message, message_key;

  DeliveryProfileErrorState(this.message, this.message_key);

  @override
  List<Object> get props => [message, message_key];
}

class RefreshedProfileState extends DeliveryProfileLoadedState {
  final DeliveryProfile deliveryProfile;

  RefreshedProfileState(this.deliveryProfile);

  @override
  List<Object> get props => [deliveryProfile];
}
