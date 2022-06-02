import 'package:courieronedelivery/BottomNavigation/MyDeliveries/delivered.dart';
import 'package:courieronedelivery/BottomNavigation/MyDeliveries/new_deliveries.dart';
import 'package:courieronedelivery/BottomNavigation/bloc/orders_cubit.dart';
import 'package:courieronedelivery/Locale/locales.dart';
import 'package:courieronedelivery/Theme/colors.dart';
import 'package:courieronedelivery/models/DeliveryRequest/Get/delivery_profile.dart';
import 'package:courieronedelivery/models/Order/order_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MyDeliveriesInteractor {
  void onOrderCompleted(OrderData orderData);

  void onRefreshedProfileState(DeliveryProfile deliveryProfile);
}

class MyDeliveriesPage extends StatelessWidget
    implements MyDeliveriesInteractor {
  final GlobalKey<DeliveredPageState> _deliveredWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 8),
            child: AppBar(
              centerTitle: true,
              bottom: TabBar(
                labelStyle: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: locale.newDeliveries),
                  Tab(text: locale.delivered),
                ],
                isScrollable: true,
                labelColor: kTextColor,
                unselectedLabelColor: Color(0xff80fff9e9),
                indicatorPadding: EdgeInsets.symmetric(horizontal: 24.0),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            BlocProvider<OrdersCubit>(
                create: (context) => OrdersCubit(),
                child: NewDeliveriesPage(this)),
            BlocProvider<OrdersCubit>(
                create: (context) => OrdersCubit(),
                child: DeliveredPage(_deliveredWidgetKey)),
          ],
        ),
      ),
    );
  }

  @override
  void onRefreshedProfileState(DeliveryProfile deliveryProfile) {
    if (_deliveredWidgetKey != null && _deliveredWidgetKey.currentState != null)
      _deliveredWidgetKey.currentState.onProfileRefresh(deliveryProfile);
  }

  @override
  void onOrderCompleted(OrderData orderData) {
    if (_deliveredWidgetKey != null && _deliveredWidgetKey.currentState != null)
      _deliveredWidgetKey.currentState.addOrder(orderData);
  }
}
