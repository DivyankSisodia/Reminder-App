import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:remainderapp/presentation/screen/add-reminder.dart';
import 'package:remainderapp/presentation/screen/update-reminder.dart';
import '../../main.dart';
import '../providers/reminder_list_provider.dart';
import '../widgets/reminder_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isSorted = false;

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

  void _toggleSort() {
    setState(() {
      _isSorted = !_isSorted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reminderListNotifier = ref.read(reminderListProvider.notifier);
    final reminderList = ref.watch(reminderListProvider);

    // Get the appropriate list based on the sorting state
    final displayedReminders =
        _isSorted ? reminderListNotifier.getSortedReminders() : reminderList;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: showNotifications,
        ),
        centerTitle: true,
        title: const Text('Reminder App'),
        actions: [
          IconButton(
            icon: _isSorted
                ? const Icon(Icons.sort_by_alpha)
                : const Icon(Icons.sort),
            onPressed: _toggleSort,
          ),
          IconButton(
            icon: const Icon(Icons.add_alarm_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddReminderScreen(),
                ),
              );
              debugPrint('Add Alarm');
            },
          ),
        ],
      ),
      body: displayedReminders.isEmpty
          ? Center(
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.network(
                        'https://lottie.host/820c1262-b5b3-4525-be2c-9f58a01b407a/Idb5Xelpa2.json',
                        height: 400,
                        width: 400),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add Reminders!!!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.lato().fontFamily,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddReminderScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Iconsax.add_circle,
                            size: 30,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: displayedReminders.length,
              itemBuilder: (context, index) {
                final reminder = displayedReminders[index];
                return Slidable(
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        borderRadius: BorderRadius.circular(20),
                        onPressed: ((context) {
                          ref
                              .read(reminderListProvider.notifier)
                              .removeReminder(reminder);
                        }),
                        icon: Icons.delete,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.redAccent.shade400,
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        borderRadius: BorderRadius.circular(10),
                        onPressed: ((context) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateReminderScreen(reminder: reminder),
                            ),
                          );
                        }),
                        icon: reminder.isSwitchOn
                            ? Icons.update
                            : Icons.update_disabled,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.greenAccent.shade400,
                      ),
                    ],
                  ),
                  child: ReminderCard(
                    reminder: reminder,
                  ),
                );
              },
            ),
    );
  }
}
