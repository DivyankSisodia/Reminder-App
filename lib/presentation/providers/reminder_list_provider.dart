import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/reminder_model.dart';
import '../../domain/usecases/cancel_notifications.dart';
import '../../main.dart';

List<Reminder> itemList = [];

class ReminderListNotifier extends StateNotifier<List<Reminder>> {
  void _cancelReminderNotification(int notificationId) {
    cancelNotification(notificationId);
  }

  void showNotifications() async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      'reminder_app_channel',
      'Reminder Notifications',
      channelDescription: 'This channel is for reminder notifications',
      priority: Priority.max,
      importance: Importance.max,
    );

    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Reminder App',
      'This is a reminder notification',
      notificationDetails,
    );
  }

  ReminderListNotifier() : super(itemList);

  void addReminder(Reminder reminder) {
    state = [...state, reminder];
  }

  void removeReminder(Reminder reminder) {
    state = state.where((element) => element.id != reminder.id).toList();
  }

  void updateReminder(Reminder reminder) {
    state = state.map((r) => r.id == reminder.id ? reminder : r).toList();
  }

  void toggleSwitch(Reminder reminder) {
    state = state.map((item) {
      if (item.id == reminder.id) {
        final updatedReminder = Reminder(
          id: item.id,
          title: item.title,
          description: item.description,
          dateTime: item.dateTime,
          isSwitchOn: !item.isSwitchOn,
          priority: item.priority,
        );

        if (updatedReminder.isSwitchOn) {
          // Schedule a new notification if switching on
          showNotifications();
        } else {
          // Cancel the notification if switching off
          _cancelReminderNotification(updatedReminder.id);
        }

        return updatedReminder;
      }
      return item;
    }).toList();
  }

  List<Reminder> getSortedReminders() {
    List<Reminder> sortedList = List.from(state);
    sortedList.sort((a, b) {
      const priorityOrder = {
        'Alert!!': 0,
        'Mid Priority': 1,
        'Less Priority': 2
      };
      return priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!);
    });
    return sortedList;
  }
}

final reminderListProvider =
    StateNotifierProvider<ReminderListNotifier, List<Reminder>>(
        (ref) => ReminderListNotifier());
