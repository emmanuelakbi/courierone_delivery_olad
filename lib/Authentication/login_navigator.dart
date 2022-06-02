import 'package:courieronedelivery/models/Auth/auth_request_register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'BlocAuth/auth_bloc.dart';
import 'BlocAuth/auth_event.dart';
import 'Login/login_page.dart';
import 'Register/register_page.dart';
import 'Verification/verification_page.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class LoginData {
  final String phoneNumber;
  final String country;

  LoginData(this.phoneNumber, this.country);
}

class LoginRoutes {
  static const String root = 'language/';
  static const String signInRoot = 'signIn/';
  static const String signUp = 'login/signUp';
  static const String verification = 'login/verification';
}

class LoginNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var canPop = navigatorKey.currentState.canPop();
        if (canPop) {
          navigatorKey.currentState.pop();
        }
        return !canPop;
      },
      child: Navigator(
        key: navigatorKey,
        initialRoute: LoginRoutes.root,
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case LoginRoutes.root:
              builder = (BuildContext _) {
                return LoginPage(
                  () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                    BlocProvider.of<AuthBloc>(context).add(AuthChanged());
                  },
                );
              };
              break;
            case LoginRoutes.signInRoot:
              builder = (BuildContext _) => LoginPage(() {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                    BlocProvider.of<AuthBloc>(context).add(AuthChanged());
                  });
              break;
            case LoginRoutes.signUp:
              List args = settings.arguments;
              builder = (BuildContext _) => RegisterPage(
                    authRequestRegister: args.first as AuthRequestRegister,
                    isoCode: args.length > 0 ? args[1] as String : "",
                    dialCode: args.length > 0 ? args[2] as String : "",
                    countryText: args.length > 1 ? args[3] as String : "",
                    phoneText: args.length > 2 ? args[4] as String : "",
                  );
              break;
            case LoginRoutes.verification:
              builder = (BuildContext _) =>
                  VerificationPage(settings.arguments as String, () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                    BlocProvider.of<AuthBloc>(context).add(AuthChanged());
                  });
              break;
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
        onPopPage: (Route<dynamic> route, dynamic result) {
          return route.didPop(result);
        },
      ),
    );
  }
}
