import 'package:courieronedelivery/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'dart:async';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String getTranslationOf(String key) {
    return AppConfig.languagesSupported[locale.languageCode].values[key] != null
        ? AppConfig.languagesSupported[locale.languageCode].values[key]
        : AppConfig.languagesSupported[AppConfig.languageDefault].values[key] !=
                null
            ? AppConfig
                .languagesSupported[AppConfig.languageDefault].values[key]
            : key;
  }

  static List<Locale> getSupportedLocales() {
    List<Locale> toReturn = [];
    for (String langCode in AppConfig.languagesSupported.keys)
      toReturn.add(Locale(langCode));
    return toReturn;
  }

  String get bodyText1 {
    return getTranslationOf('bodyText1');
  }

  String get bodyText2 {
    return getTranslationOf('bodyText2');
  }

  String get phoneText {
    return getTranslationOf('phoneText');
  }

  String get continueText {
    return getTranslationOf('continueText');
  }

  String get vegetableText {
    return getTranslationOf('vegetableText');
  }

  String get foodText {
    return getTranslationOf('foodText');
  }
  String get wallet {
    return getTranslationOf('wallet');
  }

  String get economyText {
    return getTranslationOf('economyText');
  }

  String get paidvia {
    return getTranslationOf('paidvia');
  }

  String get earned {
    return getTranslationOf('earned');
  }

  String get courierText {
    return getTranslationOf('courierText');
  }

  String get groceryText {
    return getTranslationOf('groceryText');
  }

  String get feedbackText {
    return getTranslationOf('feedbackText');
  }

  String get yourmsg {
    return getTranslationOf('yourmsg');
  }

  String get msgHint {
    return getTranslationOf('msgHint');
  }

  String get sendMsg {
    return getTranslationOf('sendMsg');
  }

  String get courier {
    return getTranslationOf('courier');
  }

  String get markedPick {
    return getTranslationOf('markedPick');
  }

  String get food {
    return getTranslationOf('food');
  }

  String get payment {
    return getTranslationOf('payment');
  }

  String get paymentMode {
    return getTranslationOf('paymentMode');
  }

  String get express {
    return getTranslationOf('express');
  }

  String get activeDeliv {
    return getTranslationOf('activeDeliv');
  }

  String get getDir {
    return getTranslationOf('getDir');
  }

  String get openmap {
    return getTranslationOf('openmap');
  }

  String get delivInfo {
    return getTranslationOf('delivInfo');
  }

  String get courierType {
    return getTranslationOf('courierType');
  }

  String get height {
    return getTranslationOf('height');
  }

  String get length {
    return getTranslationOf('length');
  }

  String get width {
    return getTranslationOf('width');
  }

  String get weight {
    return getTranslationOf('weight');
  }

  String get customText {
    return getTranslationOf('customText');
  }

  String get homeText {
    return getTranslationOf('homeText');
  }

  String get orderText {
    return getTranslationOf('orderText');
  }

  String get accountText {
    return getTranslationOf('accountText');
  }

  String get myAccount {
    return getTranslationOf('myAccount');
  }

  String get savedAddresses {
    return getTranslationOf('savedAddresses');
  }

  String get tnc {
    return getTranslationOf('tnc');
  }

  String get knowtnc {
    return getTranslationOf('knowtnc');
  }

  String get shareApp {
    return getTranslationOf('shareApp');
  }

  String get shareFriends {
    return getTranslationOf('shareFriends');
  }

  String get support {
    return getTranslationOf('support');
  }

  String get aboutUs {
    return getTranslationOf('aboutUs');
  }

  String get contactUs {
    return getTranslationOf('contactUs');
  }

  String get viewProfile {
    return getTranslationOf('viewProfile');
  }

  String get connectQuery {
    return getTranslationOf('connectQuery');
  }

  String get logout {
    return getTranslationOf('logout');
  }

  String get loggingout {
    return getTranslationOf('loggingout');
  }

  String get sureText {
    return getTranslationOf('sureText');
  }

  String get no {
    return getTranslationOf('no');
  }

  String get yes {
    return getTranslationOf('yes');
  }

  String get signoutAccount {
    return getTranslationOf('signoutAccount');
  }

  String get myProfile {
    return getTranslationOf('myProfile');
  }

  String get signIn {
    return getTranslationOf('signIn');
  }

  String get earnings {
    return getTranslationOf('earnings');
  }

  String get recentTrans {
    return getTranslationOf('recentTrans');
  }

  String get countryText {
    return getTranslationOf('countryText');
  }

  String get nameText {
    return getTranslationOf('nameText');
  }

  String get verificationText {
    return getTranslationOf('verificationText');
  }

  String get checkPhoneNetwork {
    return getTranslationOf('checkPhoneNetwork');
  }

  String get invalidOTP {
    return getTranslationOf('invalidOTP');
  }

  String get enterOTP {
    return getTranslationOf('enterOTP');
  }

  String get otpText {
    return getTranslationOf('otpText');
  }

  String get otpText1 {
    return getTranslationOf('otpText1');
  }

  String get submitText {
    return getTranslationOf('submitText');
  }

  String get resendText {
    return getTranslationOf('resendText');
  }

  String get phoneHint {
    return getTranslationOf('phoneHint');
  }

  String get emailText {
    return getTranslationOf('emailText');
  }

  String get emailHint {
    return getTranslationOf('emailHint');
  }

  String get nameHint {
    return getTranslationOf('nameHint');
  }

  String get signinOTP {
    return getTranslationOf('signinOTP');
  }

  String get orContinue {
    return getTranslationOf('orContinue');
  }

  String get facebook {
    return getTranslationOf('facebook');
  }

  String get google {
    return getTranslationOf('google');
  }

  String get apple {
    return getTranslationOf('apple');
  }

  String get networkError {
    return getTranslationOf('networkError');
  }

  String get invalidNumber {
    return getTranslationOf('invalidNumber');
  }

  String get invalidName {
    return getTranslationOf('invalidName');
  }

  String get invalidEmail {
    return getTranslationOf('invalidEmail');
  }

  String get courierInfo {
    return getTranslationOf('courierInfo');
  }

  String get invalidNameEmail {
    return getTranslationOf('invalidNameEmail');
  }

  String get signinfailed {
    return getTranslationOf('signinfailed');
  }

  String get socialText {
    return getTranslationOf('socialText');
  }

  String get registerText {
    return getTranslationOf('registerText');
  }

  String get selectCountryFromList {
    return getTranslationOf('selectCountryFromList');
  }

  String get hey {
    return getTranslationOf('hey');
  }

  String get cash {
    return getTranslationOf('cash');
  }

  String get newDeliveries {
    return getTranslationOf('newDeliveries');
  }

  String get delivered {
    return getTranslationOf('delivered');
  }

  String get cashOnPickup {
    return getTranslationOf('cashOnPickup');
  }

  String get boxCourier {
    return getTranslationOf('boxCourier');
  }

  String get frangible {
    return getTranslationOf('frangible');
  }

  String get birthdayGiftContainingFlowerVasCarryCarefullyFrangible {
    return getTranslationOf(
        'birthdayGiftContainingFlowerVasCarryCarefullyFrangible');
  }

  String get paymentViaCashPickup {
    return getTranslationOf('paymentViaCashPickup');
  }

  String get companyPrivacyPolicy {
    return getTranslationOf('companyPrivacyPolicy');
  }

  String get accept {
    return getTranslationOf('accept');
  }

  String get markDelivered {
    return getTranslationOf('markDelivered');
  }

  String get setDelivery {
    return getTranslationOf('setDelivery');
  }

  String get setPickup {
    return getTranslationOf('setPickup');
  }

  String get done {
    return getTranslationOf('done');
  }

  String get privacyPolicy {
    return getTranslationOf('privacyPolicy');
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppConfig.languagesSupported.keys.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of AppLocalizations.
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
