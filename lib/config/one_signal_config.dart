import 'package:courieronedelivery/config/app_config.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalConfig {
  static Future<void> initOneSignal() async {
    await OneSignal.shared.init(AppConfig.oneSignalAppId, iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false
    });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
  }

  static getPlayerId() async {
    await initOneSignal(); //just in case if this was uninitialized
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    return (status != null &&
            status.subscriptionStatus != null &&
            status.subscriptionStatus.userId != null)
        ? status.subscriptionStatus.userId
        : null;
  }
}
