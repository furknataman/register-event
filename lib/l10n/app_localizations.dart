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
  /// **'Daily Schedule'**
  String get dailySchedule;

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
