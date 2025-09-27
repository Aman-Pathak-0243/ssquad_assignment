class Location {
  final String id;
  final String name;
  final String type;
  final String? code;
  final String? parentId;
  final bool isActive;

  Location({
    required this.id,
    required this.name,
    required this.type,
    this.code,
    this.parentId,
    required this.isActive,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['_id'],
      name: json['name'],
      type: json['type'],
      code: json['code'],
      parentId: json['parentId'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'type': type,
      'code': code,
      'parentId': parentId,
      'isActive': isActive,
    };
  }

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
