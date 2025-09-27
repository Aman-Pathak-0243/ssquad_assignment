class Category {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String image;
  final bool isActive;
  final int order;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.image,
    required this.isActive,
    required this.order,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'] ?? '',
      image: json['image'],
      isActive: json['isActive'] ?? true,
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'image': image,
      'isActive': isActive,
      'order': order,
    };
  }
}
