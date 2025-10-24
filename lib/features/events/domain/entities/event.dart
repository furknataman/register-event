class Event {
  final int id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String speaker;
  final String? speakerTitle;
  final String? imageUrl;
  final int maxParticipants;
  final int currentParticipants;
  final bool isRegistered;
  final bool isAttended;
  final List<String>? tags;
  final String? materials;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.speaker,
    this.speakerTitle,
    this.imageUrl,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.isRegistered,
    required this.isAttended,
    this.tags,
    this.materials,
    this.createdAt,
    this.updatedAt,
  });

  Event copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? speaker,
    String? speakerTitle,
    String? imageUrl,
    int? maxParticipants,
    int? currentParticipants,
    bool? isRegistered,
    bool? isAttended,
    List<String>? tags,
    String? materials,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      speaker: speaker ?? this.speaker,
      speakerTitle: speakerTitle ?? this.speakerTitle,
      imageUrl: imageUrl ?? this.imageUrl,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      isRegistered: isRegistered ?? this.isRegistered,
      isAttended: isAttended ?? this.isAttended,
      tags: tags ?? this.tags,
      materials: materials ?? this.materials,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Event &&
        other.id == id &&
        other.title == title &&
        other.startTime == startTime;
  }

  @override
  int get hashCode => Object.hash(id, title, startTime);
}
