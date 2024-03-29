import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr/db/db_model/presentation_model.dart';
import 'package:qr/db/db_model/user_info.dart';
import 'package:qr/notification/local_notification/notification.dart';
import 'package:qr/services/service.dart';
import 'package:qr/theme/theme_extends.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    String buttonText = AppLocalizations.of(context)!.register;
    Color? buttonColor = Theme.of(context).floatingActionButtonTheme.backgroundColor;
    VoidCallback? onPressed;

    if (event.presentationTime!.microsecondsSinceEpoch < now.microsecondsSinceEpoch) {
      buttonText = AppLocalizations.of(context)!.past;
      buttonColor = const Color(0xff485FFF);
      onPressed = null;
    } else if (containsId) {
      buttonText = AppLocalizations.of(context)!.unregister;
      buttonColor = Theme.of(context).colorScheme.unregister;
      onPressed = () async {
        isButtonEnabled.value = false;
        await WebService().removeEvent(userInfo!.id!, eventId);
        ref.invalidate(eventDetailsProvider(eventId));
        ref.invalidate(userDataProvider);
        LocalNoticeService().cancelNotification(eventId);
        isButtonEnabled.value = true;
      };
    } else if (containsTime && !containsId) {
      buttonText = AppLocalizations.of(context)!.noSeat;
      buttonColor = const Color(0xff485FFF);
      onPressed = null;
    } else if (event.remainingQuota! <= 0) {
      buttonText = AppLocalizations.of(context)!.full;
      onPressed = null;
    } else if (!containsId) {
      buttonText = AppLocalizations.of(context)!.register;
      onPressed = () async {
        isButtonEnabled.value = false;
        await WebService().registerEvent(userInfo!.id!, eventId);
        ref.invalidate(eventDetailsProvider(eventId));
        ref.invalidate(userDataProvider);
        LocalNoticeService().addNotification(
            'testing',
            AppLocalizations.of(context)!.localNotifTitle,
            AppLocalizations.of(context)!.localNotifBody(
              event.title.toString(),
              event.presentationPlace.toString(),
            ),
            event.presentationTime!.millisecondsSinceEpoch - 600000,
            eventId);
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
              if (buttonText == AppLocalizations.of(context)!.unregister) ...[
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
