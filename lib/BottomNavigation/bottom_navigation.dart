import 'package:courieronedelivery/Authentication/BlocAuth/auth_bloc.dart';
import 'package:courieronedelivery/Authentication/BlocAuth/auth_event.dart';
import 'package:courieronedelivery/BottomNavigation/Account/account_page.dart';
import 'package:courieronedelivery/BottomNavigation/MyDeliveries/my_deliveries.dart';
import 'package:courieronedelivery/BottomNavigation/bloc/delivery_profile_bloc.dart';
import 'package:courieronedelivery/BottomNavigation/bloc/map_event.dart';
import 'package:courieronedelivery/BottomNavigation/bloc/map_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'earnings_page.dart';

class BottomNavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeliveryProfileBloc>(
      create: (context) => DeliveryProfileBloc(),
      child: BottomNavigation(),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  bool isLoaderShowing = false;
  GlobalKey<EarningsBodyState> _earningsBodyKey = GlobalKey();
  List<Widget> _children;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (_earningsBodyKey != null && _earningsBodyKey.currentState != null) {
      if (index == 1) {
        _earningsBodyKey.currentState.refreshWallet();
      } else {
        _earningsBodyKey.currentState.cancelRequests();
      }
    }
  }

  @override
  void initState() {
    _children = <Widget>[
      MyDeliveriesPage(),
      EarningsPage(_earningsBodyKey),
      AccountPage()
    ];
    super.initState();
    BlocProvider.of<DeliveryProfileBloc>(context)..add(RefreshProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> _bottomBarItems = [
      BottomNavigationBarItem(
        icon: Image.asset('images/ic_feeds.png', scale: 3),
        activeIcon: Image.asset('images/ic_feeds_active.png', scale: 3),
        title: SizedBox.shrink(),
      ),
      BottomNavigationBarItem(
        icon: Image.asset('images/ic_home.png', scale: 3),
        activeIcon: Image.asset('images/ic_home_active.png', scale: 3),
        title: SizedBox.shrink(),
      ),
      BottomNavigationBarItem(
        icon: Image.asset('images/ic_profile.png', scale: 3),
        activeIcon: Image.asset('images/ic_profile_active.png', scale: 3),
        title: SizedBox.shrink(),
      ),
    ];
    return BlocListener<DeliveryProfileBloc, DeliveryProfileState>(
      listener: (context, state) {
        if (state is DeliveryProfileLoadingState) {
          showLoader(context);
        } else {
          dismissLoader(context);
        }
        if (state is DeliveryProfileLoggedOutState) {
          BlocProvider.of<AuthBloc>(context).add(AuthChanged(clearAuth: true));
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: _children,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavigationBar(
                items: _bottomBarItems,
                currentIndex: _currentIndex,
                showSelectedLabels: false,
                onTap: (newIndex) => _onItemTapped(newIndex),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showLoader(BuildContext context) {
    if (!isLoaderShowing) {
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
      isLoaderShowing = true;
    }
  }

  dismissLoader(BuildContext context) {
    if (isLoaderShowing) {
      Navigator.of(context).pop();
      isLoaderShowing = false;
    }
  }
}
