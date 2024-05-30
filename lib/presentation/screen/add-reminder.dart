import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:remainderapp/presentation/providers/switch_provider.dart';
import '../../data/models/reminder_model.dart';
import '../../main.dart';
import '../providers/date_provider.dart';
import '../providers/radio_provider.dart';
import '../providers/reminder_list_provider.dart';
import '../providers/time_provider.dart';
import '../widgets/date_time_widget.dart';
import '../widgets/radio_widget.dart';
import 'package:timezone/timezone.dart' as tz;

class AddReminderScreen extends ConsumerStatefulWidget {
  const AddReminderScreen({super.key});

  @override
  ConsumerState<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends ConsumerState<AddReminderScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  bool validateInputs() {
    if (titleController.text.length > 15) {
      setState(() {
        errorMessage = 'Title cannot be more than 15 characters';
      });
      return false;
    }

    if (descriptionController.text.length > 15) {
      setState(() {
        errorMessage = 'Description cannot be more than 15 characters';
      });
      return false;
    }

    final wordCount =
        descriptionController.text.trim().split(RegExp(r'\s+')).length;
    if (wordCount >= 20) {
      setState(() {
        errorMessage = 'Description cannot be more than 20 words';
      });
      return false;
    }

    setState(() {
      errorMessage = null;
    });
    return true;
  }

  Future<void> scheduleNotification(Reminder reminder) async {
    const androidDetails = AndroidNotificationDetails(
      'reminder_app_channel',
      'Reminder Notifications',
      channelDescription: 'This channel is for reminder notifications',
      priority: Priority.max,
      importance: Importance.max,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      reminder.id,
      reminder.title,
      reminder.description,
      tz.TZDateTime.from(reminder.dateTime, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Widget build(BuildContext context) {
    final date = ref.watch(dateProvider);
    final time = ref.watch(timeProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Add Reminder'),
        actions: [
          IconButton(
            icon: const Icon(
              Iconsax.tick_circle,
              color: Colors.green,
            ),
            onPressed: () async {
              if (date != 'dd/mm/yy') {
                final selectedDate = DateFormat('dd/MM/yy').parse(date);
                final selectedDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  time.hour,
                  time.minute,
                );

                final currentTime = DateTime.now();

                final getRadioValue = ref.read(radioProvider);
                String priority = '';

                switch (getRadioValue) {
                  case 1:
                    priority = 'Less Priority';
                    break;
                  case 2:
                    priority = 'Mid Priority';
                    break;
                  case 3:
                    priority = 'Alert!!';
                    break;
                }

                if (selectedDateTime.isBefore(currentTime)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a valid date and time'),
                    ),
                  );
                  return;
                }

                if (validateInputs()) {
                  final newReminder = Reminder(
                    id: Random().nextInt(1000),
                    title: titleController.text.isNotEmpty
                        ? titleController.text
                        : 'Title',
                    description: descriptionController.text.isNotEmpty
                        ? descriptionController.text
                        : 'Description',
                    dateTime: selectedDateTime,
                    isSwitchOn: ref.read(switchProvider),
                    priority: priority,
                  );

                  ref
                      .read(reminderListProvider.notifier)
                      .addReminder(newReminder);

                  await scheduleNotification(newReminder);

                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage ?? ''),
                    ),
                  );
                  titleController.clear();
                  descriptionController.clear();
                }
              }
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.all(screenWidth * 0.04),
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Gap(20),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter title',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter description',
                      ),
                    ),
                    const SizedBox(height: 16),
                    DateTimeWidget(
                      icon: Iconsax.clock,
                      text: date,
                      headingtext: 'Choose date',
                      OnTap: () async {
                        final getValue = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2021),
                          lastDate: DateTime(2025),
                        );
                        if (getValue != null) {
                          final format = DateFormat('dd/MM/yy');
                          ref.read(dateProvider.notifier).state =
                              format.format(getValue);
                        }
                      },
                    ),
                    const Gap(20),
                    DateTimeWidget(
                      icon: Iconsax.clock,
                      text: time.format(context),
                      headingtext: 'Choose time',
                      OnTap: () async {
                        final getTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (getTime != null) {
                          ref.read(timeProvider.notifier).state = getTime;
                        }
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioWidget(
                            categColor: Colors.blueAccent.shade700,
                            titleRadio: 'Less Priority',
                            valueInput: 1,
                            onChangedValue: () => ref
                                .read(radioProvider.notifier)
                                .update((state) => 1),
                          ),
                        ),
                        Expanded(
                          child: RadioWidget(
                            categColor: Colors.amberAccent.shade700,
                            titleRadio: 'Mid Priority',
                            valueInput: 2,
                            onChangedValue: () => ref
                                .read(radioProvider.notifier)
                                .update((state) => 2),
                          ),
                        ),
                        Expanded(
                          child: RadioWidget(
                            categColor: Colors.orangeAccent.shade700,
                            titleRadio: 'Alert!!',
                            valueInput: 3,
                            onChangedValue: () => ref
                                .read(radioProvider.notifier)
                                .update((state) => 3),
                          ),
                        )
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final getRadioValue = ref.read(radioProvider);
                        String priority = '';

                        switch (getRadioValue) {
                          case 1:
                            priority = 'Less Priority';
                            break;
                          case 2:
                            priority = 'Mid Priority';
                            break;
                          case 3:
                            priority = 'Alert!!';
                            break;
                        }
                        if (date != 'dd/mm/yy') {
                          final selectedDate =
                              DateFormat('dd/MM/yy').parse(date);

                          final selectedDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            time.hour,
                            time.minute,
                          );

                          if (validateInputs()) {
                            final newReminder = Reminder(
                              id: Random().nextInt(1000),
                              title: titleController.text.isEmpty
                                  ? 'Title'
                                  : titleController.text,
                              description: descriptionController.text.isEmpty
                                  ? 'Description'
                                  : descriptionController.text,
                              dateTime: selectedDateTime,
                              isSwitchOn: true,
                              priority: priority,
                            );

                            ref
                                .read(reminderListProvider.notifier)
                                .addReminder(newReminder);

                            await scheduleNotification(newReminder);

                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMessage ?? ''),
                              ),
                            );
                            titleController.clear();
                            descriptionController.clear();
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a valid date and time'),
                            ),
                          );
                          debugPrint('Please select a valid date and time');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.alarm,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Set Reminder',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: screenWidth * 0.125,
                child: Container(
                  height: screenHeight * 0.05,
                  width: screenWidth * 0.75,
                  decoration: const BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Make your own reminder',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
