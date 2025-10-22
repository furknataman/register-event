// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventModel _$EventModelFromJson(Map<String, dynamic> json) {
  return _EventModel.fromJson(json);
}

/// @nodoc
mixin _$EventModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  DateTime get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  DateTime get endTime => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String get speaker => throw _privateConstructorUsedError;
  @JsonKey(name: 'speaker_title')
  String? get speakerTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_participants')
  int get maxParticipants => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_participants')
  int get currentParticipants => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_registered')
  bool get isRegistered => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_attended')
  bool get isAttended => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  String? get materials => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this EventModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventModelCopyWith<EventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventModelCopyWith<$Res> {
  factory $EventModelCopyWith(
          EventModel value, $Res Function(EventModel) then) =
      _$EventModelCopyWithImpl<$Res, EventModel>;
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      @JsonKey(name: 'start_time') DateTime startTime,
      @JsonKey(name: 'end_time') DateTime endTime,
      String location,
      String speaker,
      @JsonKey(name: 'speaker_title') String? speakerTitle,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'max_participants') int maxParticipants,
      @JsonKey(name: 'current_participants') int currentParticipants,
      @JsonKey(name: 'is_registered') bool isRegistered,
      @JsonKey(name: 'is_attended') bool isAttended,
      List<String>? tags,
      String? materials,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$EventModelCopyWithImpl<$Res, $Val extends EventModel>
    implements $EventModelCopyWith<$Res> {
  _$EventModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? location = null,
    Object? speaker = null,
    Object? speakerTitle = freezed,
    Object? imageUrl = freezed,
    Object? maxParticipants = null,
    Object? currentParticipants = null,
    Object? isRegistered = null,
    Object? isAttended = null,
    Object? tags = freezed,
    Object? materials = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      speaker: null == speaker
          ? _value.speaker
          : speaker // ignore: cast_nullable_to_non_nullable
              as String,
      speakerTitle: freezed == speakerTitle
          ? _value.speakerTitle
          : speakerTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      maxParticipants: null == maxParticipants
          ? _value.maxParticipants
          : maxParticipants // ignore: cast_nullable_to_non_nullable
              as int,
      currentParticipants: null == currentParticipants
          ? _value.currentParticipants
          : currentParticipants // ignore: cast_nullable_to_non_nullable
              as int,
      isRegistered: null == isRegistered
          ? _value.isRegistered
          : isRegistered // ignore: cast_nullable_to_non_nullable
              as bool,
      isAttended: null == isAttended
          ? _value.isAttended
          : isAttended // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      materials: freezed == materials
          ? _value.materials
          : materials // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$EventModelImplCopyWith<$Res>
    implements $EventModelCopyWith<$Res> {
  factory _$$EventModelImplCopyWith(
          _$EventModelImpl value, $Res Function(_$EventModelImpl) then) =
      __$$EventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      @JsonKey(name: 'start_time') DateTime startTime,
      @JsonKey(name: 'end_time') DateTime endTime,
      String location,
      String speaker,
      @JsonKey(name: 'speaker_title') String? speakerTitle,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'max_participants') int maxParticipants,
      @JsonKey(name: 'current_participants') int currentParticipants,
      @JsonKey(name: 'is_registered') bool isRegistered,
      @JsonKey(name: 'is_attended') bool isAttended,
      List<String>? tags,
      String? materials,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$EventModelImplCopyWithImpl<$Res>
    extends _$EventModelCopyWithImpl<$Res, _$EventModelImpl>
    implements _$$EventModelImplCopyWith<$Res> {
  __$$EventModelImplCopyWithImpl(
      _$EventModelImpl _value, $Res Function(_$EventModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? location = null,
    Object? speaker = null,
    Object? speakerTitle = freezed,
    Object? imageUrl = freezed,
    Object? maxParticipants = null,
    Object? currentParticipants = null,
    Object? isRegistered = null,
    Object? isAttended = null,
    Object? tags = freezed,
    Object? materials = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$EventModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      speaker: null == speaker
          ? _value.speaker
          : speaker // ignore: cast_nullable_to_non_nullable
              as String,
      speakerTitle: freezed == speakerTitle
          ? _value.speakerTitle
          : speakerTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      maxParticipants: null == maxParticipants
          ? _value.maxParticipants
          : maxParticipants // ignore: cast_nullable_to_non_nullable
              as int,
      currentParticipants: null == currentParticipants
          ? _value.currentParticipants
          : currentParticipants // ignore: cast_nullable_to_non_nullable
              as int,
      isRegistered: null == isRegistered
          ? _value.isRegistered
          : isRegistered // ignore: cast_nullable_to_non_nullable
              as bool,
      isAttended: null == isAttended
          ? _value.isAttended
          : isAttended // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      materials: freezed == materials
          ? _value.materials
          : materials // ignore: cast_nullable_to_non_nullable
              as String?,
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
@JsonSerializable()
class _$EventModelImpl implements _EventModel {
  const _$EventModelImpl(
      {required this.id,
      required this.title,
      required this.description,
      @JsonKey(name: 'start_time') required this.startTime,
      @JsonKey(name: 'end_time') required this.endTime,
      required this.location,
      required this.speaker,
      @JsonKey(name: 'speaker_title') this.speakerTitle,
      @JsonKey(name: 'image_url') this.imageUrl,
      @JsonKey(name: 'max_participants') required this.maxParticipants,
      @JsonKey(name: 'current_participants') required this.currentParticipants,
      @JsonKey(name: 'is_registered') required this.isRegistered,
      @JsonKey(name: 'is_attended') required this.isAttended,
      final List<String>? tags,
      this.materials,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _tags = tags;

  factory _$EventModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String description;
  @override
  @JsonKey(name: 'start_time')
  final DateTime startTime;
  @override
  @JsonKey(name: 'end_time')
  final DateTime endTime;
  @override
  final String location;
  @override
  final String speaker;
  @override
  @JsonKey(name: 'speaker_title')
  final String? speakerTitle;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'max_participants')
  final int maxParticipants;
  @override
  @JsonKey(name: 'current_participants')
  final int currentParticipants;
  @override
  @JsonKey(name: 'is_registered')
  final bool isRegistered;
  @override
  @JsonKey(name: 'is_attended')
  final bool isAttended;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? materials;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'EventModel(id: $id, title: $title, description: $description, startTime: $startTime, endTime: $endTime, location: $location, speaker: $speaker, speakerTitle: $speakerTitle, imageUrl: $imageUrl, maxParticipants: $maxParticipants, currentParticipants: $currentParticipants, isRegistered: $isRegistered, isAttended: $isAttended, tags: $tags, materials: $materials, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.speaker, speaker) || other.speaker == speaker) &&
            (identical(other.speakerTitle, speakerTitle) ||
                other.speakerTitle == speakerTitle) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.maxParticipants, maxParticipants) ||
                other.maxParticipants == maxParticipants) &&
            (identical(other.currentParticipants, currentParticipants) ||
                other.currentParticipants == currentParticipants) &&
            (identical(other.isRegistered, isRegistered) ||
                other.isRegistered == isRegistered) &&
            (identical(other.isAttended, isAttended) ||
                other.isAttended == isAttended) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.materials, materials) ||
                other.materials == materials) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      startTime,
      endTime,
      location,
      speaker,
      speakerTitle,
      imageUrl,
      maxParticipants,
      currentParticipants,
      isRegistered,
      isAttended,
      const DeepCollectionEquality().hash(_tags),
      materials,
      createdAt,
      updatedAt);

  /// Create a copy of EventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventModelImplCopyWith<_$EventModelImpl> get copyWith =>
      __$$EventModelImplCopyWithImpl<_$EventModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventModelImplToJson(
      this,
    );
  }
}

abstract class _EventModel implements EventModel {
  const factory _EventModel(
          {required final int id,
          required final String title,
          required final String description,
          @JsonKey(name: 'start_time') required final DateTime startTime,
          @JsonKey(name: 'end_time') required final DateTime endTime,
          required final String location,
          required final String speaker,
          @JsonKey(name: 'speaker_title') final String? speakerTitle,
          @JsonKey(name: 'image_url') final String? imageUrl,
          @JsonKey(name: 'max_participants') required final int maxParticipants,
          @JsonKey(name: 'current_participants')
          required final int currentParticipants,
          @JsonKey(name: 'is_registered') required final bool isRegistered,
          @JsonKey(name: 'is_attended') required final bool isAttended,
          final List<String>? tags,
          final String? materials,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$EventModelImpl;

  factory _EventModel.fromJson(Map<String, dynamic> json) =
      _$EventModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get description;
  @override
  @JsonKey(name: 'start_time')
  DateTime get startTime;
  @override
  @JsonKey(name: 'end_time')
  DateTime get endTime;
  @override
  String get location;
  @override
  String get speaker;
  @override
  @JsonKey(name: 'speaker_title')
  String? get speakerTitle;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'max_participants')
  int get maxParticipants;
  @override
  @JsonKey(name: 'current_participants')
  int get currentParticipants;
  @override
  @JsonKey(name: 'is_registered')
  bool get isRegistered;
  @override
  @JsonKey(name: 'is_attended')
  bool get isAttended;
  @override
  List<String>? get tags;
  @override
  String? get materials;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of EventModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventModelImplCopyWith<_$EventModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LegacyEventModel _$LegacyEventModelFromJson(Map<String, dynamic> json) {
  return _LegacyEventModel.fromJson(json);
}

/// @nodoc
mixin _$LegacyEventModel {
  int? get id => throw _privateConstructorUsedError;
  String? get baslik => throw _privateConstructorUsedError;
  String? get aciklama => throw _privateConstructorUsedError;
  String? get sunumTarihi => throw _privateConstructorUsedError;
  String? get sunumSaati => throw _privateConstructorUsedError;
  String? get bitisSaati => throw _privateConstructorUsedError;
  String? get sunumYeri => throw _privateConstructorUsedError;
  String? get sunucu => throw _privateConstructorUsedError;
  String? get sunucuUnvani => throw _privateConstructorUsedError;
  String? get resimUrl => throw _privateConstructorUsedError;
  int? get maxKatilimci => throw _privateConstructorUsedError;
  int? get mevcutKatilimci => throw _privateConstructorUsedError;
  bool? get kayitli => throw _privateConstructorUsedError;
  bool? get katildi => throw _privateConstructorUsedError;
  String? get etiketler => throw _privateConstructorUsedError;
  String? get materyaller => throw _privateConstructorUsedError;

  /// Serializes this LegacyEventModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LegacyEventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LegacyEventModelCopyWith<LegacyEventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LegacyEventModelCopyWith<$Res> {
  factory $LegacyEventModelCopyWith(
          LegacyEventModel value, $Res Function(LegacyEventModel) then) =
      _$LegacyEventModelCopyWithImpl<$Res, LegacyEventModel>;
  @useResult
  $Res call(
      {int? id,
      String? baslik,
      String? aciklama,
      String? sunumTarihi,
      String? sunumSaati,
      String? bitisSaati,
      String? sunumYeri,
      String? sunucu,
      String? sunucuUnvani,
      String? resimUrl,
      int? maxKatilimci,
      int? mevcutKatilimci,
      bool? kayitli,
      bool? katildi,
      String? etiketler,
      String? materyaller});
}

/// @nodoc
class _$LegacyEventModelCopyWithImpl<$Res, $Val extends LegacyEventModel>
    implements $LegacyEventModelCopyWith<$Res> {
  _$LegacyEventModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LegacyEventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? baslik = freezed,
    Object? aciklama = freezed,
    Object? sunumTarihi = freezed,
    Object? sunumSaati = freezed,
    Object? bitisSaati = freezed,
    Object? sunumYeri = freezed,
    Object? sunucu = freezed,
    Object? sunucuUnvani = freezed,
    Object? resimUrl = freezed,
    Object? maxKatilimci = freezed,
    Object? mevcutKatilimci = freezed,
    Object? kayitli = freezed,
    Object? katildi = freezed,
    Object? etiketler = freezed,
    Object? materyaller = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      baslik: freezed == baslik
          ? _value.baslik
          : baslik // ignore: cast_nullable_to_non_nullable
              as String?,
      aciklama: freezed == aciklama
          ? _value.aciklama
          : aciklama // ignore: cast_nullable_to_non_nullable
              as String?,
      sunumTarihi: freezed == sunumTarihi
          ? _value.sunumTarihi
          : sunumTarihi // ignore: cast_nullable_to_non_nullable
              as String?,
      sunumSaati: freezed == sunumSaati
          ? _value.sunumSaati
          : sunumSaati // ignore: cast_nullable_to_non_nullable
              as String?,
      bitisSaati: freezed == bitisSaati
          ? _value.bitisSaati
          : bitisSaati // ignore: cast_nullable_to_non_nullable
              as String?,
      sunumYeri: freezed == sunumYeri
          ? _value.sunumYeri
          : sunumYeri // ignore: cast_nullable_to_non_nullable
              as String?,
      sunucu: freezed == sunucu
          ? _value.sunucu
          : sunucu // ignore: cast_nullable_to_non_nullable
              as String?,
      sunucuUnvani: freezed == sunucuUnvani
          ? _value.sunucuUnvani
          : sunucuUnvani // ignore: cast_nullable_to_non_nullable
              as String?,
      resimUrl: freezed == resimUrl
          ? _value.resimUrl
          : resimUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      maxKatilimci: freezed == maxKatilimci
          ? _value.maxKatilimci
          : maxKatilimci // ignore: cast_nullable_to_non_nullable
              as int?,
      mevcutKatilimci: freezed == mevcutKatilimci
          ? _value.mevcutKatilimci
          : mevcutKatilimci // ignore: cast_nullable_to_non_nullable
              as int?,
      kayitli: freezed == kayitli
          ? _value.kayitli
          : kayitli // ignore: cast_nullable_to_non_nullable
              as bool?,
      katildi: freezed == katildi
          ? _value.katildi
          : katildi // ignore: cast_nullable_to_non_nullable
              as bool?,
      etiketler: freezed == etiketler
          ? _value.etiketler
          : etiketler // ignore: cast_nullable_to_non_nullable
              as String?,
      materyaller: freezed == materyaller
          ? _value.materyaller
          : materyaller // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LegacyEventModelImplCopyWith<$Res>
    implements $LegacyEventModelCopyWith<$Res> {
  factory _$$LegacyEventModelImplCopyWith(_$LegacyEventModelImpl value,
          $Res Function(_$LegacyEventModelImpl) then) =
      __$$LegacyEventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? baslik,
      String? aciklama,
      String? sunumTarihi,
      String? sunumSaati,
      String? bitisSaati,
      String? sunumYeri,
      String? sunucu,
      String? sunucuUnvani,
      String? resimUrl,
      int? maxKatilimci,
      int? mevcutKatilimci,
      bool? kayitli,
      bool? katildi,
      String? etiketler,
      String? materyaller});
}

/// @nodoc
class __$$LegacyEventModelImplCopyWithImpl<$Res>
    extends _$LegacyEventModelCopyWithImpl<$Res, _$LegacyEventModelImpl>
    implements _$$LegacyEventModelImplCopyWith<$Res> {
  __$$LegacyEventModelImplCopyWithImpl(_$LegacyEventModelImpl _value,
      $Res Function(_$LegacyEventModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LegacyEventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? baslik = freezed,
    Object? aciklama = freezed,
    Object? sunumTarihi = freezed,
    Object? sunumSaati = freezed,
    Object? bitisSaati = freezed,
    Object? sunumYeri = freezed,
    Object? sunucu = freezed,
    Object? sunucuUnvani = freezed,
    Object? resimUrl = freezed,
    Object? maxKatilimci = freezed,
    Object? mevcutKatilimci = freezed,
    Object? kayitli = freezed,
    Object? katildi = freezed,
    Object? etiketler = freezed,
    Object? materyaller = freezed,
  }) {
    return _then(_$LegacyEventModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      baslik: freezed == baslik
          ? _value.baslik
          : baslik // ignore: cast_nullable_to_non_nullable
              as String?,
      aciklama: freezed == aciklama
          ? _value.aciklama
          : aciklama // ignore: cast_nullable_to_non_nullable
              as String?,
      sunumTarihi: freezed == sunumTarihi
          ? _value.sunumTarihi
          : sunumTarihi // ignore: cast_nullable_to_non_nullable
              as String?,
      sunumSaati: freezed == sunumSaati
          ? _value.sunumSaati
          : sunumSaati // ignore: cast_nullable_to_non_nullable
              as String?,
      bitisSaati: freezed == bitisSaati
          ? _value.bitisSaati
          : bitisSaati // ignore: cast_nullable_to_non_nullable
              as String?,
      sunumYeri: freezed == sunumYeri
          ? _value.sunumYeri
          : sunumYeri // ignore: cast_nullable_to_non_nullable
              as String?,
      sunucu: freezed == sunucu
          ? _value.sunucu
          : sunucu // ignore: cast_nullable_to_non_nullable
              as String?,
      sunucuUnvani: freezed == sunucuUnvani
          ? _value.sunucuUnvani
          : sunucuUnvani // ignore: cast_nullable_to_non_nullable
              as String?,
      resimUrl: freezed == resimUrl
          ? _value.resimUrl
          : resimUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      maxKatilimci: freezed == maxKatilimci
          ? _value.maxKatilimci
          : maxKatilimci // ignore: cast_nullable_to_non_nullable
              as int?,
      mevcutKatilimci: freezed == mevcutKatilimci
          ? _value.mevcutKatilimci
          : mevcutKatilimci // ignore: cast_nullable_to_non_nullable
              as int?,
      kayitli: freezed == kayitli
          ? _value.kayitli
          : kayitli // ignore: cast_nullable_to_non_nullable
              as bool?,
      katildi: freezed == katildi
          ? _value.katildi
          : katildi // ignore: cast_nullable_to_non_nullable
              as bool?,
      etiketler: freezed == etiketler
          ? _value.etiketler
          : etiketler // ignore: cast_nullable_to_non_nullable
              as String?,
      materyaller: freezed == materyaller
          ? _value.materyaller
          : materyaller // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LegacyEventModelImpl implements _LegacyEventModel {
  const _$LegacyEventModelImpl(
      {this.id,
      this.baslik,
      this.aciklama,
      this.sunumTarihi,
      this.sunumSaati,
      this.bitisSaati,
      this.sunumYeri,
      this.sunucu,
      this.sunucuUnvani,
      this.resimUrl,
      this.maxKatilimci,
      this.mevcutKatilimci,
      this.kayitli,
      this.katildi,
      this.etiketler,
      this.materyaller});

  factory _$LegacyEventModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LegacyEventModelImplFromJson(json);

  @override
  final int? id;
  @override
  final String? baslik;
  @override
  final String? aciklama;
  @override
  final String? sunumTarihi;
  @override
  final String? sunumSaati;
  @override
  final String? bitisSaati;
  @override
  final String? sunumYeri;
  @override
  final String? sunucu;
  @override
  final String? sunucuUnvani;
  @override
  final String? resimUrl;
  @override
  final int? maxKatilimci;
  @override
  final int? mevcutKatilimci;
  @override
  final bool? kayitli;
  @override
  final bool? katildi;
  @override
  final String? etiketler;
  @override
  final String? materyaller;

  @override
  String toString() {
    return 'LegacyEventModel(id: $id, baslik: $baslik, aciklama: $aciklama, sunumTarihi: $sunumTarihi, sunumSaati: $sunumSaati, bitisSaati: $bitisSaati, sunumYeri: $sunumYeri, sunucu: $sunucu, sunucuUnvani: $sunucuUnvani, resimUrl: $resimUrl, maxKatilimci: $maxKatilimci, mevcutKatilimci: $mevcutKatilimci, kayitli: $kayitli, katildi: $katildi, etiketler: $etiketler, materyaller: $materyaller)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LegacyEventModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.baslik, baslik) || other.baslik == baslik) &&
            (identical(other.aciklama, aciklama) ||
                other.aciklama == aciklama) &&
            (identical(other.sunumTarihi, sunumTarihi) ||
                other.sunumTarihi == sunumTarihi) &&
            (identical(other.sunumSaati, sunumSaati) ||
                other.sunumSaati == sunumSaati) &&
            (identical(other.bitisSaati, bitisSaati) ||
                other.bitisSaati == bitisSaati) &&
            (identical(other.sunumYeri, sunumYeri) ||
                other.sunumYeri == sunumYeri) &&
            (identical(other.sunucu, sunucu) || other.sunucu == sunucu) &&
            (identical(other.sunucuUnvani, sunucuUnvani) ||
                other.sunucuUnvani == sunucuUnvani) &&
            (identical(other.resimUrl, resimUrl) ||
                other.resimUrl == resimUrl) &&
            (identical(other.maxKatilimci, maxKatilimci) ||
                other.maxKatilimci == maxKatilimci) &&
            (identical(other.mevcutKatilimci, mevcutKatilimci) ||
                other.mevcutKatilimci == mevcutKatilimci) &&
            (identical(other.kayitli, kayitli) || other.kayitli == kayitli) &&
            (identical(other.katildi, katildi) || other.katildi == katildi) &&
            (identical(other.etiketler, etiketler) ||
                other.etiketler == etiketler) &&
            (identical(other.materyaller, materyaller) ||
                other.materyaller == materyaller));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      baslik,
      aciklama,
      sunumTarihi,
      sunumSaati,
      bitisSaati,
      sunumYeri,
      sunucu,
      sunucuUnvani,
      resimUrl,
      maxKatilimci,
      mevcutKatilimci,
      kayitli,
      katildi,
      etiketler,
      materyaller);

  /// Create a copy of LegacyEventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LegacyEventModelImplCopyWith<_$LegacyEventModelImpl> get copyWith =>
      __$$LegacyEventModelImplCopyWithImpl<_$LegacyEventModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LegacyEventModelImplToJson(
      this,
    );
  }
}

abstract class _LegacyEventModel implements LegacyEventModel {
  const factory _LegacyEventModel(
      {final int? id,
      final String? baslik,
      final String? aciklama,
      final String? sunumTarihi,
      final String? sunumSaati,
      final String? bitisSaati,
      final String? sunumYeri,
      final String? sunucu,
      final String? sunucuUnvani,
      final String? resimUrl,
      final int? maxKatilimci,
      final int? mevcutKatilimci,
      final bool? kayitli,
      final bool? katildi,
      final String? etiketler,
      final String? materyaller}) = _$LegacyEventModelImpl;

  factory _LegacyEventModel.fromJson(Map<String, dynamic> json) =
      _$LegacyEventModelImpl.fromJson;

  @override
  int? get id;
  @override
  String? get baslik;
  @override
  String? get aciklama;
  @override
  String? get sunumTarihi;
  @override
  String? get sunumSaati;
  @override
  String? get bitisSaati;
  @override
  String? get sunumYeri;
  @override
  String? get sunucu;
  @override
  String? get sunucuUnvani;
  @override
  String? get resimUrl;
  @override
  int? get maxKatilimci;
  @override
  int? get mevcutKatilimci;
  @override
  bool? get kayitli;
  @override
  bool? get katildi;
  @override
  String? get etiketler;
  @override
  String? get materyaller;

  /// Create a copy of LegacyEventModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LegacyEventModelImplCopyWith<_$LegacyEventModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
