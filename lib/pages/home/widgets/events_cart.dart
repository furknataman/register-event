import 'package:autumn_conference/db/db_model/presentation_model.dart';
import 'package:autumn_conference/pages/events/event_page.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../global/date_time_converter.dart';

String truncateString(String str, int cutoff) {
  return (str.length <= cutoff) ? str : '${str.substring(0, cutoff)}...';
}

// Resim listesi - sırayla kullanılacak
const List<String> _lessonImages = [
  'assets/lesson_images/ADMINISTRATION.PNG',
  'assets/lesson_images/ARTS.PNG',
  'assets/lesson_images/BIOLOGY.png',
  'assets/lesson_images/CHEMISTRY.PNG',
  'assets/lesson_images/EARLY_YEARS.PNG',
  'assets/lesson_images/ESL.PNG',
  'assets/lesson_images/FOREIGN LANGUAGES.PNG',
  'assets/lesson_images/GENERAL_EDUCATION.PNG',
  'assets/lesson_images/GEOGRAPHY.png',
  'assets/lesson_images/GUIDANCE.PNG',
  'assets/lesson_images/HISTORY.PNG',
  'assets/lesson_images/IB_DP.PNG',
  'assets/lesson_images/IB_MYP.PNG',
  'assets/lesson_images/IB_PYP.PNG',
  'assets/lesson_images/INTERDISCIPLINARY.PNG',
  'assets/lesson_images/IT.png',
  'assets/lesson_images/LIBRARY.PNG',
  'assets/lesson_images/MATH.png',
  'assets/lesson_images/MUSIC.PNG',
  'assets/lesson_images/PE.png',
  'assets/lesson_images/PHILOSOPHY.png',
  'assets/lesson_images/PHYSICS.png',
  'assets/lesson_images/SCIENCE.png',
  'assets/lesson_images/SOCIAL_STUDIES.PNG',
  'assets/lesson_images/TURKISH.png',
];

// Event ID'ye göre sırayla resim döndür
String getImageByEventId(int? eventId) {
  if (eventId == null) return _lessonImages[0];
  return _lessonImages[eventId % _lessonImages.length];
}

// DEPRECATED: Branch'e göre resim seçimi (kullanılmıyor artık)
String imageName(String? eventName) {
  switch (eventName) {
    case 'Disiplinlerarası / INTERDISCIPLINARY':
      return ("assets/lesson_images/INTERDISCIPLINARY.PNG");
    case 'IB Orta Yıllar Programı / IB MYP':
      return ("assets/lesson_images/IB_MYP.PNG");
    case 'Beden Eğitimi / PE':
      return ("assets/lesson_images/PE.png");
    case 'Bilgi Teknolojisi / Information Technology':
      return ("assets/lesson_images/IT.png");
    case 'Biyoloji / BIOLOGY':
      return ("assets/lesson_images/BIOLOGY.png");
    case 'Coğrafya / GEOGRAPHY':
      return ("assets/lesson_images/GEOGRAPHY.png");
    case 'IB Diploma Programı / IB DP':
      return ("assets/lesson_images/IB_DP.PNG");
    case 'Felsefe / PHILOSOPHY':
      return ("assets/lesson_images/PHILOSOPHY.png");
    case 'Fen Bilgisi / SCIENCE':
      return ("assets/lesson_images/SCIENCE.png");
    case 'Fizik / PHYSICS':
      return ("assets/lesson_images/PHYSICS.png");
    case 'Genel Eğitim / GENERAL EDUCATION':
      return ("assets/lesson_images/GENERAL_EDUCATION.PNG");
    case 'IB İlk Yıllar Programı / IB PYP':
      return ("assets/lesson_images/IB_PYP.PNG");
    case 'Anaokulu / KINDERGARDEN':
      return ("assets/lesson_images/EARLY_YEARS.PNG");
    case 'İngilizce / ENGLISH':
      return ("assets/lesson_images/ESL.PNG");
    case 'Kimya / CHEMISTRY':
      return ("assets/lesson_images/CHEMISTRY.PNG");
    case 'Kütüphane / LIBRARY':
      return ("assets/lesson_images/LIBRARY.PNG");
    case 'Matematik / MATHS':
      return ("assets/lesson_images/MATH.png");
    case 'Müzik / MUSIC':
      return ("assets/lesson_images/MUSIC.PNG");
    case 'Rehberlik / GUIDANCE':
      return ("assets/lesson_images/GUIDANCE.PNG");
    case 'Resim / VISUAL ARTS':
      return ("assets/lesson_images/ARTS.PNG");
    case 'Sosyal Bilimler / SOCIAL STUDIES':
      return ("assets/lesson_images/SOCIAL_STUDIES.PNG");
    case 'Tarih / HISTORY':
      return ("assets/lesson_images/SOCIAL_STUDIES.PNG");
    case 'Türkçe - Türk Dili ve Edebiyatı / TURKISH - TURKISH LANGUAGE AND LITERATURE':
      return ("assets/lesson_images/TURKISH.png");
    case 'Yabancı Diller / FOREIGN LANGUAGES':
      return ("assets/lesson_images/FOREIGN LANGUAGES.PNG");
    case 'Yönetim / MANAGEMENT AND LEADERSHIP':
      return ("assets/lesson_images/ADMINISTRATION.PNG");
    default:
      return ("assets/lesson_images/GENERAL_EDUCATION.PNG");
  }
}

InkWell eventsCart(
  BuildContext context, {
  @required ClassModelPresentation? event,
  @required bool? eventCart,
}) {
  // Event ID'ye göre sırayla resim seç (görsel çeşitlilik için)
  String name = getImageByEventId(event!.id);

  int duration = int.parse(event.duration ?? "0");
  ClassTime time = classConverter(event.presentationTime!, duration);
  return InkWell(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => EventsPage(event.id, name)));
    },
    child: Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.loose,
        children: [
          Container(
            decoration: BoxDecoration(boxShadow: const [
              BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.15), blurRadius: 14, offset: Offset(0, 4))
            ], color: Theme.of(context).primaryColor, borderRadius: const BorderRadius.all(Radius.circular(13))),
            width: MediaQuery.of(context).size.width - 40,
            height: 270,
          ),
          Positioned(
            top: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
              width: MediaQuery.of(context).size.width - 40,
              height: 180,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    name,
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.only(top: 10, left: 13, right: 13, bottom: 13),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius:
                        const BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10))),
                height: 95,
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              truncateString(event.title!, 20),
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ),
                          Text(
                            "${time.clock} : ${time.endTime}",
                            style: Theme.of(context).textTheme.displayMedium,
                          )
                        ],
                      ),
                      FittedBox(
                        child: SizedBox(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              event.presenter1Name!,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            event.presenter2Name != null
                                ? Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 6, right: 6, top: 8),
                                        alignment: Alignment.center,
                                        width: 2,
                                        height: 2,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle, color: Theme.of(context).secondaryHeaderColor),
                                      ),
                                      Text(
                                        event.presenter2Name.toString(),
                                        style: Theme.of(context).textTheme.titleSmall,
                                      )
                                    ],
                                  )
                                : Container(),
                          ],
                        )),
                      ),
                      FittedBox(
                        child: Text(
                          event.school!,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ]),
              )),
          /* Positioned(
              top: 13,
              left: 30,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                height: 42,
                width: 62,
                child: Text(event.branch, style: Theme.of(context).textTheme.labelSmall),
              )),*/
          Positioned(
              top: 13,
              right: 30,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor, borderRadius: const BorderRadius.all(Radius.circular(5))),
                height: 38,
                width: 38,
                child: eventCart!
                    ? const Icon(LucideIcons.calendarCheck, size: 28, color: Color(0xffe43c2f))
                    : const Icon(LucideIcons.calendar, size: 28, color: Color(0xffBDBDBD)),
              )),
          Positioned(
              bottom: 105,
              left: 30,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor, borderRadius: const BorderRadius.all(Radius.circular(5))),
                height: 26,
                width: 170,
                child: FittedBox(
                  child: Text(
                    event.presentationPlace.toString(),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              )),
        ],
      ),
    ),
  );
}

Container textContainer(String? text, TextStyle? textStyle, {double bottomPadding = 1}) {
  return Container(
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.only(bottom: bottomPadding),
    child: Text(
      text!,
      style: textStyle,
      textAlign: TextAlign.start,
    ),
  );
}
