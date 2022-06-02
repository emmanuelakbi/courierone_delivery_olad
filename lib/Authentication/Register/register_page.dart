import 'package:country_code_picker/country_code_picker.dart';
import 'package:courieronedelivery/components/continue_button.dart';
import 'package:courieronedelivery/components/custom_app_bar.dart';
import 'package:courieronedelivery/components/entry_field.dart';
import 'package:courieronedelivery/Locale/locales.dart';
import 'package:courieronedelivery/components/toaster.dart';
import 'package:courieronedelivery/models/Auth/auth_request_register.dart';
import 'package:courieronedelivery/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courieronedelivery/Authentication/login_navigator.dart';
import 'cubit/register_cubit.dart';

class RegisterPage extends StatelessWidget {
  final AuthRequestRegister authRequestRegister;
  final String isoCode, dialCode, countryText, phoneText;

  const RegisterPage(
      {this.authRequestRegister,
      this.isoCode,
      this.dialCode,
      this.countryText,
      this.phoneText});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: RegisterBody(
        authRequestRegister: this.authRequestRegister,
        dialCode: this.dialCode,
        isoCode: this.isoCode,
        countryText: this.countryText,
        phoneText: this.phoneText,
      ),
    );
  }
}

class RegisterBody extends StatefulWidget {
  final AuthRequestRegister authRequestRegister;
  final String isoCode, dialCode, countryText, phoneText;

  RegisterBody(
      {this.authRequestRegister,
      this.isoCode,
      this.dialCode,
      this.countryText,
      this.phoneText});

  @override
  _RegisterBodyState createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool isLoaderShowing = false;
  String _isoCode, _dialCode;

  @override
  void initState() {
    super.initState();
    if (widget.authRequestRegister != null &&
        widget.authRequestRegister.name != null) {
      _nameController.text = widget.authRequestRegister.name;
    }
    if (widget.authRequestRegister != null &&
        widget.authRequestRegister.email != null) {
      _emailController.text = widget.authRequestRegister.email;
    }
    if (widget.isoCode != null) {
      _isoCode = widget.isoCode;
    }
    if (widget.dialCode != null) {
      _dialCode = widget.dialCode;
    }
    if (widget.countryText != null) {
      _countryController.text = widget.countryText;
    }
    if (widget.phoneText != null) {
      _phoneController.text = widget.phoneText;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        print("incoming state: $state");
        if (state is RegisterLoading) {
          showLoader();
        } else {
          dismissLoader();
        }
        if (state is RegisterLoaded) {
          Navigator.pushReplacementNamed(context, LoginRoutes.verification,
              arguments: state.authResponse.userInfo.mobileNumber);
        }
        if (state is RegisterError) {
          Toaster.showToastBottom(
              AppLocalizations.of(context).getTranslationOf(state.messageKey));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  CustomAppBar(title: locale.registerText),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
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
                            SizedBox(
                              height: 40,
                            ),
                            EntryField(
                              controller: _nameController,
                              label: locale.nameText,
                              hint: locale.nameHint,
                              textCapitalization: TextCapitalization.words,
                            ),
                            EntryField(
                              controller: _emailController,
                              label: locale.emailText,
                              hint: locale.emailHint,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            Stack(
                              children: [
                                EntryField(
                                  controller: _countryController,
                                  label: locale.countryText,
                                  hint: locale.selectCountryFromList,
                                  suffixIcon: Icons.arrow_drop_down,
                                ),
                                Positioned(
                                  top: 24,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 56,
                                    child: CountryCodePicker(
                                      alignLeft: true,
                                      padding: EdgeInsets.zero,
                                      onChanged: (value) => setState(() {
                                        _dialCode = value.dialCode;
                                        _isoCode = value.code;
                                        _countryController.text =
                                            value.name ?? "";
                                        _phoneController.clear();
                                      }),
                                      initialSelection: _isoCode ?? "+1",
                                      hideMainText: true,
                                      showFlag: false,
                                      showFlagDialog: true,
                                      favorite: ['+91', 'US'],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            EntryField(
                              controller: _phoneController,
                              label: locale.phoneText,
                              hint: (_dialCode != null && _dialCode.isNotEmpty)
                                  ? "${locale.getTranslationOf("phoneHintExcluding")} $_dialCode"
                                  : locale.getTranslationOf("phoneHint"),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(
                              height: 250,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CustomButton(
                  radius: BorderRadius.only(
                    topLeft: Radius.circular(35.0),
                  ),
                  onPressed: () {
                    if (_nameController.text == null ||
                        _nameController.text.trim().isEmpty) {
                      Toaster.showToastBottom(AppLocalizations.of(context)
                          .getTranslationOf("nameHint"));
                    } else if (_emailController.text == null ||
                        _emailController.text.trim().isEmpty ||
                        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(_emailController.text.trim())) {
                      Toaster.showToastBottom(AppLocalizations.of(context)
                          .getTranslationOf("emailValidHint"));
                    } else if (_isoCode == null) {
                      Toaster.showToastBottom(AppLocalizations.of(context)
                          .getTranslationOf("countryText"));
                    } else if (_phoneController.text == null ||
                        _phoneController.text.trim().isEmpty) {
                      Toaster.showToastBottom(AppLocalizations.of(context)
                          .getTranslationOf("phoneHint"));
                    } else {
                      BlocProvider.of<RegisterCubit>(context).initRegistration(
                        _dialCode,
                        Helper.formatPhone(_phoneController.text.trim()),
                        _nameController.text.trim(),
                        _emailController.text.trim(),
                        null,
                        widget.authRequestRegister.image_url,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
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
}
