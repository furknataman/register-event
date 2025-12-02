import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get hi;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @unregister.
  ///
  /// In en, this message translates to:
  /// **'Unregister'**
  String get unregister;

  /// No description provided for @full.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get full;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get upcoming;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @timeOfEvent.
  ///
  /// In en, this message translates to:
  /// **'Time of Event'**
  String get timeOfEvent;

  /// No description provided for @speakers.
  ///
  /// In en, this message translates to:
  /// **'Speakers'**
  String get speakers;

  /// No description provided for @capacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// No description provided for @freeSeats.
  ///
  /// In en, this message translates to:
  /// **'{remainingQuota} free seats left from {presentationQuota}'**
  String freeSeats(Object presentationQuota, Object remainingQuota);

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @scanqr.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code of \nyour event'**
  String get scanqr;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @filterProgram.
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get filterProgram;

  /// No description provided for @filterPresentationType.
  ///
  /// In en, this message translates to:
  /// **'Presentation Type'**
  String get filterPresentationType;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @startFrom.
  ///
  /// In en, this message translates to:
  /// **'Starting from'**
  String get startFrom;

  /// No description provided for @whatToShow.
  ///
  /// In en, this message translates to:
  /// **'What to show'**
  String get whatToShow;

  /// No description provided for @targetGroup.
  ///
  /// In en, this message translates to:
  /// **'Target group'**
  String get targetGroup;

  /// No description provided for @branch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branch;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @conferancesName.
  ///
  /// In en, this message translates to:
  /// **'Autumn Teachers Conference'**
  String get conferancesName;

  /// No description provided for @noPermission.
  ///
  /// In en, this message translates to:
  /// **'No Permission'**
  String get noPermission;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @pastEvent.
  ///
  /// In en, this message translates to:
  /// **'Past Events'**
  String get pastEvent;

  /// No description provided for @ongoingEvents.
  ///
  /// In en, this message translates to:
  /// **'Ongoing Events'**
  String get ongoingEvents;

  /// No description provided for @registeredEvents.
  ///
  /// In en, this message translates to:
  /// **'Registered Events'**
  String get registeredEvents;

  /// No description provided for @nonRegistered.
  ///
  /// In en, this message translates to:
  /// **'Non-Registered'**
  String get nonRegistered;

  /// No description provided for @nonRegisterMessage.
  ///
  /// In en, this message translates to:
  /// **'You are not registered the event that you have scanned.'**
  String get nonRegisterMessage;

  /// No description provided for @allreadyAttended.
  ///
  /// In en, this message translates to:
  /// **'Already Attended'**
  String get allreadyAttended;

  /// No description provided for @allReadyAttendedMessage.
  ///
  /// In en, this message translates to:
  /// **'You have already attended this event'**
  String get allReadyAttendedMessage;

  /// No description provided for @attendedEvent.
  ///
  /// In en, this message translates to:
  /// **'Join The Event'**
  String get attendedEvent;

  /// No description provided for @attendedEventMessage.
  ///
  /// In en, this message translates to:
  /// **'You are about to attend to {eventTitle}, are you sure?'**
  String attendedEventMessage(Object eventTitle);

  /// No description provided for @unrecognized.
  ///
  /// In en, this message translates to:
  /// **'Unrecognized Code'**
  String get unrecognized;

  /// No description provided for @unrecognizedMessage.
  ///
  /// In en, this message translates to:
  /// **'The code you have scanned cannot be recognized by our system. Please scan only the codes printed on doors.'**
  String get unrecognizedMessage;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Username or password is incorrect'**
  String get loginError;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Can you try again?'**
  String get connectionError;

  /// No description provided for @localNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'An event is near.'**
  String get localNotifTitle;

  /// No description provided for @localNotifBody.
  ///
  /// In en, this message translates to:
  /// **'{title} is starting by 10 minutes in {branch}. Don’t forget to scan the qr code.'**
  String localNotifBody(Object branch, Object title);

  /// No description provided for @noSeat.
  ///
  /// In en, this message translates to:
  /// **'Time Slot Full'**
  String get noSeat;

  /// No description provided for @appRate.
  ///
  /// In en, this message translates to:
  /// **'Evaluation Survey'**
  String get appRate;

  /// No description provided for @rollCallTitle.
  ///
  /// In en, this message translates to:
  /// **'Inspection'**
  String get rollCallTitle;

  /// No description provided for @rollCallBody.
  ///
  /// In en, this message translates to:
  /// **'Do you confirm the roll call?'**
  String get rollCallBody;

  /// No description provided for @scanAttendMessage.
  ///
  /// In en, this message translates to:
  /// **'Your event entry has been approved, you can log in.'**
  String get scanAttendMessage;

  /// No description provided for @generalForm.
  ///
  /// In en, this message translates to:
  /// **'Conference Evaluation Form'**
  String get generalForm;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Login Status'**
  String get status;

  /// No description provided for @canLogin.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get canLogin;

  /// No description provided for @dailySchedule.
  ///
  /// In en, this message translates to:
  /// **'My Program'**
  String get dailySchedule;

  /// No description provided for @campusMap.
  ///
  /// In en, this message translates to:
  /// **'Campus Map'**
  String get campusMap;

  /// No description provided for @eventLocation.
  ///
  /// In en, this message translates to:
  /// **'Event Location'**
  String get eventLocation;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @userInfo.
  ///
  /// In en, this message translates to:
  /// **'User Information'**
  String get userInfo;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @themeSelection.
  ///
  /// In en, this message translates to:
  /// **'Theme Selection'**
  String get themeSelection;

  /// No description provided for @languageSelection.
  ///
  /// In en, this message translates to:
  /// **'Language Selection'**
  String get languageSelection;

  /// No description provided for @noEventsYet.
  ///
  /// In en, this message translates to:
  /// **'No events yet'**
  String get noEventsYet;

  /// No description provided for @searchEvents.
  ///
  /// In en, this message translates to:
  /// **'Search events'**
  String get searchEvents;

  /// No description provided for @startSearching.
  ///
  /// In en, this message translates to:
  /// **'Start searching for events'**
  String get startSearching;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @noResultsFor.
  ///
  /// In en, this message translates to:
  /// **'No events found matching \"{query}\"'**
  String noResultsFor(Object query);

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// No description provided for @newNotificationsHere.
  ///
  /// In en, this message translates to:
  /// **'Your new notifications will appear here'**
  String get newNotificationsHere;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get turkish;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @themeSelected.
  ///
  /// In en, this message translates to:
  /// **'{theme} selected'**
  String themeSelected(Object theme);

  /// No description provided for @languageSelected.
  ///
  /// In en, this message translates to:
  /// **'{language} language selected'**
  String languageSelected(Object language);

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search for event, teacher or school...'**
  String get searchPlaceholder;

  /// No description provided for @noInstitutionInfo.
  ///
  /// In en, this message translates to:
  /// **'No institution info'**
  String get noInstitutionInfo;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @noTypeInfo.
  ///
  /// In en, this message translates to:
  /// **'No type info'**
  String get noTypeInfo;

  /// No description provided for @noBranchInfo.
  ///
  /// In en, this message translates to:
  /// **'No branch info'**
  String get noBranchInfo;

  /// No description provided for @noTitleInfo.
  ///
  /// In en, this message translates to:
  /// **'No Title'**
  String get noTitleInfo;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @session.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get session;

  /// No description provided for @session1.
  ///
  /// In en, this message translates to:
  /// **'1. Session'**
  String get session1;

  /// No description provided for @session2.
  ///
  /// In en, this message translates to:
  /// **'2. Session'**
  String get session2;

  /// No description provided for @session3.
  ///
  /// In en, this message translates to:
  /// **'3. Session'**
  String get session3;

  /// No description provided for @session4.
  ///
  /// In en, this message translates to:
  /// **'4. Session'**
  String get session4;

  /// No description provided for @myRegistrations.
  ///
  /// In en, this message translates to:
  /// **'My Registrations'**
  String get myRegistrations;

  /// No description provided for @eventInfoLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Event information could not be loaded'**
  String get eventInfoLoadFailed;

  /// No description provided for @operationFailed.
  ///
  /// In en, this message translates to:
  /// **'Operation failed'**
  String get operationFailed;

  /// No description provided for @userInfoFetchFailed.
  ///
  /// In en, this message translates to:
  /// **'User information could not be fetched'**
  String get userInfoFetchFailed;

  /// No description provided for @userInfoNotFound.
  ///
  /// In en, this message translates to:
  /// **'User information not found'**
  String get userInfoNotFound;

  /// No description provided for @userInfoLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading user information...'**
  String get userInfoLoading;

  /// No description provided for @unregistrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration cancelled'**
  String get unregistrationSuccess;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registrationSuccess;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @presentationPlace.
  ///
  /// In en, this message translates to:
  /// **'Presentation Place'**
  String get presentationPlace;

  /// No description provided for @presentationTime.
  ///
  /// In en, this message translates to:
  /// **'Presentation Time'**
  String get presentationTime;

  /// No description provided for @quota.
  ///
  /// In en, this message translates to:
  /// **'Quota'**
  String get quota;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @scheduleLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Schedule could not be loaded'**
  String get scheduleLoadFailed;

  /// No description provided for @qrCodeProcessFailed.
  ///
  /// In en, this message translates to:
  /// **'QR code could not be processed'**
  String get qrCodeProcessFailed;

  /// No description provided for @profileLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Profile could not be loaded'**
  String get profileLoadFailed;

  /// No description provided for @eventsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Events could not be loaded'**
  String get eventsLoadFailed;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @timeHasPassed.
  ///
  /// In en, this message translates to:
  /// **'Time Has Passed'**
  String get timeHasPassed;

  /// No description provided for @sameSessionRegistered.
  ///
  /// In en, this message translates to:
  /// **'Registered in Same Session'**
  String get sameSessionRegistered;

  /// No description provided for @quotaFull.
  ///
  /// In en, this message translates to:
  /// **'Quota Full'**
  String get quotaFull;

  /// No description provided for @presentationNotFound.
  ///
  /// In en, this message translates to:
  /// **'Presentation Not Found'**
  String get presentationNotFound;

  /// No description provided for @registeredTimePassed.
  ///
  /// In en, this message translates to:
  /// **'Registered (Time Passed)'**
  String get registeredTimePassed;

  /// No description provided for @attendanceTaken.
  ///
  /// In en, this message translates to:
  /// **'Attendance Taken'**
  String get attendanceTaken;

  /// No description provided for @generalAttendanceTaken.
  ///
  /// In en, this message translates to:
  /// **'General Attendance Taken'**
  String get generalAttendanceTaken;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @sendResetCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendResetCode;

  /// No description provided for @enterEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Email or Phone'**
  String get enterEmailOrPhone;

  /// No description provided for @resetViaEmail.
  ///
  /// In en, this message translates to:
  /// **'Via Email'**
  String get resetViaEmail;

  /// No description provided for @resetViaSms.
  ///
  /// In en, this message translates to:
  /// **'Via SMS'**
  String get resetViaSms;

  /// No description provided for @selectResetMethod.
  ///
  /// In en, this message translates to:
  /// **'Reset Method'**
  String get selectResetMethod;

  /// No description provided for @enterResetCode.
  ///
  /// In en, this message translates to:
  /// **'Reset Code'**
  String get enterResetCode;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Reset code sent'**
  String get resetCodeSent;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get passwordResetSuccess;

  /// No description provided for @passwordsMustMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords must match'**
  String get passwordsMustMatch;

  /// No description provided for @forgot_password_participant_not_found.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get forgot_password_participant_not_found;

  /// No description provided for @forgot_password_email_not_found.
  ///
  /// In en, this message translates to:
  /// **'No registered email found'**
  String get forgot_password_email_not_found;

  /// No description provided for @forgot_password_phone_not_found.
  ///
  /// In en, this message translates to:
  /// **'No registered phone number found'**
  String get forgot_password_phone_not_found;

  /// No description provided for @forgot_password_invalid_type.
  ///
  /// In en, this message translates to:
  /// **'Invalid reset method'**
  String get forgot_password_invalid_type;

  /// No description provided for @resetPassword_invalid_code.
  ///
  /// In en, this message translates to:
  /// **'Reset code is invalid or expired'**
  String get resetPassword_invalid_code;

  /// No description provided for @resetPassword_code_expired.
  ///
  /// In en, this message translates to:
  /// **'Reset code has expired'**
  String get resetPassword_code_expired;

  /// No description provided for @resetPassword_passwords_mismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get resetPassword_passwords_mismatch;

  /// No description provided for @resetPassword_update_failed.
  ///
  /// In en, this message translates to:
  /// **'Password update failed'**
  String get resetPassword_update_failed;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Code'**
  String get enterCode;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Reset'**
  String get resetPasswordTitle;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @confirmRegistration.
  ///
  /// In en, this message translates to:
  /// **'Do you want to confirm registration?'**
  String get confirmRegistration;

  /// No description provided for @confirmUnregistration.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel registration?'**
  String get confirmUnregistration;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhone;

  /// No description provided for @profileSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get profileSchool;

  /// No description provided for @profileJobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get profileJobTitle;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @attendedEvents.
  ///
  /// In en, this message translates to:
  /// **'Attended Events'**
  String get attendedEvents;

  /// No description provided for @profileInformation.
  ///
  /// In en, this message translates to:
  /// **'Profile Information'**
  String get profileInformation;

  /// No description provided for @notProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notProvided;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @appDevelopedBy.
  ///
  /// In en, this message translates to:
  /// **'This app is developed by Eyüboğlu Education Institutions'**
  String get appDevelopedBy;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get navScan;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @searchResultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} results found'**
  String searchResultsCount(Object count);

  /// No description provided for @scanPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanPageTitle;

  /// No description provided for @scanQrInstruction.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code at the event door'**
  String get scanQrInstruction;

  /// No description provided for @manualEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Manual Entry'**
  String get manualEntryTitle;

  /// No description provided for @manualEntryDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter event ID manually'**
  String get manualEntryDescription;

  /// No description provided for @eventIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Event ID or QR Data'**
  String get eventIdLabel;

  /// No description provided for @manualEntryProcess.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get manualEntryProcess;

  /// No description provided for @attendanceSuccess.
  ///
  /// In en, this message translates to:
  /// **'Attendance Successful'**
  String get attendanceSuccess;

  /// No description provided for @generalAttendanceSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your general attendance has been recorded successfully!'**
  String get generalAttendanceSuccess;

  /// No description provided for @presentationAttendanceSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your presentation attendance has been recorded successfully!'**
  String get presentationAttendanceSuccess;

  /// No description provided for @attendanceAlreadyTaken.
  ///
  /// In en, this message translates to:
  /// **'Attendance Already Taken'**
  String get attendanceAlreadyTaken;

  /// No description provided for @generalAttendanceAlreadyTaken.
  ///
  /// In en, this message translates to:
  /// **'Your general attendance has already been recorded.'**
  String get generalAttendanceAlreadyTaken;

  /// No description provided for @presentationAttendanceAlreadyTaken.
  ///
  /// In en, this message translates to:
  /// **'Your attendance for this presentation has already been recorded.'**
  String get presentationAttendanceAlreadyTaken;

  /// No description provided for @attendanceError.
  ///
  /// In en, this message translates to:
  /// **'Attendance Error'**
  String get attendanceError;

  /// No description provided for @notRegisteredForPresentation.
  ///
  /// In en, this message translates to:
  /// **'You are not registered for this presentation.'**
  String get notRegisteredForPresentation;

  /// No description provided for @invalidQrCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR code. Please scan the correct code.'**
  String get invalidQrCode;

  /// No description provided for @processingAttendance.
  ///
  /// In en, this message translates to:
  /// **'Processing attendance...'**
  String get processingAttendance;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @notRegistered.
  ///
  /// In en, this message translates to:
  /// **'Not Registered'**
  String get notRegistered;

  /// No description provided for @invalidQr.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR Code'**
  String get invalidQr;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Unable to reach server, please try again'**
  String get serverError;

  /// No description provided for @timeoutError.
  ///
  /// In en, this message translates to:
  /// **'Request timed out'**
  String get timeoutError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unknownError;

  /// No description provided for @retryingConnection.
  ///
  /// In en, this message translates to:
  /// **'Establishing connection...'**
  String get retryingConnection;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @requestCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get requestCancelled;

  /// No description provided for @authenticationError.
  ///
  /// In en, this message translates to:
  /// **'Authentication error, please log in again'**
  String get authenticationError;

  /// No description provided for @validationError.
  ///
  /// In en, this message translates to:
  /// **'Please check your input'**
  String get validationError;

  /// No description provided for @dataParseError.
  ///
  /// In en, this message translates to:
  /// **'Error processing data'**
  String get dataParseError;

  /// No description provided for @surveyFormLink.
  ///
  /// In en, this message translates to:
  /// **'Click to access the presentation evaluation form'**
  String get surveyFormLink;

  /// No description provided for @ibdaySurvey.
  ///
  /// In en, this message translates to:
  /// **'IBDAY Evaluation Survey'**
  String get ibdaySurvey;

  /// No description provided for @updateRequired.
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get updateRequired;

  /// No description provided for @updateRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Please update to continue using the app.'**
  String get updateRequiredMessage;

  /// No description provided for @currentVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Version'**
  String get currentVersionLabel;

  /// No description provided for @requiredVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Required Version'**
  String get requiredVersionLabel;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateNow;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
