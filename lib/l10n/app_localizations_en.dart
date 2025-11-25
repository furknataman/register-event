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
  String get dailySchedule => 'My Program';

  @override
  String get eventLocation => 'Event Location';

  @override
  String get profile => 'Profile';

  @override
  String get userInfo => 'User Information';

  @override
  String get changePassword => 'Change Password';

  @override
  String get themeSelection => 'Theme Selection';

  @override
  String get languageSelection => 'Language Selection';

  @override
  String get noEventsYet => 'No events yet';

  @override
  String get searchEvents => 'Search events';

  @override
  String get startSearching => 'Start searching for events';

  @override
  String get noResults => 'No results found';

  @override
  String noResultsFor(Object query) {
    return 'No events found matching \"$query\"';
  }

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String get newNotificationsHere => 'Your new notifications will appear here';

  @override
  String get lightTheme => 'Light Theme';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get systemTheme => 'System';

  @override
  String get turkish => 'Türkçe';

  @override
  String get english => 'English';

  @override
  String get settings => 'Settings';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get error => 'Error';

  @override
  String get anErrorOccurred => 'An error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading';

  @override
  String themeSelected(Object theme) {
    return '$theme selected';
  }

  @override
  String languageSelected(Object language) {
    return '$language language selected';
  }

  @override
  String get searchPlaceholder => 'Search for event, teacher or school...';

  @override
  String get noInstitutionInfo => 'No institution info';

  @override
  String get minutes => 'minutes';

  @override
  String get noTypeInfo => 'No type info';

  @override
  String get noBranchInfo => 'No branch info';

  @override
  String get noTitleInfo => 'No Title';

  @override
  String get categoryAll => 'All';

  @override
  String get session => 'Session';

  @override
  String get session1 => '1. Session';

  @override
  String get session2 => '2. Session';

  @override
  String get session3 => '3. Session';

  @override
  String get session4 => '4. Session';

  @override
  String get myRegistrations => 'My Registrations';

  @override
  String get eventInfoLoadFailed => 'Event information could not be loaded';

  @override
  String get operationFailed => 'Operation failed';

  @override
  String get userInfoFetchFailed => 'User information could not be fetched';

  @override
  String get userInfoNotFound => 'User information not found';

  @override
  String get userInfoLoading => 'Loading user information...';

  @override
  String get unregistrationSuccess => 'Registration cancelled';

  @override
  String get registrationSuccess => 'Registration successful';

  @override
  String get processing => 'Processing...';

  @override
  String get presentationPlace => 'Presentation Place';

  @override
  String get presentationTime => 'Presentation Time';

  @override
  String get quota => 'Quota';

  @override
  String get duration => 'Duration';

  @override
  String get language => 'Language';

  @override
  String get scheduleLoadFailed => 'Schedule could not be loaded';

  @override
  String get qrCodeProcessFailed => 'QR code could not be processed';

  @override
  String get profileLoadFailed => 'Profile could not be loaded';

  @override
  String get eventsLoadFailed => 'Events could not be loaded';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get timeHasPassed => 'Time Has Passed';

  @override
  String get sameSessionRegistered => 'Registered in Same Session';

  @override
  String get quotaFull => 'Quota Full';

  @override
  String get presentationNotFound => 'Presentation Not Found';

  @override
  String get registeredTimePassed => 'Registered (Time Passed)';

  @override
  String get attendanceTaken => 'Attendance Taken';

  @override
  String get generalAttendanceTaken => 'General Attendance Taken';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get sendResetCode => 'Send Code';

  @override
  String get enterEmailOrPhone => 'Email or Phone';

  @override
  String get resetViaEmail => 'Via Email';

  @override
  String get resetViaSms => 'Via SMS';

  @override
  String get selectResetMethod => 'Reset Method';

  @override
  String get enterResetCode => 'Reset Code';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetCodeSent => 'Reset code sent';

  @override
  String get passwordResetSuccess => 'Password reset successfully';

  @override
  String get passwordsMustMatch => 'Passwords must match';

  @override
  String get forgot_password_participant_not_found => 'User not found';

  @override
  String get forgot_password_email_not_found => 'No registered email found';

  @override
  String get forgot_password_phone_not_found =>
      'No registered phone number found';

  @override
  String get forgot_password_invalid_type => 'Invalid reset method';

  @override
  String get resetPassword_invalid_code => 'Reset code is invalid or expired';

  @override
  String get resetPassword_code_expired => 'Reset code has expired';

  @override
  String get resetPassword_passwords_mismatch => 'Passwords do not match';

  @override
  String get resetPassword_update_failed => 'Password update failed';

  @override
  String get enterCode => 'Enter Code';

  @override
  String get code => 'Code';

  @override
  String get resetPasswordTitle => 'Password Reset';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get confirmRegistration => 'Do you want to confirm registration?';

  @override
  String get confirmUnregistration =>
      'Are you sure you want to cancel registration?';

  @override
  String get confirm => 'Confirm';

  @override
  String get profileEmail => 'Email';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profileSchool => 'School';

  @override
  String get profileJobTitle => 'Job Title';

  @override
  String get statistics => 'Statistics';

  @override
  String get attendedEvents => 'Attended Events';

  @override
  String get profileInformation => 'Profile Information';

  @override
  String get notProvided => 'Not provided';

  @override
  String get user => 'User';

  @override
  String get appDevelopedBy =>
      'This app is developed by Eyüboğlu Education Institutions';

  @override
  String get version => 'Version';

  @override
  String get navHome => 'Home';

  @override
  String get navScan => 'Scan';

  @override
  String get navSearch => 'Search';

  @override
  String get navProfile => 'Profile';

  @override
  String searchResultsCount(Object count) {
    return '$count results found';
  }

  @override
  String get scanPageTitle => 'Scan QR Code';

  @override
  String get scanQrInstruction => 'Scan the QR code at the event door';

  @override
  String get scanQrAutomatic => 'The QR code will be scanned automatically';

  @override
  String get manualEntryTitle => 'Manual Entry';

  @override
  String get manualEntryDescription => 'Enter event ID manually';

  @override
  String get eventIdLabel => 'Event ID or QR Data';

  @override
  String get manualEntryProcess => 'Send';

  @override
  String get attendanceSuccess => 'Attendance Successful';

  @override
  String get generalAttendanceSuccess =>
      'Your general attendance has been recorded successfully!';

  @override
  String get presentationAttendanceSuccess =>
      'Your presentation attendance has been recorded successfully!';

  @override
  String get attendanceAlreadyTaken => 'Attendance Already Taken';

  @override
  String get generalAttendanceAlreadyTaken =>
      'Your general attendance has already been recorded.';

  @override
  String get presentationAttendanceAlreadyTaken =>
      'Your attendance for this presentation has already been recorded.';

  @override
  String get attendanceError => 'Attendance Error';

  @override
  String get notRegisteredForPresentation =>
      'You are not registered for this presentation.';

  @override
  String get invalidQrCode => 'Invalid QR code. Please scan the correct code.';

  @override
  String get processingAttendance => 'Processing attendance...';

  @override
  String get info => 'Info';

  @override
  String get notRegistered => 'Not Registered';

  @override
  String get invalidQr => 'Invalid QR Code';

  @override
  String get networkError => 'Please check your internet connection';

  @override
  String get serverError => 'Unable to reach server, please try again';

  @override
  String get timeoutError => 'Request timed out';

  @override
  String get unknownError => 'An unexpected error occurred';

  @override
  String get retryingConnection => 'Establishing connection...';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get requestCancelled => 'Request cancelled';

  @override
  String get authenticationError => 'Authentication error, please log in again';

  @override
  String get validationError => 'Please check your input';

  @override
  String get dataParseError => 'Error processing data';

  @override
  String get surveyFormLink =>
      'Click to access the presentation evaluation form';
}
