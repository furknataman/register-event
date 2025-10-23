// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get hi => 'Merhaba';

  @override
  String get login => 'Giriş Yap';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String get register => 'Kayıt Ol';

  @override
  String get unregister => 'Kaydı Sil';

  @override
  String get full => 'Dolu';

  @override
  String get upcoming => 'Yaklaşan Etkinlikler';

  @override
  String get password => 'Şifre';

  @override
  String get timeOfEvent => 'Etkinlik Saati';

  @override
  String get speakers => 'Konuşmacılar';

  @override
  String get capacity => 'Kapasite';

  @override
  String freeSeats(Object presentationQuota, Object remainingQuota) {
    return '$remainingQuota adet boş yer kaldı, toplam kontenjan $presentationQuota';
  }

  @override
  String get description => 'Açıklama';

  @override
  String get scanqr => 'Etkinliğinizin \nQR kodunu tarayın';

  @override
  String get filters => 'Filtrele';

  @override
  String get reset => 'Sıfırla';

  @override
  String get ok => 'Tamam';

  @override
  String get cancel => 'İptal';

  @override
  String get startFrom => 'Başlangıç';

  @override
  String get whatToShow => 'Ne gösterilecek';

  @override
  String get targetGroup => 'Hedef grup';

  @override
  String get branch => 'Branş';

  @override
  String get past => 'Geçti';

  @override
  String get email => 'E-posta';

  @override
  String get conferancesName => 'Sonbahar Öğretmenler Konferansı';

  @override
  String get noPermission => 'Kamera erişim izni yok.';

  @override
  String get all => 'Hepsi';

  @override
  String get pastEvent => 'Geçmiş Etkinlikler';

  @override
  String get ongoingEvents => 'Devam Eden Etkinlikler';

  @override
  String get registeredEvents => 'Kayıtlı Etkinlikler';

  @override
  String get nonRegistered => 'Etkinlik Kayıtlı Değil';

  @override
  String get nonRegisterMessage => 'Taradığınız etkinlik kayıtlı değil.';

  @override
  String get allreadyAttended => 'Etkinliğe Katıldınız';

  @override
  String get allReadyAttendedMessage => 'Bu etkinliğe zaten katıldınız.';

  @override
  String get attendedEvent => 'Etkinliğe Katıl.';

  @override
  String attendedEventMessage(Object eventTitle) {
    return '$eventTitle etkinliğine katılmak üzeresiniz, emin misiniz?';
  }

  @override
  String get unrecognized => 'Tanınmayan Kod';

  @override
  String get unrecognizedMessage =>
      'Taradığınız kod sistemimiz tarafından tanınamıyor. Lütfen yalnızca kapıların üzerinde yazılı olan kodları tarayın.';

  @override
  String get loginError => 'Kullanıcı adı veya şifre hatalı';

  @override
  String get connectionError => 'Bir hata oluştu. Tekrar deneyebilir misiniz?';

  @override
  String get localNotifTitle => 'Bir etkinlik yaklaşıyor.';

  @override
  String localNotifBody(Object branch, Object title) {
    return '\$$title 10 dakika sonra \$$branch\'da başlıyor. QR kodu taramayı unutmayın.';
  }

  @override
  String get noSeat => 'Zaman Aralığı Dolu';

  @override
  String get appRate => 'Değerlendirme Anketi';

  @override
  String get rollCallTitle => 'Yoklama';

  @override
  String get rollCallBody => 'Yoklamayı onaylıyor musunuz?';

  @override
  String get scanAttendMessage =>
      'Etkinlik girişiniz onaylandı, giriş yapabilirsiniz.';

  @override
  String get generalForm => 'Konferans Değerlendirme Formu';

  @override
  String get status => 'Giriş Durumu';

  @override
  String get canLogin => 'Giriş Yapabilir.';

  @override
  String get dailySchedule => 'Günlük Program';

  @override
  String get eventLocation => 'Etkinlik Yeri';

  @override
  String get profile => 'Profil';

  @override
  String get userInfo => 'Kullanıcı Bilgileri';

  @override
  String get changePassword => 'Şifre Değiştir';

  @override
  String get themeSelection => 'Tema Seçimi';

  @override
  String get languageSelection => 'Dil Seçimi';

  @override
  String get noEventsYet => 'Henüz etkinlik yok';

  @override
  String get searchEvents => 'Etkinlik ara';

  @override
  String get startSearching => 'Etkinlik aramaya başlayın';

  @override
  String get noResults => 'Sonuç bulunamadı';

  @override
  String noResultsFor(Object query) {
    return '\"$query\" için eşleşen etkinlik bulunamadı';
  }

  @override
  String get notifications => 'Bildirimler';

  @override
  String get noNotifications => 'Henüz bildirim yok';

  @override
  String get newNotificationsHere => 'Yeni bildirimleriniz burada görünecek';

  @override
  String get lightTheme => 'Açık Tema';

  @override
  String get darkTheme => 'Koyu Tema';

  @override
  String get systemTheme => 'Sistem';

  @override
  String get turkish => 'Türkçe';

  @override
  String get english => 'English';

  @override
  String get settings => 'Ayarlar';

  @override
  String get areYouSure => 'Emin misiniz?';

  @override
  String get logoutConfirmation => 'Çıkış yapmak istediğinizden emin misiniz?';

  @override
  String get error => 'Hata';

  @override
  String get anErrorOccurred => 'Bir hata oluştu';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get loading => 'Yükleniyor';

  @override
  String themeSelected(Object theme) {
    return '$theme seçildi';
  }

  @override
  String languageSelected(Object language) {
    return '$language dili seçildi';
  }

  @override
  String get searchPlaceholder => 'Etkinlik, öğretmen veya okul ara...';

  @override
  String get noInstitutionInfo => 'Kurum bilgisi yok';

  @override
  String get minutes => 'dakika';

  @override
  String get noTypeInfo => 'Tip bilgisi yok';

  @override
  String get noBranchInfo => 'Alan bilgisi yok';

  @override
  String get noTitleInfo => 'Başlık Yok';

  @override
  String get categoryAll => 'Tümü';

  @override
  String get session => 'Oturum';

  @override
  String get session1 => 'Oturum 1';

  @override
  String get session2 => 'Oturum 2';

  @override
  String get session3 => 'Oturum 3';

  @override
  String get session4 => 'Oturum 4';

  @override
  String get myRegistrations => 'Kayıt Olduklarım';
}
