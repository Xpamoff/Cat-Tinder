class CatEntity {
  final String imageUrl;
  final String id;
  final String breed;
  final String temperament;
  final String origin;
  final String description;
  final String lifeSpan;

  CatEntity({
    required this.imageUrl,
    required this.id,
    this.breed = 'Unknown',
    this.temperament = 'Unknown',
    this.origin = 'Unknown',
    this.description = 'No description available',
    this.lifeSpan = 'Unknown',
  });

  CatEntity copyWith({
    String? imageUrl,
    String? id,
    String? breed,
    String? temperament,
    String? origin,
    String? description,
    String? lifeSpan,
  }) {
    return CatEntity(
      imageUrl: imageUrl ?? this.imageUrl,
      id: id ?? this.id,
      breed: breed ?? this.breed,
      temperament: temperament ?? this.temperament,
      origin: origin ?? this.origin,
      description: description ?? this.description,
      lifeSpan: lifeSpan ?? this.lifeSpan,
    );
  }
}
