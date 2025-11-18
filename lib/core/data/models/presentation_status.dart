import 'package:flutter/material.dart';

enum PresentationStatus {
  presentationNotFound(0),
  canRegister(1),
  alreadyRegistered(2),
  timePassed(3),
  sameSessionRegistered(4),
  quotaFull(5),
  registeredButTimePassed(6),
  attendanceTaken(7);

  const PresentationStatus(this.value);
  final int value;

  static PresentationStatus fromValue(int? value) {
    switch (value) {
      case 0:
        return PresentationStatus.presentationNotFound;
      case 1:
        return PresentationStatus.canRegister;
      case 2:
        return PresentationStatus.alreadyRegistered;
      case 3:
        return PresentationStatus.timePassed;
      case 4:
        return PresentationStatus.sameSessionRegistered;
      case 5:
        return PresentationStatus.quotaFull;
      case 6:
        return PresentationStatus.registeredButTimePassed;
      case 7:
        return PresentationStatus.attendanceTaken;
      default:
        return PresentationStatus.presentationNotFound;
    }
  }
}

extension PresentationStatusExtension on PresentationStatus {
  bool get canRegisterOrUnregister {
    return this == PresentationStatus.canRegister ||
        this == PresentationStatus.alreadyRegistered;
  }

  bool get isDisabled {
    return this == PresentationStatus.timePassed ||
        this == PresentationStatus.sameSessionRegistered ||
        this == PresentationStatus.quotaFull ||
        this == PresentationStatus.registeredButTimePassed ||
        this == PresentationStatus.attendanceTaken;
  }

  bool get showUnregisterButton {
    return this == PresentationStatus.alreadyRegistered ||
        this == PresentationStatus.registeredButTimePassed;
  }

  bool get showErrorMessage {
    return this == PresentationStatus.presentationNotFound;
  }

  String getIconPath() {
    switch (this) {
      case PresentationStatus.canRegister:
        return 'assets/svg/bookmark.svg';
      case PresentationStatus.alreadyRegistered:
        return 'assets/svg/bookmark-slash.svg';
      case PresentationStatus.timePassed:
        return 'assets/svg/hourglass-end.svg';
      case PresentationStatus.sameSessionRegistered:
        return 'assets/svg/calendar-xmark.svg';
      case PresentationStatus.quotaFull:
        return 'assets/svg/ban.svg';
      case PresentationStatus.registeredButTimePassed:
        return 'assets/svg/bookmark-slash.svg';
      case PresentationStatus.attendanceTaken:
        return 'assets/svg/circle-check.svg';
      case PresentationStatus.presentationNotFound:
        return 'assets/svg/circle-xmark.svg';
    }
  }

  List<dynamic> getButtonColors() {
    switch (this) {
      case PresentationStatus.canRegister:
        // Varsayılan mavi-mor gradient
        return [
          const Color(0xFF667eea),
          const Color(0xFF764ba2),
        ];
      case PresentationStatus.alreadyRegistered:
        // Kırmızı tonları
        return [
          const Color(0xFFe53935),
          const Color(0xFFc62828),
        ];
      case PresentationStatus.attendanceTaken:
        // Yeşil tonları
        return [
          const Color(0xFF4caf50),
          const Color(0xFF388e3c),
        ];
      case PresentationStatus.timePassed:
      case PresentationStatus.sameSessionRegistered:
      case PresentationStatus.quotaFull:
      case PresentationStatus.registeredButTimePassed:
      case PresentationStatus.presentationNotFound:
        // Tüm disabled durumlar için gri tonları
        return [
          const Color(0xFF757575),
          const Color(0xFF616161),
        ];
    }
  }
}
