import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/cat_entity.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsScreen extends StatelessWidget {
  final CatEntity cat;

  const DetailsScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F2F2F),
      appBar: AppBar(
        title: Text(
          'Details of ${cat.breed}',
          style: GoogleFonts.montserratAlternates(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: CachedNetworkImage(
                imageUrl: cat.imageUrl,
                height: 300,
                width: 300,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => SizedBox(
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                errorWidget:
                    (context, url, error) =>
                        Center(child: Icon(Icons.error, color: Colors.red)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              cat.breed,
              style: GoogleFonts.montserratAlternates(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Temperament: ${cat.temperament}',
              style: GoogleFonts.montserratAlternates(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Origin: ${cat.origin}',
              style: GoogleFonts.montserratAlternates(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Description: ${cat.description}',
              style: GoogleFonts.montserratAlternates(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Life Span: ${cat.lifeSpan} years',
              style: GoogleFonts.montserratAlternates(
                fontSize: 18,
                color: const Color(0xFF90CCF4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
