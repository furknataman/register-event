import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr/db/db_model/presentation_model.dart';
import 'package:qr/db/db_model/user_info.dart';
import 'package:qr/services/service.dart';
import 'package:qr/theme/theme_extends.dart';
import '../../../notification/local_notification/notification.dart';

class RegisterButton extends ConsumerWidget {
  const RegisterButton({
    super.key,
    //required this.userInfo,
    required this.event,
    required this.eventId,
    required this.userInfo,
  });

  //final UserInfo userInfo;
  final ClassModelPresentation event;
  final int eventId;

  final InfoUser? userInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /* if (event!.dateTime!.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff485FFF),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const StadiumBorder()),
          onPressed: null,
          child: Row(
            children: [
              Text(
                "Past",
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ));
    }  if (userInfo!.kayitOlduguSunumId!.contains(event!.id) == false) {
      if (userInfo.user!.dateTimeList!.contains(event!.timestamp) == true) {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff485FFF),
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const StadiumBorder()),
            onPressed: null,
            child: Row(
              children: [
                Text(
                  "No Seat",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ));
      } else if (event!.capacity! - event!.participantsNumber! <= 0) {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const StadiumBorder()),
            onPressed: null,
            child: const Row(
              children: [
                Text(
                  "Full",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ));
      }*/
    if (userInfo?.kayitOlduguSunumId?.contains(eventId) == false ||
        userInfo?.kayitOlduguSunumId == null) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const StadiumBorder()),
          onPressed: () async {
            //userInfo.writeUser(registeredEvents: event!.id, eventTime: event!.timestamp);
            //eventAction.writeEvents(eventsCollectionName: event!.eventsCollectionName);
            await WebService().registerEvent(userInfo!.id!, eventId);
            ref.invalidate(eventDetailsProvider(eventId));
            ref.invalidate(userDataProvider);
            LocalNoticeService().addNotification(
                'testing',
                'An event is near.',
                '${event.title} is starting by 10 minutes in ${event.branch}. Don’t forget to scan the qr code.',
                DateTime.now().millisecondsSinceEpoch +
                    10000 //event!.dateTime!.millisecondsSinceEpoch + 60000,
                );
          },
          child: const Center(
            child: Text(
              "Register",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ));
    } else {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.unregister,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const StadiumBorder()),
          onPressed: () async {
            await WebService().removeEvent(userInfo!.id!, eventId);
            ref.invalidate(eventDetailsProvider(eventId));
            ref.invalidate(userDataProvider);
            //userInfo.removeEvent(registeredEvents: event!.id, eventTime: event!.timestamp);
            //eventAction.removeEventUser(event: event);
            LocalNoticeService().cancelNotification(1);
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Unregister",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                LucideIcons.calendarCheck,
                size: 19,
              )
            ],
          ));
    }
  }
}
