class User {
  final int id;
  final String email;
  final String name;
  final String? phone;
  final String? school;
  final String? branch;
  final List<int>? registeredEventIds;
  final List<int>? attendedEventIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.school,
    this.branch,
    this.registeredEventIds,
    this.attendedEventIds,
    this.createdAt,
    this.updatedAt,
  });

  User copyWith({
    int? id,
    String? email,
    String? name,
    String? phone,
    String? school,
    String? branch,
    List<int>? registeredEventIds,
    List<int>? attendedEventIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      school: school ?? this.school,
      branch: branch ?? this.branch,
      registeredEventIds: registeredEventIds ?? this.registeredEventIds,
      attendedEventIds: attendedEventIds ?? this.attendedEventIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.name == name;
  }

  @override
  int get hashCode => Object.hash(id, email, name);
}
