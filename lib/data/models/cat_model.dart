import '../../domain/entities/cat_entity.dart';

class Cat {
  final String imageUrl;
  String breed;
  final String id;
  String temperament;
  String origin;
  String description;
  String lifeSpan;

  Cat({
    required this.imageUrl,
    required this.breed,
    required this.id,
    this.temperament = 'Unknown',
    this.origin = 'Unknown',
    this.description = 'No description available',
    this.lifeSpan = 'Unknown',
  });

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      imageUrl: json['url'],
      id: json['id'],
      breed: json['breeds'] != null ? json['breeds'][0]['name'] : 'Unknown',
      temperament:
          json['breeds'] != null
              ? json['breeds'][0]['temperament'] ?? 'Unknown'
              : 'Unknown',
      origin:
          json['breeds'] != null
              ? json['breeds'][0]['origin'] ?? 'Unknown'
              : 'Unknown',
      description:
          json['breeds'] != null
              ? json['breeds'][0]['description'] ?? 'No description available'
              : 'No description available',
      lifeSpan:
          json['breeds'] != null
              ? json['breeds'][0]['life_span'] ?? 'Unknown'
              : 'Unknown',
    );
  }

  CatEntity toEntity() {
    return CatEntity(
      imageUrl: imageUrl,
      id: id,
      breed: breed,
      temperament: temperament,
      origin: origin,
      description: description,
      lifeSpan: lifeSpan,
    );
  }
}
