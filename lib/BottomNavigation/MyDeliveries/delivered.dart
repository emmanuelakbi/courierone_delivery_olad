import 'package:courieronedelivery/BottomNavigation/bloc/map_event.dart';
import 'package:courieronedelivery/BottomNavigation/bloc/map_state.dart';
import 'package:courieronedelivery/BottomNavigation/bloc/delivery_profile_bloc.dart';
import 'package:courieronedelivery/BottomNavigation/bloc/orders_cubit.dart';
import 'package:courieronedelivery/Pages/delivery_info.dart';
import 'package:courieronedelivery/components/error_final_widget.dart';
import 'package:courieronedelivery/Locale/locales.dart';
import 'package:courieronedelivery/models/DeliveryRequest/Get/delivery_profile.dart';
import 'package:courieronedelivery/models/Order/order_data.dart';
import 'package:courieronedelivery/Theme/style.dart';
import 'package:courieronedelivery/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courieronedelivery/UtilityFunctions/string_extension.dart';

class DeliveredPage extends StatefulWidget {
  DeliveredPage(Key key) : super(key: key);

  @override
  DeliveredPageState createState() => DeliveredPageState();
}

class DeliveredPageState extends State<DeliveredPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  DeliveryProfile _deliveryProfile;
  List<OrderData> _orders;
  int pageNum = 1;
  bool _allDone = false;
  bool _isLoading = false;
  bool _isOffline = false;
  bool _triggeredPagination = false;

  ThemeData theme;
  AppLocalizations locale;
  String currencyIcon;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    theme = Theme.of(context);
    locale = AppLocalizations.of(context);
    currencyIcon = Helper().getSettingValue("currency_icon");

    //for first run. Tab's state doesn't come to life until in focus.
    if (!_isLoading && _deliveryProfile == null) {
      onProfileRefresh(null);
    }

    return BlocConsumer<OrdersCubit, OrdersState>(listener: (context, state) {
      _isOffline = state is OrdersOfflineState;
      _isLoading = state is OrdersLoadingState;
      if (state is OrdersPastState) {
        pageNum = state.orders.meta.current_page;
        _allDone =
            state.orders.meta.current_page == state.orders.meta.last_page;

        if (_orders == null)
          _orders = state.orders.data;
        else
          _orders.addAll(state.orders.data);
      }
    }, builder: (context, state) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          decoration:
              BoxDecoration(borderRadius: borderRadius, color: theme.cardColor),
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: getMainChild(context),
        ),
      );
    });
  }

  Widget getMainChild(BuildContext context) {
    if (_isOffline) {
      return ErrorFinalWidget.errorWithRetry(
          context,
          AppLocalizations.of(context).getTranslationOf("you_offline"),
          AppLocalizations.of(context).getTranslationOf("go_online"),
          (context) => BlocProvider.of<DeliveryProfileBloc>(context)
            ..add(ProfileToggleOnlineEvent()));
    } else if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(Colors.yellow[600])));
    } else {
      if (_orders == null || _orders.isEmpty) {
        return ErrorFinalWidget.errorWithRetry(
            context,
            AppLocalizations.of(context)
                .getTranslationOf("empty_deliveries_past"),
            AppLocalizations.of(context).getTranslationOf("reload"), (context) {
          _orders = null;
          BlocProvider.of<OrdersCubit>(context)
            ..initFetchOrdersPast(_deliveryProfile, 1);
        });
      } else {
        return RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<OrdersCubit>(context)
                .initFetchOrdersPast(_deliveryProfile, 1);
          },
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.only(bottom: 60, top: 24, left: 8, right: 8),
            shrinkWrap: true,
            itemCount: _orders.length,
            itemBuilder: (context, index) {
              if (_orders != null && _orders.isNotEmpty) {
                if (index == _orders.length - 1) {
                  _triggerPagination(context);
                }
              }
              return buildCardOrder(context, _orders[index]);
            },
          ),
        );
      }
    }
  }

  void _triggerPagination(BuildContext context) {
    if (!_triggeredPagination && !_allDone) {
      BlocProvider.of<OrdersCubit>(context)
          .initFetchOrdersPast(_deliveryProfile, pageNum + 1);
      _triggeredPagination = true;
    }
  }

  Widget buildCardOrder(BuildContext context, OrderData orderData) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => DeliveryInfoPage(orderData))),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [boxShadow],
          borderRadius: BorderRadius.circular(10.0),
          color: theme.backgroundColor,
        ),
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
              title: Text(
                (orderData.meta.order_category ?? "").capitalize(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(
                orderData.deliveryMode?.title ?? "",
                style: Theme.of(context).textTheme.caption.copyWith(
                    color: theme.hintColor, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Container(
                height: 36,
                width: 120,
                decoration: BoxDecoration(
                  color: orderData.getStatusToShow() ==
                          "order_status_action_accepted"
                      ? Color(0xff6E85FE)
                      : theme.primaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    locale.getTranslationOf(orderData.getStatusToShow()),
                    style: theme.textTheme.caption
                        .copyWith(color: theme.backgroundColor),
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 80.0),
                Expanded(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(children: [
                      TextSpan(
                        text: locale.paymentMode + '\n',
                        style: Theme.of(context).textTheme.caption.copyWith(
                            color: theme.hintColor,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            "${orderData.payment?.paymentMethod?.title ?? locale.getTranslationOf('unknown')} \n",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ]),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: locale.payment + '\n',
                        style: Theme.of(context).textTheme.caption.copyWith(
                            color: theme.hintColor,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: currencyIcon + orderData.total.toString() + '\n',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 88.0),
              ],
            ),
            Container(
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
                        (orderData.sourceAddress.name ??
                                AppLocalizations.of(context)
                                    .getTranslationOf("no_name"))
                            .capitalize(),
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.caption
                            .copyWith(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Icon(
                      Icons.location_on,
                      color: theme.primaryColor,
                      size: 21.0,
                    ),
                    Text(
                      "  •••••••  ",
                      style: theme.textTheme.caption
                          .copyWith(color: theme.hoverColor.withOpacity(0.7)),
                    ),
                    Icon(
                      Icons.navigation,
                      color: theme.primaryColor,
                      size: 21.0,
                    ),
                    Expanded(
                      child: Text(
                        (orderData.address.name ??
                                AppLocalizations.of(context)
                                    .getTranslationOf("no_name"))
                            .capitalize(),
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.caption
                            .copyWith(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  void addOrder(OrderData orderData) {
    if (_orders == null) _orders = [];
    _orders.insert(0, orderData);
    _isOffline = false;
    _isLoading = false;
    setState(() {});
  }

  void onProfileRefresh(DeliveryProfile deliveryProfile) {
    if (_deliveryProfile == null ||
        _deliveryProfile.isOnline != deliveryProfile.isOnline) {
      _deliveryProfile = deliveryProfile;
      _orders = null;
      _isLoading = true;
      BlocProvider.of<OrdersCubit>(context)
        ..initFetchOrdersPast(_deliveryProfile, 1);
    }
  }
}
