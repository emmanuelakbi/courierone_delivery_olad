import 'dart:async';
import 'dart:convert';

import 'package:courieronedelivery/BottomNavigation/HomeRepo/home_repository.dart';
import 'package:courieronedelivery/BottomNavigation/bloc/map_state.dart';
import 'package:courieronedelivery/BottomNavigation/map_repository.dart';
import 'package:courieronedelivery/components/my_map_widget.dart';
import 'package:courieronedelivery/components/time_picker_sheet.dart';
import 'package:courieronedelivery/models/DeliveryRequest/Get/delivery_profile.dart';
import 'package:courieronedelivery/models/DeliveryRequest/Get/delivery_request.dart';
import 'package:courieronedelivery/models/Order/order_data.dart';
import 'package:courieronedelivery/models/base_list_response.dart';
import 'package:courieronedelivery/utils/helper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrdersCubit extends Cubit<OrdersState> {
  HomeRepository _homeRepository = HomeRepository();
  MapRepository _mapRepository = MapRepository();
  StreamSubscription<Event> _orderRequestStream;
  Polyline _polylineVendorHome;
  StreamSubscription<Event> _deliveryLocationStreamSubscription;
  DeliveryProfile _deliveryProfile;

  OrdersCubit() : super(OrdersInitialState());

  void initFetchOrdersActive(DeliveryProfile deliveryProfile, int page) async {
    _deliveryProfile = deliveryProfile != null
        ? deliveryProfile
        : await Helper().getProfileMe();
    emit(OrdersLoadingState());
    if (_deliveryProfile != null && _deliveryProfile.isOnline == 1) {
      DeliveryRequest deliveryRequest;
      BaseListResponse<OrderData> newOrders;
      try {
        deliveryRequest =
            await _homeRepository.getDeliveryRequest(_deliveryProfile.id);
      } catch (e) {
        print("initFetchOrdersActive-getDeliveryRequest: $e");
      }
      try {
        newOrders = await _homeRepository.getNewDeliveries(
            _deliveryProfile.id, (page != null && page > 0) ? page : 1);
      } catch (e) {
        print("initFetchOrdersActive-getNewDeliveries: $e");
      }
      emit(OrdersActiveState(deliveryRequest, newOrders));
      registerRequestUpdates(_deliveryProfile.id);
    } else {
      emit(OrdersOfflineState());
      unRegisterRequestUpdates();
    }
  }

  void initFetchOrdersPast(DeliveryProfile deliveryProfile, int page) async {
    _deliveryProfile = deliveryProfile != null
        ? deliveryProfile
        : await Helper().getProfileMe();
    emit(OrdersLoadingState());
    if (_deliveryProfile != null && _deliveryProfile.isOnline == 1) {
      BaseListResponse<OrderData> pastOrders;
      try {
        pastOrders = await _homeRepository.getPastDeliveries(
            _deliveryProfile.id, (page != null && page > 0) ? page : 1);
      } catch (e) {
        print("initFetchOrdersPast-getPastDeliveries: $e");
      }
      emit(OrdersPastState(pastOrders));
    } else {
      emit(OrdersOfflineState());
    }
  }

  void initUpdateOrderRequest(int requestId, String status,
      [PickerTime timePicked]) async {
    emit(OrdersUpdatingState());
    try {
      DeliveryRequest deliveryRequestUpdated = await _homeRepository
          .updateOrderRequest(requestId, {"status": status});
      if (deliveryRequestUpdated != null) {
        if (timePicked != null &&
            deliveryRequestUpdated.status == "accepted" &&
            deliveryRequestUpdated.order != null) {
          try {
            deliveryRequestUpdated.order.meta.estimated_time_pickup =
                DateTime.now()
                    .add(Duration(minutes: timePicked.timeValue))
                    .millisecondsSinceEpoch
                    .toString();
            deliveryRequestUpdated.order.meta.estimated_time_delivery = "";

            //accept order when accepting request.
            OrderData orderDataUpdated = await _homeRepository.updateOrder(
                deliveryRequestUpdated.order.id, {
              "status": "accepted",
              "meta": jsonEncode(deliveryRequestUpdated.order.meta)
            });
            deliveryRequestUpdated.order = orderDataUpdated;
            //commented because list is gonna refresh anyways.
            //emit(OrdersUpdatedState(orderDataUpdated));
          } catch (e) {
            print("updateOrderRequest: $e");
          }
        }
        emit(OrderRequestUpdatedState(deliveryRequestUpdated));
      } else {
        emit(OrdersUpdateFailState("delivery_request_not_updated"));
      }
    } catch (e) {
      print("initUpdateOrderRequest: $e");
      emit(OrdersUpdateFailState("something_wrong"));
    }
  }

  void initUpdateOrder(OrderData orderData, String status,
      [PickerTime timePicked]) async {
    emit(OrdersUpdatingState());
    try {
      Map<String, String> updateBody;
      if (timePicked != null) {
        orderData.meta.estimated_time_delivery = DateTime.now()
            .add(Duration(minutes: timePicked.timeValue))
            .millisecondsSinceEpoch
            .toString();
        updateBody = {"status": status, "meta": jsonEncode(orderData.meta)};
      } else {
        updateBody = {"status": status};
      }
      OrderData orderDataUpdated =
          await _homeRepository.updateOrder(orderData.id, updateBody);
      emit(OrdersUpdatedState(orderDataUpdated));
    } catch (e) {
      print("initUpdateOrder-updateOrder: $e");
      emit(OrdersUpdateFailState("something_wrong"));
    }
  }

  void registerRequestUpdates(int profileId) {
    if (_orderRequestStream == null) {
      _orderRequestStream = _homeRepository
          .getOrderRequestFirebaseDbRef(profileId)
          .listen((Event event) async {
        if (event.snapshot != null && event.snapshot.value != null) {
          Map requestMap = event.snapshot.value;
          try {
            DeliveryRequest deliveryRequest =
                DeliveryRequest.fromJson(jsonDecode(jsonEncode(requestMap)));
            print("deliveryRequestFromMap: ${deliveryRequest.toString()}");
            if (deliveryRequest.order != null &&
                deliveryRequest.delivery != null &&
                deliveryRequest.status == "pending") {
              try {
                deliveryRequest = await _homeRepository.getDeliveryRequest(
                    _deliveryProfile != null
                        ? _deliveryProfile.id
                        : deliveryRequest.delivery.id);
              } catch (e) {
                print("registerRequestUpdates-getDeliveryRequest: $e");
              } finally {
                if (deliveryRequest != null) {
                  emit(OrderRequestLoadedState(deliveryRequest));
                } else {
                  _homeRepository.removeFirebaseOrderRequest(
                      _deliveryProfile != null
                          ? _deliveryProfile.id
                          : profileId);
                }
              }
            }
          } catch (e) {
            print("requestMapCastError: $e");
          }
        }
      });
    }
  }

  void initFetchOrderMapState(OrderData orderToShow, [bool reCenterAll]) async {
    Set<Marker> markers = Set();
    Set<Polyline> polyLines = Set();
    LatLng latLngCenter =
        LatLng(orderToShow.address.latitude, orderToShow.address.longitude);
    BitmapDescriptor srcIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
            /*devicePixelRatio: 4*/
            size: Size.fromHeight(10)),
        'images/map_icon1.png');
    BitmapDescriptor destIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
            /*devicePixelRatio: 4*/
            size: Size.fromHeight(10)),
        'images/map_icon2.png');

    markers.add(MyMapHelper.genMarker(
        LatLng(orderToShow.address.latitude, orderToShow.address.longitude),
        "marker_home",
        destIcon));
    markers.add(MyMapHelper.genMarker(
        LatLng(orderToShow.sourceAddress.latitude,
            orderToShow.sourceAddress.longitude),
        "marker_vendor",
        srcIcon));
    if (_polylineVendorHome == null) {
      _polylineVendorHome = Polyline(
          width: 3,
          polylineId: PolylineId('polyline_vendor_home'),
          points: await _mapRepository.getPolylineCoordinates(
              LatLng(orderToShow.sourceAddress.latitude,
                  orderToShow.sourceAddress.longitude),
              LatLng(orderToShow.address.latitude,
                  orderToShow.address.longitude)));
    }
    polyLines.add(_polylineVendorHome);

    if (!orderToShow.isComplete() &&
        orderToShow.delivery != null &&
        orderToShow.delivery.delivery != null &&
        orderToShow.delivery.delivery.latitude != null &&
        orderToShow.delivery.delivery.longitude != null) {
      BitmapDescriptor driverIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 2.5), 'images/deliveryman.png');
      markers.add(MyMapHelper.genMarker(
          LatLng(orderToShow.delivery.delivery.latitude,
              orderToShow.delivery.delivery.longitude),
          "marker_delivery",
          driverIcon));
    }

    if (reCenterAll != null && reCenterAll) {
      try {
        LatLngBounds latLngBounds =
            MyMapHelper.getMarkerBounds(markers.toList());
        LatLng centerAll = LatLng(
          (latLngBounds.northeast.latitude + latLngBounds.southwest.latitude) /
              2,
          (latLngBounds.northeast.longitude +
                  latLngBounds.southwest.longitude) /
              2,
        );
        latLngCenter = centerAll;
      } catch (e) {
        print("centerAllError: $e");
      }
    }

    emit(
        OrderMapLoadedState(MyMapData(latLngCenter, markers, polyLines, true)));
  }

  void initFetchLocationUpdates(int deliveryId) {
    if (_deliveryLocationStreamSubscription == null) {
      _deliveryLocationStreamSubscription = _homeRepository
          .getDeliveryLocationFirebaseDbRef(deliveryId)
          .listen((Event event) {
        if (event.snapshot != null && event.snapshot.value != null) {
          try {
            Map requestMap = event.snapshot.value;
            if (requestMap.containsKey("latitude") &&
                requestMap.containsKey("longitude")) {
              emit(DeliveryLocationUpdatedState(LatLng(
                  double.parse(requestMap["latitude"].toString()),
                  double.parse(requestMap["longitude"].toString()))));
            }
          } catch (e) {
            print("requestMapCastError: $e");
          }
        }
      });
    }
  }

  unRegisterRequestUpdates() async {
    if (_orderRequestStream != null) {
      await _orderRequestStream.cancel();
      _orderRequestStream = null;
    }
  }

  _unRegisterDeliveryLocationUpdates() async {
    if (_deliveryLocationStreamSubscription != null) {
      await _deliveryLocationStreamSubscription.cancel();
      _deliveryLocationStreamSubscription = null;
    }
  }

  @override
  Future<void> close() async {
    await unRegisterRequestUpdates();
    await _unRegisterDeliveryLocationUpdates();
    return super.close();
  }
}
