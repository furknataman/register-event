/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr/theme/theme_extends.dart';
import '../../../db/db_model/db_model_events.dart';

import '../../../global/global_variable/events_info.dart';
import '../../../global/global_variable/user_info.dart';
import '../../../notification/local_notification/notification.dart';

class RegisterButton extends ConsumerWidget {
  const RegisterButton({
    super.key,
    //required this.userInfo,
    required this.event,
  });

  //final UserInfo userInfo;
  final ClassModelEvents? event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAction = ref.watch<EventsInfo>(eventsInfoConfig);

    if (event!.dateTime!.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch) {
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
    } else if (userInfo.user!.registeredEvents!.contains(event!.id) == false) {
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
      } else {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const StadiumBorder()),
            onPressed: () {
              userInfo.writeUser(registeredEvents: event!.id, eventTime: event!.timestamp);
              eventAction.writeEvents(eventsCollectionName: event!.eventsCollectionName);

              LocalNoticeService().addNotification(
                  'testing',
                  'An event is near.',
                  '${event!.name} is starting by 10 minutes in ${event!.eventsLocation}. Don’t forget to scan the qr code.',
                  DateTime.now().millisecondsSinceEpoch +
                      10000 //event!.dateTime!.millisecondsSinceEpoch + 60000,
                  );
            },
            child: const Row(
              children: [
                Text(
                  "Register",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ));
      }
    } else {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.unregister,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const StadiumBorder()),
          onPressed: () {
            userInfo.removeEvent(registeredEvents: event!.id, eventTime: event!.timestamp);
            eventAction.removeEventUser(event: event);
            LocalNoticeService().cancelNotification(1);
          },
          child: const Row(
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
}*/
