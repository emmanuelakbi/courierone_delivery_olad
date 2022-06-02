import 'dart:convert';

import 'package:courieronedelivery/Locale/locales.dart';
import 'package:courieronedelivery/config/app_config.dart';
import 'package:courieronedelivery/models/Auth/Responses/login_response.dart';
import 'package:courieronedelivery/models/Auth/Responses/user_info.dart';
import 'package:courieronedelivery/models/DeliveryRequest/Get/delivery_profile.dart';
import 'package:courieronedelivery/models/DeliveryRequest/Get/delivery_request.dart';
import 'package:courieronedelivery/models/Order/order_data.dart';
import 'package:courieronedelivery/models/Vendor/image_data.dart';
import 'package:courieronedelivery/models/Vendor/media_library.dart';
import 'package:courieronedelivery/models/setting.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper {
  Helper._privateConstructor() {
    _initPref();
  }

  static final Helper _instance = Helper._privateConstructor();

  factory Helper() {
    return _instance;
  }

  static const String _KEY_SETTINGS = "key_settings";
  static const String _KEY_TOKEN = "key_token";
  static const String _KEY_USER = "key_user";
  static const String _KEY_PROFILE = "key_profile";
  static const String _KEY_CUR_LANG = "key_cur_lang";
  static const String _TEMP_CHANGED_ORDER_REQUEST = "changed_order_request";
  static const String _TEMP_CHANGED_ORDER = "changed_order";
  SharedPreferences _sharedPreferences;

  //holding frequently accessed sharedPreferences in memory.
  List<Setting> _settingsAll;
  String _authToken;
  UserInformation _userMe;

  _initPref() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  Future<bool> init() async {
    await _initPref();
    _settingsAll = await getSettings();
    await getAuthenticationToken();
    return true;
  }

  saveSettings(List<Setting> settings) async {
    if (settings != null) {
      _settingsAll = settings;
      await _initPref();
      _sharedPreferences.setString(_KEY_SETTINGS, json.encode(settings));
    }
  }

  Future<List<Setting>> getSettings() async {
    if (_settingsAll != null) {
      return _settingsAll;
    } else {
      await _initPref();
      String settingVal = _sharedPreferences.getString(_KEY_SETTINGS);
      if (settingVal != null && settingVal.isNotEmpty) {
        return (json.decode(settingVal) as List)
            .map((e) => Setting.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    }
  }

  Future<bool> isLanguageSelectionPromted() async {
    await _initPref();
    return _sharedPreferences.containsKey("language_selection_promted");
  }

  setLanguageSelectionPromted() async {
    await _initPref();
    _sharedPreferences.setBool("language_selection_promted", true);
  }

  String getSettingValue(String forKey) {
    String toReturn = "";
    if (_settingsAll != null) {
      for (Setting setting in _settingsAll) {
        if (setting.key == forKey) {
          toReturn = setting.value;
          break;
        }
      }
    }
    if (toReturn.isEmpty) {
      print(
          "getSettingValue returned empty value for: $forKey, when settings were: $_settingsAll");
    }
    return toReturn;
  }

  Future<bool> setTempOrder(OrderData orderData) async {
    await _initPref();
    return orderData == null
        ? _sharedPreferences.remove(_TEMP_CHANGED_ORDER)
        : _sharedPreferences.setString(
            _TEMP_CHANGED_ORDER, json.encode(orderData));
  }

  Future<OrderData> getTempOrder() async {
    Map savedOrderMap = await _getTempChange(_TEMP_CHANGED_ORDER);
    return savedOrderMap != null ? OrderData.fromJson(savedOrderMap) : null;
  }

  Future<bool> setTempOrderRequest(DeliveryRequest orderRequest) async {
    await _initPref();
    return orderRequest == null
        ? _sharedPreferences.remove(_TEMP_CHANGED_ORDER_REQUEST)
        : _sharedPreferences.setString(
            _TEMP_CHANGED_ORDER_REQUEST, json.encode(orderRequest));
  }

  Future<DeliveryRequest> getTempOrderRequest() async {
    Map savedOrderMap = await _getTempChange(_TEMP_CHANGED_ORDER_REQUEST);
    return savedOrderMap != null
        ? DeliveryRequest.fromJson(savedOrderMap)
        : null;
  }

  Future<bool> saveAuthResponse(LoginResponse authResponse) async {
    await _initPref();
    _authToken = "Bearer ${authResponse.token}";
    _sharedPreferences.setString(_KEY_TOKEN, authResponse.token);
    return setUserMe(authResponse.userInfo);
  }

  Future<bool> setUserMe(UserInformation userMe) async {
    this._userMe = userMe;

    if (this._userMe.mediaurls == null ||
        this._userMe.mediaurls.images == null) {
      this._userMe.mediaurls = MediaLibrary([]);
    }
    if (this._userMe.image_url == null) {
      for (ImageData imgObj in this._userMe.mediaurls.images) {
        if (imgObj.defaultImage != null && imgObj.defaultImage.isNotEmpty) {
          this._userMe.image_url = imgObj.defaultImage;
          break;
        }
      }
    }

    await _initPref();
    return _sharedPreferences.setString(
        _KEY_USER, json.encode(this._userMe.toJson()));
  }

  Future<bool> saveProfileMe(DeliveryProfile deliveryProfile) async {
    await _initPref();
    deliveryProfile.isFresh = !_sharedPreferences.containsKey(_KEY_PROFILE);
    return _sharedPreferences.setString(
        _KEY_PROFILE, json.encode(deliveryProfile.toJson()));
  }

  Future<DeliveryProfile> getProfileMe() async {
    await _initPref();
    return _sharedPreferences.containsKey(_KEY_PROFILE)
        ? DeliveryProfile.fromJson(
            json.decode(_sharedPreferences.getString(_KEY_PROFILE)))
        : null;
  }

  Future<String> getCurrentLanguage() async {
    await _initPref();
    return _sharedPreferences.containsKey(_KEY_CUR_LANG)
        ? _sharedPreferences.getString(_KEY_CUR_LANG)
        : AppConfig.languageDefault;
  }

  Future<bool> setCurrentLanguage(String langCode) async {
    await _initPref();
    return _sharedPreferences.setString(_KEY_CUR_LANG, langCode);
  }

  static String setupDate(String dateTimeStamp) {
    return Moment.parse(dateTimeStamp).format("dd MMM yyyy, HH:mm");
  }

  Future<UserInformation> getUserMe() async {
    if (this._userMe == null) {
      await _initPref();
      _userMe = _sharedPreferences.containsKey(_KEY_USER)
          ? UserInformation.fromJson(
              json.decode(_sharedPreferences.getString(_KEY_USER)))
          : null;
    }
    return _userMe != null && _userMe.id == null ? null : _userMe;
  }

  Future<bool> clearPrefs() async {
    await _initPref();
    //_settingsAll = null;
    _authToken = null;
    _userMe = null;
    bool cleared = await _sharedPreferences.clear(); //clearing everything
    saveSettings(_settingsAll); //except setting values
    return cleared;
  }

  Future<String> getAuthenticationToken() async {
    await _initPref();
    if (_authToken == null && _sharedPreferences.containsKey(_KEY_TOKEN)) {
      _authToken = "Bearer ${_sharedPreferences.getString(_KEY_TOKEN)}";
      Helper.printConsoleWrapped("_authToken setup: $_authToken");
    }
    return _authToken;
  }

  Future<dynamic> _getTempChange(String key) async {
    await _initPref();
    return _sharedPreferences.containsKey(key)
        ? (json.decode(_sharedPreferences.getString(key)))
        : null;
  }

  static void launchMapsUrl(
      LatLng pickup, LatLng drop, String origin, String dest) async {
    final availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showDirections(
      origin: Coords(pickup.latitude, pickup.longitude),
      originTitle: origin,
      destination: Coords(drop.latitude, drop.longitude),
      destinationTitle: dest,
    );
  }

  static Future<bool> launchUrl(String url) async {
    try {
      return launch(url);
    } catch (e) {
      print("launchUrl: $e");
      return false;
    }
    // bool couldLaunch = await canLaunch(url);
    // if (couldLaunch) {
    //   return launch(url);
    // } else {
    //   return false;
    // }
  }

  static void printConsoleWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  static String formatDuration(Duration d) {
    var seconds = d.inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days}d');
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add('${hours}h');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes}m');
    }

    if (tokens.isEmpty) {
      tokens.add('${seconds}s');
    }

    return tokens.join(' ');
  }

  static String getMediaUrl(MediaLibrary mediaUrl,
      [MediaImageSize preferredSize]) {
    String toReturn = "";
    if (mediaUrl != null && mediaUrl.images != null) {
      for (ImageData imgObj in mediaUrl.images) {
        if (imgObj.defaultImage != null && imgObj.defaultImage.isNotEmpty) {
          toReturn = imgObj.defaultImage;
          break;
        }
        if (preferredSize != null) {
          if (preferredSize == MediaImageSize.thumb) {
            if (imgObj.thumb != null && imgObj.thumb.isNotEmpty) {
              toReturn = imgObj.thumb;
              break;
            }
          }
          if (preferredSize == MediaImageSize.small) {
            if (imgObj.small != null && imgObj.small.isNotEmpty) {
              toReturn = imgObj.small;
              break;
            }
          }
          if (preferredSize == MediaImageSize.medium) {
            if (imgObj.medium != null && imgObj.medium.isNotEmpty) {
              toReturn = imgObj.medium;
              break;
            }
          }
          if (preferredSize == MediaImageSize.large) {
            if (imgObj.large != null && imgObj.large.isNotEmpty) {
              toReturn = imgObj.large;
              break;
            }
          }
        }
      }
    }
    return toReturn;
  }

  static String formatPhone(String phone) {
    String toReturn = phone.replaceAll(" ", "");
    while (
        //toReturn.startsWith("0") ||
        toReturn.startsWith("+")) toReturn = toReturn.substring(1);
    return toReturn;
  }

  static openShareMediaIntent(BuildContext context) {
    Share.share(
      AppLocalizations.of(context).getTranslationOf("share_msg") +
          " " +
          AppConfig.appName +
          "\n" +
          "https://play.google.com/store/apps/details?id=" +
          AppConfig.packageName,
    );
  }
}
