// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hi => 'Hi';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get register => 'Register';

  @override
  String get unregister => 'Unregister';

  @override
  String get full => 'Full';

  @override
  String get upcoming => 'Upcoming Events';

  @override
  String get password => 'Password';

  @override
  String get timeOfEvent => 'Time of Event';

  @override
  String get speakers => 'Speakers';

  @override
  String get capacity => 'Capacity';

  @override
  String freeSeats(Object presentationQuota, Object remainingQuota) {
    return '$remainingQuota free seats left from $presentationQuota';
  }

  @override
  String get description => 'Description';

  @override
  String get scanqr => 'Scan the QR code of \nyour event';

  @override
  String get filters => 'Filters';

  @override
  String get reset => 'Reset';

  @override
  String get ok => 'Ok';

  @override
  String get cancel => 'Cancel';

  @override
  String get startFrom => 'Starting from';

  @override
  String get whatToShow => 'What to show';

  @override
  String get targetGroup => 'Target group';

  @override
  String get branch => 'Branch';

  @override
  String get past => 'Past';

  @override
  String get email => 'E-mail';

  @override
  String get conferancesName => 'Autumn Teachers Conference';

  @override
  String get noPermission => 'No Permission';

  @override
  String get all => 'All';

  @override
  String get pastEvent => 'Past Events';

  @override
  String get ongoingEvents => 'Ongoing Events';

  @override
  String get registeredEvents => 'Registered Events';

  @override
  String get nonRegistered => 'Non-Registered';

  @override
  String get nonRegisterMessage =>
      'You are not registered the event that you have scanned.';

  @override
  String get allreadyAttended => 'Already Attended';

  @override
  String get allReadyAttendedMessage => 'You have already attended this event';

  @override
  String get attendedEvent => 'Join The Event';

  @override
  String attendedEventMessage(Object eventTitle) {
    return 'You are about to attend to $eventTitle, are you sure?';
  }

  @override
  String get unrecognized => 'Unrecognized Code';

  @override
  String get unrecognizedMessage =>
      'The code you have scanned cannot be recognized by our system. Please scan only the codes printed on doors.';

  @override
  String get loginError => 'Username or password is incorrect';

  @override
  String get connectionError => 'An error occurred. Can you try again?';

  @override
  String get localNotifTitle => 'An event is near.';

  @override
  String localNotifBody(Object branch, Object title) {
    return '$title is starting by 10 minutes in $branch. Don’t forget to scan the qr code.';
  }

  @override
  String get noSeat => 'Time Slot Full';

  @override
  String get appRate => 'Evaluation Survey';

  @override
  String get rollCallTitle => 'Inspection';

  @override
  String get rollCallBody => 'Do you confirm the roll call?';

  @override
  String get scanAttendMessage =>
      'Your event entry has been approved, you can log in.';

  @override
  String get generalForm => 'Conference Evaluation Form';

  @override
  String get status => 'Login Status';

  @override
  String get canLogin => 'Allowed';

  @override
  String get dailySchedule => 'Daily Schedule';

  @override
  String get eventLocation => 'Event Location';
}
