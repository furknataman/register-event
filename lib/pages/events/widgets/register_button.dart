import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr/db/db_model/presentation_model.dart';
import 'package:qr/db/db_model/user_info.dart';
import 'package:qr/notification/local_notification/notification.dart';
import 'package:qr/services/service.dart';
import 'package:qr/theme/theme_extends.dart';

class RegisterButton extends ConsumerWidget {
  RegisterButton({
    Key? key,
    required this.event,
    required this.eventId,
    required this.userInfo,
  }) : super(key: key);

  final ClassModelPresentation event;
  final int eventId;
  final InfoUser? userInfo;

  final isButtonEnabled = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime now = DateTime.now();
    bool containsTime =
        userInfo?.registeredEventTime?.contains(event.presentationTime) ?? false;
    bool containsId = userInfo?.registeredEventId?.contains(eventId) ?? false;

    String buttonText = "Register";
    Color? buttonColor = Theme.of(context).floatingActionButtonTheme.backgroundColor;
    VoidCallback? onPressed;

    if (event.presentationTime!.microsecondsSinceEpoch < now.microsecondsSinceEpoch) {
      buttonText = "Past";
      buttonColor = const Color(0xff485FFF);
      onPressed = null;
    } else if (containsTime && !containsId) {
      buttonText = "No Seat";
      buttonColor = const Color(0xff485FFF);
      onPressed = null;
    } else if (event.remainingQuota! <= 0) {
      buttonText = "Full";
      onPressed = null;
    } else if (!containsId) {
      buttonText = "Register";
      onPressed = () async {
        isButtonEnabled.value = false;
        await WebService().registerEvent(userInfo!.id!, eventId);
        ref.invalidate(eventDetailsProvider(eventId));
        ref.invalidate(userDataProvider);
        LocalNoticeService().addNotification(
            'testing',
            'An event is near.',
            '${event.title} is starting by 10 minutes in ${event.branch}. Don’t forget to scan the qr code.',
            DateTime.now().millisecondsSinceEpoch + 10000,
            eventId);
        isButtonEnabled.value = true;
      };
    } else {
      buttonText = "Unregister";
      buttonColor = Theme.of(context).colorScheme.unregister;
      onPressed = () async {
        isButtonEnabled.value = false;
        await WebService().removeEvent(userInfo!.id!, eventId);
        ref.invalidate(eventDetailsProvider(eventId));
        ref.invalidate(userDataProvider);
        LocalNoticeService().cancelNotification(eventId);
        isButtonEnabled.value = true;
      };
    }

    return ValueListenableBuilder<bool>(
      valueListenable: isButtonEnabled,
      builder: (context, isEnabled, child) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const StadiumBorder(),
          ),
          onPressed: isEnabled ? onPressed : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              if (buttonText == "Unregister") ...[
                const SizedBox(width: 10),
                const Icon(LucideIcons.calendarCheck, size: 19),
              ]
            ],
          ),
        );
      },
    );
  }
}
