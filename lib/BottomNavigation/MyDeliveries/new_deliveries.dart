import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:courieronedelivery/BottomNavigation/MyDeliveries/my_deliveries.dart';
import 'package:courieronedelivery/BottomNavigation/bloc/map_event.dart';
import 'package:courieronedelivery/BottomNavigation/bloc/delivery_profile_bloc.dart';
import 'package:courieronedelivery/BottomNavigation/bloc/map_state.dart';
import 'package:courieronedelivery/BottomNavigation/bloc/orders_cubit.dart';
import 'package:courieronedelivery/Pages/delivery_info.dart';
import 'package:courieronedelivery/components/error_final_widget.dart';
import 'package:courieronedelivery/components/time_picker_sheet.dart';
import 'package:courieronedelivery/components/toaster.dart';
import 'package:courieronedelivery/Locale/locales.dart';
import 'package:courieronedelivery/UtilityFunctions/string_extension.dart';
import 'package:courieronedelivery/Theme/style.dart';
import 'package:courieronedelivery/models/DeliveryRequest/Get/delivery_profile.dart';
import 'package:courieronedelivery/models/DeliveryRequest/Get/delivery_request.dart';
import 'package:courieronedelivery/models/Order/order_data.dart';
import 'package:courieronedelivery/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';

class NewDeliveriesPage extends StatefulWidget {
  final MyDeliveriesInteractor _myDeliveriesInteractor;

  NewDeliveriesPage(this._myDeliveriesInteractor);

  @override
  _NewDeliveriesPageState createState() => _NewDeliveriesPageState();
}

class _NewDeliveriesPageState extends State<NewDeliveriesPage>
    with AutomaticKeepAliveClientMixin {
  DeliveryProfile _deliveryProfile;
  DeliveryRequest _deliveryRequest;
  List<OrderData> _orders;
  int _pageNum = 1;
  bool _allDone = false;
  bool _isLoading = true;
  bool _isOffline = false;
  bool _triggeredPagination = false;
  bool _isLoaderShowing = false;

  ThemeData _theme;
  AppLocalizations _locale;
  String _currencyIcon;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _theme = Theme.of(context);
    _locale = AppLocalizations.of(context);
    _currencyIcon = Helper().getSettingValue("currency_icon");
    return MultiBlocListener(
      listeners: [
        BlocListener<DeliveryProfileBloc, DeliveryProfileState>(
            listener: (context, state) {
          if (state is RefreshedProfileState) {
            widget._myDeliveriesInteractor
                .onRefreshedProfileState(state.deliveryProfile);
            if (_deliveryProfile == null ||
                _deliveryProfile.isOnline != state.deliveryProfile.isOnline) {
              _deliveryProfile = state.deliveryProfile;
              _orders = null;
              BlocProvider.of<OrdersCubit>(context)
                  .initFetchOrdersActive(_deliveryProfile, 1);
            }
          }
        }),
        BlocListener<OrdersCubit, OrdersState>(listener: (context, state) {
          _isOffline = state is OrdersOfflineState;
          _isLoading = state is OrdersLoadingState;
          if (state is OrdersActiveState) {
            if (state.orders != null) {
              _pageNum = state.orders.meta.current_page;
              _allDone =
                  state.orders.meta.current_page == state.orders.meta.last_page;
              if (_orders == null || _pageNum == 1)
                _orders = state.orders.data;
              else
                _orders.addAll(state.orders.data);
            }

            if (state.deliveryRequest != null) {
              _deliveryRequest = state.deliveryRequest;
            }
          }

          //from firebase
          if (state is OrderRequestLoadedState) {
            _deliveryRequest = state.deliveryRequest;
          }

          //updating progress management
          if (state is OrdersUpdatingState)
            showLoader();
          else
            dismissLoader();

          //updated status management
          if (state is OrderRequestUpdatedState) {
            _onOrderRequestUpdate(state.deliveryRequest);
          } else if (state is OrdersUpdateFailState) {
            Toaster.showToastBottom(_locale.getTranslationOf(state.keyError));
          }

          //updated orders management
          if (state is OrdersUpdatedState &&
              _orders != null &&
              _orders.isNotEmpty) {
            _updateOrderInList(state.orderData);
          }

          setState(() {});
        })
      ],
      child: FocusDetector(
        onFocusGained: () async {
          DeliveryRequest deliveryRequest =
              await Helper().getTempOrderRequest();
          OrderData orderData = await Helper().getTempOrder();
          if (deliveryRequest != null) {
            _onOrderRequestUpdate(deliveryRequest);
          } else if (orderData != null) {
            if (_orders != null && _orders.isNotEmpty) {
              _updateOrderInList(orderData);
            }
          }
          await Helper().setTempOrderRequest(null);
          await Helper().setTempOrder(null);
        },
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: borderRadius, color: _theme.cardColor),
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: getMainChild(context),
          ),
        ),
      ),
    );
  }

  Widget getMainChild(BuildContext context) {
    if (_isOffline) {
      return ErrorFinalWidget.errorWithRetry(
        context,
        AppLocalizations.of(context).getTranslationOf("you_offline"),
        AppLocalizations.of(context).getTranslationOf("go_online"),
        (context) => BlocProvider.of<DeliveryProfileBloc>(context)
          ..add(ProfileToggleOnlineEvent()),
      );
    } else if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellow[600]),
        ),
      );
    } else {
      if (_deliveryRequest == null && (_orders == null || _orders.isEmpty))
        return ErrorFinalWidget.errorWithRetry(
            context,
            AppLocalizations.of(context)
                .getTranslationOf("empty_deliveries_active"),
            AppLocalizations.of(context).getTranslationOf("retry"),
            (context) => BlocProvider.of<OrdersCubit>(context)
              ..initFetchOrdersActive(
                _deliveryProfile,
                1,
              ));
      else
        return RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<OrdersCubit>(context)
                .initFetchOrdersActive(_deliveryProfile, 1);
          },
          child: ListView(
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  (_orders != null && _orders.isNotEmpty)
                      ? "${_orders.length} ${_locale.activeDeliv}"
                      : "0 ${_locale.activeDeliv}",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              if (_deliveryRequest != null)
                buildCardOrderRequest(context, _deliveryRequest),
              if (_orders != null && _orders.isNotEmpty)
                ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _orders.length,
                    itemBuilder: (context, index) {
                      if (_orders != null && _orders.isNotEmpty) {
                        if (index == _orders.length - 1) {
                          _triggerPagination(context);
                        }
                      }
                      return buildCardOrder(context, _orders[index]);
                    }),
              SizedBox(height: 64.0)
            ],
          ),
        );
    }
  }

  Widget buildCardOrderRequest(BuildContext context, DeliveryRequest request) {
    return Container(
        decoration: BoxDecoration(
            boxShadow: [boxShadow],
            borderRadius: BorderRadius.circular(10.0),
            color: _theme.backgroundColor),
        margin: EdgeInsets.only(bottom: 8),
        child: Column(children: <Widget>[
          ListTile(
            leading: Image.asset(
                request.order.meta.order_category == 'courier'
                    ? 'images/home1.png'
                    : request.order.meta.order_category == 'food'
                        ? 'images/home2.png'
                        : 'images/home3.png',
                scale: 4.2),
            title: Text((request.order.meta.order_category ?? "").capitalize(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Text(request.order.deliveryMode?.title ?? "",
                style: Theme.of(context).textTheme.caption.copyWith(
                    color: _theme.hintColor, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis),
            trailing: Container(
              width: 120,
              child: Row(
                children: [
                  Container(
                      height: 36,
                      width: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xffF14632),
                          borderRadius: BorderRadius.circular(4)),
                      child: GestureDetector(
                          onTap: () =>
                              _confirmUpdateRequest(request, "rejected"),
                          child: Icon(Icons.close,
                              color: _theme.backgroundColor))),
                  SizedBox(width: 4),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _confirmUpdateRequest(request, "accepted"),
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
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DeliveryInfoPage(request.order, request))),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 80.0),
                  Expanded(
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: _locale.paymentMode + '\n',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(
                                      color: _theme.hintColor,
                                      fontWeight: FontWeight.bold)),
                          TextSpan(
                            text:
                                "${request.order.payment?.paymentMethod?.title ?? _locale.getTranslationOf('unknown')} \n",
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                      ),
                    ),
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: _locale.payment + '\n',
                        style: Theme.of(context).textTheme.caption.copyWith(
                            color: _theme.hintColor,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                      text:
                          _currencyIcon + request.order.total.toString() + '\n',
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ])),
                  SizedBox(width: 88.0)
                ]),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DeliveryInfoPage(request.order, request))),
            child: Container(
                height: 48,
                decoration: BoxDecoration(
                    color: Color(0xfffafafa),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                          child: Text(
                              (request.order.sourceAddress.name ??
                                      AppLocalizations.of(context)
                                          .getTranslationOf("no_name"))
                                  .capitalize(),
                              overflow: TextOverflow.ellipsis,
                              style: _theme.textTheme.caption
                                  .copyWith(fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center)),
                      Icon(Icons.location_on,
                          color: _theme.primaryColor, size: 21.0),
                      Text("  •••••••  ",
                          style: _theme.textTheme.caption.copyWith(
                              color: _theme.hoverColor.withOpacity(0.7))),
                      Icon(Icons.navigation,
                          color: _theme.primaryColor, size: 21.0),
                      Expanded(
                          child: Text(
                              (request.order.address.name ??
                                      AppLocalizations.of(context)
                                          .getTranslationOf("no_name"))
                                  .capitalize(),
                              overflow: TextOverflow.ellipsis,
                              style: _theme.textTheme.caption
                                  .copyWith(fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center))
                    ])),
          )
        ]));
  }

  Widget buildCardOrder(BuildContext context, OrderData orderData) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [boxShadow],
          borderRadius: BorderRadius.circular(10.0),
          color: _theme.backgroundColor),
      margin: EdgeInsets.only(bottom: 8),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Image.asset(
                orderData.meta.order_category == 'courier'
                    ? 'images/home1.png'
                    : orderData.meta.order_category == 'food'
                        ? 'images/home2.png'
                        : 'images/home3.png',
                scale: 4.2),
            title: Text((orderData.meta.order_category ?? "").capitalize(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Text(orderData.deliveryMode?.title ?? "",
                style: Theme.of(context).textTheme.caption.copyWith(
                    color: _theme.hintColor, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis),
            trailing: GestureDetector(
              onTap: () {
                if (orderData.statusToUpdate != null) {
                  if (orderData.statusToUpdate == "dispatched") {
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
                              orderData, orderData.statusToUpdate, value);
                      } else {
                        Toaster.showToastBottom(_locale
                            .getTranslationOf("time_picker_title_pickup"));
                      }
                    });
                  } else {
                    BlocProvider.of<OrdersCubit>(context)
                      ..initUpdateOrder(orderData, orderData.statusToUpdate);
                  }
                }
              },
              child: Container(
                height: 36,
                width: 120,
                decoration: BoxDecoration(
                    color: orderData.getStatusToShow() ==
                            "order_status_action_accepted"
                        ? Color(0xff6E85FE)
                        : _theme.primaryColor,
                    borderRadius: BorderRadius.circular(4)),
                child: Center(
                  child: Text(
                    _locale.getTranslationOf(orderData.getStatusToShow()),
                    style: _theme.textTheme.caption.copyWith(
                      color: _theme.backgroundColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DeliveryInfoPage(orderData))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 80.0),
                Expanded(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: _locale.paymentMode + '\n',
                            style: Theme.of(context).textTheme.caption.copyWith(
                                color: _theme.hintColor,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                          text:
                              "${orderData.payment?.paymentMethod?.title ?? _locale.getTranslationOf('unknown')} \n",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: _locale.payment + '\n',
                          style: Theme.of(context).textTheme.caption.copyWith(
                              color: _theme.hintColor,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: _currencyIcon + orderData.total.toString() + '\n',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 88.0)
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DeliveryInfoPage(orderData))),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Color(0xfffafafa),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                      child: Text(
                          (orderData.sourceAddress.name ??
                                  AppLocalizations.of(context)
                                      .getTranslationOf("no_name"))
                              .capitalize(),
                          overflow: TextOverflow.ellipsis,
                          style: _theme.textTheme.caption
                              .copyWith(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center)),
                  Icon(Icons.location_on,
                      color: _theme.primaryColor, size: 21.0),
                  Text("  •••••••  ",
                      style: _theme.textTheme.caption
                          .copyWith(color: _theme.hoverColor.withOpacity(0.7))),
                  Icon(Icons.navigation,
                      color: _theme.primaryColor, size: 21.0),
                  Expanded(
                    child: Text(
                      (orderData.address.name ??
                              AppLocalizations.of(context)
                                  .getTranslationOf("no_name"))
                          .capitalize(),
                      overflow: TextOverflow.ellipsis,
                      style: _theme.textTheme.caption
                          .copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _triggerPagination(BuildContext context) {
    if (!_triggeredPagination && !_allDone) {
      BlocProvider.of<OrdersCubit>(context).initFetchOrdersActive(
        _deliveryProfile,
        _pageNum + 1,
      );
      _triggeredPagination = true;
    }
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
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellow[600]),
            ),
          );
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

  void _updateOrderInList(OrderData orderData) {
    int indexToUpdate = -1;
    for (int i = 0; i < _orders.length; i++) {
      if (_orders[i].id == orderData.id) {
        indexToUpdate = i;
        break;
      }
    }
    if (indexToUpdate != -1) {
      if (orderData.isComplete()) {
        widget._myDeliveriesInteractor.onOrderCompleted(orderData);
        _orders.removeAt(indexToUpdate);
      } else {
        _orders[indexToUpdate] = orderData;
      }
    }
  }

  void _onOrderRequestUpdate(DeliveryRequest deliveryRequest) {
    //refresh list when request updates
    _deliveryRequest = null;
    _orders = null;
    BlocProvider.of<OrdersCubit>(context)
      ..initFetchOrdersActive(
        _deliveryProfile,
        1,
      );
  }
}
