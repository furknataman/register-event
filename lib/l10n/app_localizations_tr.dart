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
}
