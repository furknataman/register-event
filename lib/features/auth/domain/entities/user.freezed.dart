// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$User {
  int get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get school => throw _privateConstructorUsedError;
  String? get branch => throw _privateConstructorUsedError;
  List<int>? get registeredEventIds => throw _privateConstructorUsedError;
  List<int>? get attendedEventIds => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {int id,
      String email,
      String name,
      String? phone,
      String? school,
      String? branch,
      List<int>? registeredEventIds,
      List<int>? attendedEventIds,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? phone = freezed,
    Object? school = freezed,
    Object? branch = freezed,
    Object? registeredEventIds = freezed,
    Object? attendedEventIds = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      school: freezed == school
          ? _value.school
          : school // ignore: cast_nullable_to_non_nullable
              as String?,
      branch: freezed == branch
          ? _value.branch
          : branch // ignore: cast_nullable_to_non_nullable
              as String?,
      registeredEventIds: freezed == registeredEventIds
          ? _value.registeredEventIds
          : registeredEventIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      attendedEventIds: freezed == attendedEventIds
          ? _value.attendedEventIds
          : attendedEventIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String email,
      String name,
      String? phone,
      String? school,
      String? branch,
      List<int>? registeredEventIds,
      List<int>? attendedEventIds,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? phone = freezed,
    Object? school = freezed,
    Object? branch = freezed,
    Object? registeredEventIds = freezed,
    Object? attendedEventIds = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      school: freezed == school
          ? _value.school
          : school // ignore: cast_nullable_to_non_nullable
              as String?,
      branch: freezed == branch
          ? _value.branch
          : branch // ignore: cast_nullable_to_non_nullable
              as String?,
      registeredEventIds: freezed == registeredEventIds
          ? _value._registeredEventIds
          : registeredEventIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      attendedEventIds: freezed == attendedEventIds
          ? _value._attendedEventIds
          : attendedEventIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$UserImpl implements _User {
  const _$UserImpl(
      {required this.id,
      required this.email,
      required this.name,
      this.phone,
      this.school,
      this.branch,
      final List<int>? registeredEventIds,
      final List<int>? attendedEventIds,
      this.createdAt,
      this.updatedAt})
      : _registeredEventIds = registeredEventIds,
        _attendedEventIds = attendedEventIds;

  @override
  final int id;
  @override
  final String email;
  @override
  final String name;
  @override
  final String? phone;
  @override
  final String? school;
  @override
  final String? branch;
  final List<int>? _registeredEventIds;
  @override
  List<int>? get registeredEventIds {
    final value = _registeredEventIds;
    if (value == null) return null;
    if (_registeredEventIds is EqualUnmodifiableListView)
      return _registeredEventIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<int>? _attendedEventIds;
  @override
  List<int>? get attendedEventIds {
    final value = _attendedEventIds;
    if (value == null) return null;
    if (_attendedEventIds is EqualUnmodifiableListView)
      return _attendedEventIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, phone: $phone, school: $school, branch: $branch, registeredEventIds: $registeredEventIds, attendedEventIds: $attendedEventIds, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.school, school) || other.school == school) &&
            (identical(other.branch, branch) || other.branch == branch) &&
            const DeepCollectionEquality()
                .equals(other._registeredEventIds, _registeredEventIds) &&
            const DeepCollectionEquality()
                .equals(other._attendedEventIds, _attendedEventIds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      name,
      phone,
      school,
      branch,
      const DeepCollectionEquality().hash(_registeredEventIds),
      const DeepCollectionEquality().hash(_attendedEventIds),
      createdAt,
      updatedAt);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);
}

abstract class _User implements User {
  const factory _User(
      {required final int id,
      required final String email,
      required final String name,
      final String? phone,
      final String? school,
      final String? branch,
      final List<int>? registeredEventIds,
      final List<int>? attendedEventIds,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$UserImpl;

  @override
  int get id;
  @override
  String get email;
  @override
  String get name;
  @override
  String? get phone;
  @override
  String? get school;
  @override
  String? get branch;
  @override
  List<int>? get registeredEventIds;
  @override
  List<int>? get attendedEventIds;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
