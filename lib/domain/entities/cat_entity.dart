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
}
