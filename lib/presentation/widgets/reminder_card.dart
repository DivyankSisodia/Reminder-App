import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../data/models/reminder_model.dart';
import '../../domain/usecases/cancel_notifications.dart';
import '../providers/reminder_list_provider.dart';

class ReminderCard extends ConsumerWidget {
  final Reminder reminder;
  const ReminderCard({super.key, required this.reminder});

  void _cancelReminderNotification(int notificationId) {
    cancelNotification(notificationId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color getPriorityColor(String priority) {
      switch (priority) {
        case 'Less Priority':
          return Colors.green;
        case 'Mid Priority':
          return Colors.blue;
        case 'Alert!!':
          return Colors.red;
        default:
          return Colors.black;
      }
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    reminder.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  reminder.priority,
                  style: TextStyle(
                    color: getPriorityColor(reminder.priority),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    reminder.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Gap(5),
                Text(
                  '${DateFormat('dd/MM/yyyy').format(reminder.dateTime)} | ID: ${reminder.id}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  DateFormat('HH:mm').format(reminder.dateTime),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: reminder.isSwitchOn,
                  onChanged: (value) {
                    ref
                        .watch(reminderListProvider.notifier)
                        .toggleSwitch(reminder);
                    if (value == false) {
                      debugPrint('$value');
                      _cancelReminderNotification(reminder.id);
                    }
                    if (value == true) {
                      debugPrint('$value');
                    }
                  },
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
