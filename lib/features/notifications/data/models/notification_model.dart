import 'package:flutter/material.dart';

class NotificationModel {
  final int id;
  final String titleTr;
  final String titleEn;
  final String messageTr;
  final String messageEn;
  final bool isRead;
  final String type;
  final int? relatedId;
  final String? imageUrl;
  final String? actionUrl;
  final DateTime createdAt;
  final DateTime? readAt;

  NotificationModel({
    required this.id,
    required this.titleTr,
    required this.titleEn,
    required this.messageTr,
    required this.messageEn,
    required this.isRead,
    required this.type,
    this.relatedId,
    this.imageUrl,
    this.actionUrl,
    required this.createdAt,
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      titleTr: json['titleTr'] as String,
      titleEn: json['titleEn'] as String,
      messageTr: json['messageTr'] as String,
      messageEn: json['messageEn'] as String,
      isRead: json['isRead'] as bool,
      type: json['type'] as String,
      relatedId: json['relatedId'] as int?,
      imageUrl: json['imageUrl'] as String?,
      actionUrl: json['actionUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleTr': titleTr,
      'titleEn': titleEn,
      'messageTr': messageTr,
      'messageEn': messageEn,
      'isRead': isRead,
      'type': type,
      'relatedId': relatedId,
      'imageUrl': imageUrl,
      'actionUrl': actionUrl,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
    };
  }

  String getTitle(Locale locale) {
    return locale.languageCode == 'tr' ? titleTr : titleEn;
  }

  String getMessage(Locale locale) {
    return locale.languageCode == 'tr' ? messageTr : messageEn;
  }

  NotificationModel copyWith({
    int? id,
    String? titleTr,
    String? titleEn,
    String? messageTr,
    String? messageEn,
    bool? isRead,
    String? type,
    int? relatedId,
    String? imageUrl,
    String? actionUrl,
    DateTime? createdAt,
    DateTime? readAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      titleTr: titleTr ?? this.titleTr,
      titleEn: titleEn ?? this.titleEn,
      messageTr: messageTr ?? this.messageTr,
      messageEn: messageEn ?? this.messageEn,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      relatedId: relatedId ?? this.relatedId,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
    );
  }
}

class NotificationResponseModel {
  final bool success;
  final List<NotificationModel> data;
  final int count;
  final int page;

  NotificationResponseModel({
    required this.success,
    required this.data,
    required this.count,
    required this.page,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      success: json['success'] as bool,
      data: (json['data'] as List)
          .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int,
      page: json['page'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((item) => item.toJson()).toList(),
      'count': count,
      'page': page,
    };
  }
}

class UnreadCountResponseModel {
  final bool success;
  final int unreadCount;

  UnreadCountResponseModel({
    required this.success,
    required this.unreadCount,
  });

  factory UnreadCountResponseModel.fromJson(Map<String, dynamic> json) {
    return UnreadCountResponseModel(
      success: json['success'] as bool,
      unreadCount: json['unreadCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'unreadCount': unreadCount,
    };
  }
}
