import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<void> initOneSignal() async {
  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.init("a4159ebb-e579-4d62-abbe-a32437638de6", iOSSettings: {
    OSiOSSettings.autoPrompt: false,
    OSiOSSettings.inAppLaunchUrl: false
  });
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//   await OneSignal.shared
//       .promptUserForPushNotificationPermission(fallbackToSettings: true);
}
