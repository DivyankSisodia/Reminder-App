 // Import where you have flutterLocalNotificationsPlugin

import '../../main.dart';

Future<void> cancelNotification(int notificationId) async {
  await flutterLocalNotificationsPlugin.cancel(notificationId);
}
