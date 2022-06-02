import 'dart:async';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:courieronedelivery/BottomNavigation/bloc/map_state.dart';
import 'package:courieronedelivery/BottomNavigation/bloc/orders_cubit.dart';
import 'package:courieronedelivery/Locale/locales.dart';
import 'package:courieronedelivery/Theme/style.dart';
import 'package:courieronedelivery/UtilityFunctions/string_extension.dart';
import 'package:courieronedelivery/components/my_map_widget.dart';
import 'package:courieronedelivery/components/solid_bottom_sheet.dart';
import 'package:courieronedelivery/components/time_picker_sheet.dart';
import 'package:courieronedelivery/components/toaster.dart';
import 'package:courieronedelivery/models/DeliveryRequest/Get/delivery_request.dart';
import 'package:courieronedelivery/models/Order/order_data.dart';
import 'package:courieronedelivery/Theme/colors.dart';
import 'package:courieronedelivery/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryInfoPage extends StatelessWidget {
  final OrderData orderData;
  final DeliveryRequest deliveryRequest;

  DeliveryInfoPage(this.orderData, [this.deliveryRequest]);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrdersCubit>(
        create: (context) => OrdersCubit(),
        child: DeliveryInfo(orderData, this.deliveryRequest));
  }
}

class DeliveryInfo extends StatefulWidget {
  final OrderData orderData;
  final DeliveryRequest deliveryRequest;

  DeliveryInfo(this.orderData, this.deliveryRequest);

  @override
  _DeliveryInfoState createState() => _DeliveryInfoState();
}

class _DeliveryInfoState extends State<DeliveryInfo> {
  OrdersCubit _ordersCubit;
  OrderData _orderToShow;
  DeliveryRequest _deliveryRequestToShow;

  GlobalKey<MyMapState> _myMapStateKey = GlobalKey();
  GlobalKey<SolidBottomSheetState> _bottomSheetWidgetKey = GlobalKey();

  bool _isLoaderShowing = false;
  bool _isBottomSheetOpen = false;
  AppLocalizations _locale;
  ThemeData _theme;

  @override
  void initState() {
    _deliveryRequestToShow = widget.deliveryRequest;
    _orderToShow = widget.orderData;
    super.initState();
    _ordersCubit = BlocProvider.of<OrdersCubit>(context);
    _ordersCubit.initFetchOrderMapState(_orderToShow, true);
  }

  @override
  void dispose() {
    _ordersCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _locale = AppLocalizations.of(context);
    _theme = Theme.of(context);

    return BlocConsumer<OrdersCubit, OrdersState>(
        listener: (context, state) async {
      if (state is OrdersUpdatingState)
        showLoader();
      else
        dismissLoader();

      bool hadDelivery = _orderToShow.delivery != null &&
          _orderToShow.delivery.delivery != null;

      if (state is OrderRequestUpdatedState) {
        _deliveryRequestToShow = state.deliveryRequest;
        _orderToShow = _deliveryRequestToShow.order;
        if (_deliveryRequestToShow.status == "rejected") {
          await Helper().setTempOrderRequest(_deliveryRequestToShow);
          Toaster.showToastCenter(
              _locale.getTranslationOf("order_status_action_rejected"));
          Navigator.pop(context);
        }
      }
      if (state is OrdersUpdatedState) {
        _orderToShow = state.orderData;
        await Helper().setTempOrder(_orderToShow);
      }

      bool hasDelivery = _orderToShow.delivery != null &&
          _orderToShow.delivery.delivery != null;
      if (hasDelivery) {
        if (!hadDelivery) {
          _ordersCubit.initFetchOrderMapState(_orderToShow, true);
        }
        _ordersCubit
            .initFetchLocationUpdates(_orderToShow.delivery.delivery.id);
      }

      if (state is OrderMapLoadedState && _myMapStateKey.currentState != null)
        _myMapStateKey.currentState.buildWith(state.mapData);
      if (state is DeliveryLocationUpdatedState &&
          _myMapStateKey.currentState != null)
        _myMapStateKey.currentState
            .updateMarkerLocation("marker_delivery", state.latLng);
    }, buildWhen: (previousState, state) {
      return state is OrderRequestUpdatedState || state is OrdersUpdatedState;
    }, builder: (context, state) {
      return WillPopScope(
          child: Scaffold(
              backgroundColor: kWhiteColor,
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(80.0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 25.0),
                    child: AppBar(
                        iconTheme: IconThemeData(color: _theme.primaryColor),
                        title: Text(
                          "${_locale.getTranslationOf("order_id")} #${_orderToShow.id}",
                          style: _theme.textTheme.headline5
                              .copyWith(color: Colors.black),
                        )),
                  )),
              body: Column(children: <Widget>[
                ListTile(
                  leading: Image.asset(
                      _orderToShow.meta.order_category == 'courier'
                          ? 'images/home1.png'
                          : _orderToShow.meta.order_category == 'food'
                              ? 'images/home2.png'
                              : 'images/home3.png',
                      height: 34.3,
                      width: 39.3),
                  title: Text(
                      _orderToShow.orderType == 'courier'
                          ? _orderToShow.meta.courier_type
                          : (_orderToShow.meta.order_category ?? "")
                              .capitalize(),
                      style: _theme.textTheme.bodyText1
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text(
                    _orderToShow.deliveryMode?.title ?? "",
                    style: _theme.textTheme.caption.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _theme.hintColor,
                    ),
                  ),
                  trailing: getTrailingContainer(),
                ),
                SizedBox(height: 10.0),
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(40)),
                    child: MyMapWidget(
                      _myMapStateKey,
                      MyMapData(
                          LatLng(
                              _orderToShow.status == "accepted"
                                  ? _orderToShow.address.latitude
                                  : _orderToShow.sourceAddress.latitude,
                              _orderToShow.status == "accepted"
                                  ? _orderToShow.address.longitude
                                  : _orderToShow.sourceAddress.longitude),
                          Set(),
                          Set(),
                          true),
                    ),
                  ),
                )
              ]),
              bottomSheet: SolidBottomSheet(
                key: _bottomSheetWidgetKey,
                maxHeight: 350,
                onShow: () {
                  if (!_isBottomSheetOpen)
                    setState(() => _isBottomSheetOpen = true);
                },
                onHide: () {
                  if (_isBottomSheetOpen)
                    setState(() => _isBottomSheetOpen = false);
                },
                headerBar: _getBottomHeader(),
                body: _getBottomBody(),
              )),
          onWillPop: onBackPressed);
    });
  }

  _getBottomHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [boxShadow],
              color: kWhiteColor,
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            child: ListTile(
              title: Text(
                _locale.getDir,
                style: _theme.textTheme.headline6.copyWith(
                  color: _theme.primaryColorDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(_locale.openmap,
                  style: _theme.textTheme.caption.copyWith(
                      color: _theme.hintColor, fontWeight: FontWeight.bold)),
              trailing: GestureDetector(
                onTap: () => Helper.launchMapsUrl(
                    LatLng(_orderToShow.sourceAddress.latitude,
                        _orderToShow.sourceAddress.longitude),
                    LatLng(_orderToShow.address.latitude,
                        _orderToShow.address.longitude),
                    _orderToShow.sourceAddress.name,
                    _orderToShow.address.name),
                child: CircleAvatar(
                  radius: 25.0,
                  backgroundColor: _theme.primaryColor,
                  child: Icon(
                    Icons.navigation,
                    color: kWhiteColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            decoration: BoxDecoration(
              boxShadow: [boxShadow],
              color: kWhiteColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(30.0),
                topRight: const Radius.circular(30.0),
              ),
            ),
            child: ListTile(
              leading: Icon(Icons.location_on, color: kMainColor),
              title: RichText(
                text: TextSpan(
                  children: [
                    // TextSpan(
                    //   text: 'Walmart' + '\n',
                    //   style: _theme.textTheme.subtitle2.copyWith(
                    //       color: _theme.hintColor.withOpacity(0.7)),
                    // ),
                    TextSpan(
                      text: _orderToShow.sourceAddress.name,
                      style: _theme.textTheme.headline6.copyWith(
                          color: _theme.primaryColorDark, height: 1.5),
                    ),
                  ],
                ),
              ),
              subtitle: Text(
                _orderToShow.sourceAddress.formattedAddress,
                style: _theme.textTheme.bodyText1.copyWith(height: 1.5),
              ),
              trailing: GestureDetector(
                onTap: () async {
                  bool success = await Helper.launchUrl(
                      "tel:${_orderToShow.sourceAddress.mobile}");
                  if (!success)
                    Toaster.showToastBottom(
                        "${AppLocalizations.of(context).getTranslationOf("unable_dial")}: ${_orderToShow.sourceAddress.mobile}");
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: _theme.primaryColor,
                      ),
                      shape: BoxShape.circle),
                  child: Icon(
                    Icons.phone,
                    color: _theme.primaryColor,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _getBottomBody() {
    var boxDecoration = BoxDecoration(
      boxShadow: [boxShadow],
      color: kWhiteColor,
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
    );

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              decoration: BoxDecoration(
                boxShadow: [boxShadow],
                color: kWhiteColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(30.0),
                  bottomRight: const Radius.circular(30.0),
                ),
              ),
              child: ListTile(
                leading: Icon(Icons.navigation, color: kMainColor),
                title: RichText(
                  text: TextSpan(
                    children: [
                      // TextSpan(
                      //   text: 'City Garden' + '\n',
                      //   style: _theme.textTheme.subtitle2.copyWith(
                      //       color: _theme.hintColor.withOpacity(0.7)),
                      // ),
                      TextSpan(
                        text: _orderToShow.address.name,
                        style: _theme.textTheme.headline6.copyWith(
                            color: _theme.primaryColorDark, height: 1.5),
                      ),
                    ],
                  ),
                ),
                subtitle: Text(
                  _orderToShow.address.formattedAddress,
                  style: _theme.textTheme.bodyText1.copyWith(height: 1.5),
                ),
                trailing: GestureDetector(
                  onTap: () async {
                    bool success = await Helper.launchUrl(
                        "tel:${_orderToShow.address.mobile}");
                    if (!success)
                      Toaster.showToastBottom(
                          "${AppLocalizations.of(context).getTranslationOf("unable_dial")}: ${_orderToShow.address.mobile}");
                  },
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                        border: Border.all(color: _theme.primaryColor),
                        shape: BoxShape.circle),
                    child: Icon(
                      Icons.phone,
                      color: _theme.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.all(20),
              decoration: boxDecoration,
              child: _orderToShow.meta.order_category == 'courier'
                  ? Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: _locale.courierType + '\n',
                                    style: _theme.textTheme.subtitle2.copyWith(
                                      color: _theme.hintColor.withOpacity(0.7),
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        _orderToShow.meta.courier_type ?? 'Nil',
                                    style: _theme.textTheme.bodyText1
                                        .copyWith(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: _locale.frangible + '\n',
                                    style: _theme.textTheme.subtitle2.copyWith(
                                      color: _theme.hintColor.withOpacity(0.7),
                                    ),
                                  ),
                                  TextSpan(
                                    text: _locale.getTranslationOf(
                                        (_orderToShow.meta.frangible)
                                            ? 'yes'
                                            : 'no'),
                                    style: _theme.textTheme.bodyText1
                                        .copyWith(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: _locale.height +
                                          ' ' +
                                          _locale.width +
                                          ' ' +
                                          _locale.length +
                                          '\n',
                                      style: _theme.textTheme.subtitle2
                                          .copyWith(
                                              color: _theme.hintColor
                                                  .withOpacity(0.7))),
                                  TextSpan(
                                      text: _orderToShow.meta.lwh ??
                                          'Nil' + ' (cm)',
                                      style: _theme.textTheme.bodyText1
                                          .copyWith(fontSize: 16))
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: _locale.weight + '\n',
                                      style: _theme.textTheme.subtitle2
                                          .copyWith(
                                              color: _theme.hintColor
                                                  .withOpacity(0.7))),
                                  TextSpan(
                                    text: _orderToShow.meta.weight ??
                                        'Nil' + ' kg',
                                    style: _theme.textTheme.bodyText1
                                        .copyWith(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: _locale.courierInfo + '\n',
                                    style: _theme.textTheme.subtitle2.copyWith(
                                      color: _theme.hintColor.withOpacity(0.7),
                                    ),
                                  ),
                                  TextSpan(
                                    text: _orderToShow.notes ?? 'Nil',
                                    style: _theme.textTheme.bodyText1
                                        .copyWith(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              _locale.getTranslationOf("food_items"),
                              style: _theme.textTheme.subtitle2.copyWith(
                                color: _theme.hintColor.withOpacity(0.7),
                              ),
                            ),
                            Spacer(),
                            Text(
                              _locale.getTranslationOf("quantity"),
                              style: _theme.textTheme.subtitle2.copyWith(
                                color: _theme.hintColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: _orderToShow.meta.foodItems?.length ?? 0,
                            itemBuilder: (context, index) {
                              return Row(children: [
                                Text(
                                  widget
                                      .orderData.meta.foodItems[index].itemName,
                                  style: _theme.textTheme.bodyText1
                                      .copyWith(fontSize: 16),
                                ),
                                Spacer(),
                                Text(
                                  widget
                                      .orderData.meta.foodItems[index].quantity,
                                  style: _theme.textTheme.bodyText1
                                      .copyWith(fontSize: 16),
                                ),
                              ]);
                            }),
                        SizedBox(height: 16),
                        if (_orderToShow.notes != null &&
                            _orderToShow.notes.isNotEmpty)
                          Text(
                            _locale.getTranslationOf("additional_info"),
                            style: _theme.textTheme.subtitle2.copyWith(
                              color: _theme.hintColor.withOpacity(0.7),
                            ),
                          ),
                        if (_orderToShow.notes != null &&
                            _orderToShow.notes.isNotEmpty)
                          Text(
                            _orderToShow.notes ?? 'None',
                            style: _theme.textTheme.bodyText1
                                .copyWith(fontSize: 16),
                          ),
                      ],
                    ),
            ),
            SizedBox(height: 10.0),
            Container(
              decoration: boxDecoration,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                title: Text(
                  _orderToShow.deliveryMode?.title ?? "",
                  style: _theme.textTheme.bodyText1,
                ),
                subtitle: Text(
                  "${_orderToShow.payment?.paymentMethod?.title ?? _locale.getTranslationOf('unknown')}",
                  style: _theme.textTheme.subtitle2
                      .copyWith(color: Color(0xffc2c2c2), fontSize: 11.7),
                ),
                trailing: Text(
                  Helper().getSettingValue("currency_icon") +
                          _orderToShow.deliveryMode?.price.toString() ??
                      "",
                  style: _theme.textTheme.headline6
                      .copyWith(color: _theme.primaryColorDark),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> onBackPressed() async {
    // You can do some work here.
    // Returning true allows _the pop to happen, returning false prevents it.
    if (_bottomSheetWidgetKey != null &&
        _bottomSheetWidgetKey.currentState != null) {
      if (_bottomSheetWidgetKey.currentState.isOpened) {
        _bottomSheetWidgetKey.currentState.hide();
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  getTrailingContainer() {
    return (_deliveryRequestToShow != null &&
            !_deliveryRequestToShow.isComplete())
        ? Container(
            width: 120,
            child: Row(children: [
              Container(
                  height: 36,
                  width: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xffF14632),
                      borderRadius: BorderRadius.circular(4)),
                  child: GestureDetector(
                      onTap: () => _confirmUpdateRequest(
                          _deliveryRequestToShow, "rejected"),
                      child: Icon(Icons.close, color: _theme.backgroundColor))),
              SizedBox(width: 4),
              Expanded(
                  child: GestureDetector(
                      onTap: () => _confirmUpdateRequest(
                          _deliveryRequestToShow, "accepted"),
                      child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: Color(0xff79DB17),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                              child: Text(
                            _locale.accept,
                            style: _theme.textTheme.caption
                                .copyWith(color: _theme.backgroundColor),
                          )))))
            ]))
        : GestureDetector(
            onTap: () {
              if (_orderToShow.statusToUpdate != null) {
                if (_orderToShow.statusToUpdate == "dispatched") {
                  showModalBottomSheet(
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(35.0)),
                              borderSide: BorderSide.none),
                          context: context,
                          builder: (context) => TimePickerSheet("delivery"))
                      .then((value) {
                    if (value != null && value is PickerTime) {
                      BlocProvider.of<OrdersCubit>(context)
                        ..initUpdateOrder(
                            _orderToShow, _orderToShow.statusToUpdate, value);
                    } else {
                      Toaster.showToastBottom(
                          _locale.getTranslationOf("time_picker_title_pickup"));
                    }
                  });
                } else {
                  BlocProvider.of<OrdersCubit>(context)
                    ..initUpdateOrder(
                        _orderToShow, _orderToShow.statusToUpdate);
                }
              }
            },
            child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: _orderToShow.getStatusToShow() ==
                            "order_status_action_accepted"
                        ? Color(0xff6E85FE)
                        : _theme.primaryColor),
                child: Text(
                    _locale.getTranslationOf(_orderToShow.getStatusToShow()),
                    style: _theme.textTheme.caption.copyWith(
                        fontWeight: FontWeight.bold, color: kWhiteColor))),
          );
  }

  void _confirmUpdateRequest(DeliveryRequest request, String status) async {
    if (await confirm(context,
        title: Text(_locale.getTranslationOf("request_action_title_" + status)),
        content:
            Text(_locale.getTranslationOf("request_action_message_" + status)),
        textOK: Text(_locale.getTranslationOf("yes")),
        textCancel: Text(_locale.getTranslationOf("no")))) {
      if (status == "accepted") {
        showModalBottomSheet(
            shape: OutlineInputBorder(
                borderRadius:
                    BorderRadius.only(topRight: Radius.circular(35.0)),
                borderSide: BorderSide.none),
            context: context,
            builder: (context) => TimePickerSheet("pickup")).then((value) {
          if (value != null && value is PickerTime) {
            BlocProvider.of<OrdersCubit>(context)
              ..initUpdateOrderRequest(request.id, status, value);
          } else {
            Toaster.showToastBottom(
                _locale.getTranslationOf("time_picker_title_pickup"));
          }
        });
      } else {
        BlocProvider.of<OrdersCubit>(context)
          ..initUpdateOrderRequest(request.id, status);
      }
      print('pressedOK');
    } else {
      print('pressedCancel');
    }
  }

  showLoader() {
    if (!_isLoaderShowing) {
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return Center(
              child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.yellow[600])));
        },
      );
      _isLoaderShowing = true;
    }
  }

  dismissLoader() {
    if (_isLoaderShowing) {
      Navigator.of(context).pop();
      _isLoaderShowing = false;
    }
  }
}
