import 'package:courieronedelivery/BottomNavigation/Account/my_profile_page.dart';
import 'package:courieronedelivery/BottomNavigation/bottom_navigation.dart';
import 'package:courieronedelivery/Locale/locales.dart';
import 'package:courieronedelivery/components/toaster.dart';
import 'package:courieronedelivery/second_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'BlocAuth/auth_bloc.dart';
import 'BlocAuth/auth_event.dart';
import 'BlocCheckVerify/check_verify_bloc.dart';
import 'BlocCheckVerify/check_verify_event.dart';
import 'BlocCheckVerify/check_verify_state.dart';

class CheckVerify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckVerifyBloc>(
      create: (context) => CheckVerifyBloc()..add(GetProfileEvent()),
      child: BlocConsumer<CheckVerifyBloc, CheckVerifyState>(
        listener: (context, state) {
          if (state is FailureVerifyState) {
            Toaster.showToastBottom(AppLocalizations.of(context)
                .getTranslationOf("profile_logged_out"));
            BlocProvider.of<AuthBloc>(context)
                .add(AuthChanged(clearAuth: true));
          }
        },
        builder: (context, state) {
          if (state is VerifiedState) {
            return BottomNavigationPage();
          } else if (state is NotVerifiedState) {
            return MyProfilePage(state.deliveryProfile);
          } else {
            return SecondSplashScreen();
          }
        },
      ),
    );
  }
}
