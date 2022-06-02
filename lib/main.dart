import 'package:country_code_picker/country_localizations.dart';
import 'package:courieronedelivery/config/one_signal_config.dart';
import 'package:courieronedelivery/language_cubit.dart';
import 'package:courieronedelivery/second_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Authentication/BlocAuth/auth_bloc.dart';
import 'Authentication/BlocAuth/auth_event.dart';
import 'Authentication/BlocAuth/auth_state.dart';
import 'Authentication/check_verify.dart';
import 'Locale/locales.dart';
import 'Theme/style.dart';
import 'bloc_delegate.dart';
import 'package:courieronedelivery/Routes/routes.dart';
import 'package:courieronedelivery/Authentication/login_navigator.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'language_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await OneSignalConfig.initOneSignal();
  Bloc.observer = SimpleBlocDelegate();
  runApp(
    Phoenix(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
              create: (context) => AuthBloc()..add(AppStarted())),
          BlocProvider<LanguageCubit>(
              create: (context) => LanguageCubit()..getCurrentLanguage()),
        ],
        child: CourierOneDelivery(),
      ),
    ),
  );
}

class CourierOneDelivery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) => MaterialApp(
        localizationsDelegates: [
          const AppLocalizationsDelegate(),
          CountryLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: AppLocalizations.getSupportedLocales(),
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        locale: locale,
        home: BlocBuilder<AuthBloc, AuthState>(
            builder: (BuildContext context, state) {
          switch (state.runtimeType) {
            case Initialized:
              return LanguagePage(true);
            case Unauthenticated:
              return LoginNavigator();
            case Authenticated:
              return CheckVerify();
            default:
              return SecondSplashScreen();
          }
        }),
        routes: PageRoutes().routes(),
      ),
    );
  }
}
