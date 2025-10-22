import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String email,
    required String name,
    String? phone,
    String? school,
    String? branch,
    List<int>? registeredEventIds,
    List<int>? attendedEventIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _User;
}