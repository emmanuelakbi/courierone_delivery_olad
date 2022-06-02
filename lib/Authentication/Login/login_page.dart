import 'package:country_code_picker/country_code_picker.dart';
import 'package:courieronedelivery/Authentication/login_navigator.dart';
import 'package:courieronedelivery/components/continue_button.dart';
import 'package:courieronedelivery/components/entry_field.dart';
import 'package:courieronedelivery/Locale/locales.dart';
import 'package:courieronedelivery/components/toaster.dart';
import 'package:courieronedelivery/config/app_config.dart';
import 'package:courieronedelivery/models/Auth/auth_request_register.dart';
import 'package:courieronedelivery/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/login_cubit.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback onRegistrationDone;

  LoginPage(this.onRegistrationDone);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: LoginBody(onRegistrationDone),
    );
  }
}

class LoginBody extends StatefulWidget {
  final VoidCallback onRegistrationDone;

  LoginBody(this.onRegistrationDone);

  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  LoginCubit _loginCubit;
  String _isoCode, _dialCode;
  bool isLoaderShowing = false;

  @override
  void initState() {
    super.initState();
    _loginCubit = context.read<LoginCubit>();
    if (AppConfig.isDemoMode) {
      _isoCode = "IN";
      _dialCode = "+91";
      _controller.text = "7676767676";
      _countryController.text = "India";

      Future.delayed(
          Duration(seconds: 1),
          () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)
                      .getTranslationOf("demo_login_title")),
                  content: Text(AppLocalizations.of(context)
                      .getTranslationOf("demo_login_message")),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(AppLocalizations.of(context)
                          .getTranslationOf("okay")),
                      textColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Theme.of(context).backgroundColor)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                );
              }));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Text(
                    AppConfig.appName,
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(color: Theme.of(context).backgroundColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is LoginLoading) {
                      showLoader();
                    } else {
                      dismissLoader();
                    }
                    if (state is LoginLoaded) {
                      gotoHome();
                    } else if (state is LoginExistsLoaded) {
                      if (state.isRegistered) {
                        gotoVerification(
                            state.phoneNumber.normalizedPhoneNumber);
                      } else {
                        gotoRegistration(AuthRequestRegister("", "", "",
                            state.phoneNumber.normalizedPhoneNumber, ""));
                      }
                    } else if (state is LoginErrorSocial) {
                      if (state.loginName.isNotEmpty &&
                          state.loginEmail.isNotEmpty) {
                        Toaster.showToastBottom(AppLocalizations.of(context)
                            .getTranslationOf(state.messageKey));
                        gotoRegistration(AuthRequestRegister(state.loginName,
                            state.loginEmail, "", "", state.loginImageUrl));
                      } else {
                        Toaster.showToastBottom(AppLocalizations.of(context)
                            .getTranslationOf("something_wrong"));
                      }
                      print("login_error_social: $state");
                    } else if (state is LoginError) {
                      Toaster.showToastBottom(AppLocalizations.of(context)
                          .getTranslationOf(state.messageKey));
                      print("login_error: $state");
                    }
                  },
                  builder: (context, state) {
                    return Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.backgroundColor,
                            borderRadius: BorderRadiusDirectional.only(
                              topStart: Radius.circular(35.0),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(height: 32.0),
                                Text(
                                  locale.signIn,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headline5
                                      .copyWith(color: theme.hoverColor),
                                ),
                                SizedBox(height: 24.0),
                                Stack(children: [
                                  EntryField(
                                    controller: _countryController,
                                    label: locale.countryText,
                                    hint: locale.selectCountryFromList,
                                    suffixIcon: Icons.arrow_drop_down,
                                    readOnly: true,
                                  ),
                                  Positioned(
                                      top: 24,
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 56,
                                          child: CountryCodePicker(
                                              alignLeft: true,
                                              padding: EdgeInsets.zero,
                                              onChanged: (value) =>
                                                  setState(() {
                                                    _dialCode = value.dialCode;
                                                    _isoCode = value.code;
                                                    _countryController.text =
                                                        value.name ?? "";
                                                    _controller.clear();
                                                  }),
                                              initialSelection:
                                                  _isoCode ?? '+1',
                                              hideMainText: true,
                                              showFlag: false,
                                              showFlagDialog: true,
                                              favorite: ['+91', 'US'])))
                                ]),
                                EntryField(
                                  controller: _controller,
                                  label: locale.phoneText,
                                  hint: (_dialCode != null &&
                                          _dialCode.isNotEmpty)
                                      ? "${locale.getTranslationOf("phoneHintExcluding")} $_dialCode"
                                      : locale.getTranslationOf("phoneHint"),
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(height: 16.0),
                                CustomButton(
                                    radius: BorderRadius.only(
                                        topLeft: Radius.circular(35.0),
                                        bottomRight: Radius.circular(35.0)),
                                    onPressed: () => loginWithMobile(
                                          _dialCode,
                                          Helper.formatPhone(
                                              _controller.text.trim()),
                                        )),
                                SizedBox(height: 20.0),
                                Text('\n' + locale.signinOTP,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.subtitle1),
                                SizedBox(height: 30),
                                // Text(
                                //   locale.orContinue,
                                //   textAlign: TextAlign.center,
                                //   style: theme.textTheme.headline5
                                //       .copyWith(color: theme.hoverColor),
                                // ),
                                // SizedBox(height: 350)
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            // Positioned(
            //     bottom: 0,
            //     left: 0,
            //     right: 0,
            //     child: Row(
            //       children: <Widget>[
            //         // Expanded(
            //         //   child: CustomButton(
            //         //     text: locale.facebook,
            //         //     padding: 14.0,
            //         //     color: Color(0xff3b45c1),
            //         //     onPressed: () => loginWithFacebook(),
            //         //   ),
            //         // ),
            //         Expanded(
            //           child: CustomButton(
            //             text: locale.google,
            //             padding: 14.0,
            //             color: Color(0xffff452c),
            //             onPressed: () => loginWithGoogle(),
            //           ),
            //         ),
            //       ],
            //     ))
          ],
        ),
      ),
    );
  }

  showLoader() {
    if (!isLoaderShowing) {
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.red),
          ));
        },
      );
      isLoaderShowing = true;
    }
  }

  dismissLoader() {
    if (isLoaderShowing) {
      Navigator.of(context).pop();
      isLoaderShowing = false;
    }
  }

  void gotoVerification(String phoneNumber) {
    Navigator.pushNamed(context, LoginRoutes.verification,
        arguments: phoneNumber);
  }

  void gotoRegistration(AuthRequestRegister authRequestRegister) {
    Navigator.pushNamed(context, LoginRoutes.signUp, arguments: [
      authRequestRegister,
      _isoCode,
      _dialCode,
      _countryController.text,
      _controller.text
    ]);
  }

  void gotoHome() {
    widget.onRegistrationDone();
  }

  // void loginWithFacebook() {
  //   _loginCubit.initLoginFacebook();
  // }

  // void loginWithGoogle() {
  //   _loginCubit.initLoginGoogle();
  // }

  void loginWithMobile(String dialCode, String mobileNumber) {
    _loginCubit.initLoginPhone(dialCode, mobileNumber);
  }
}
