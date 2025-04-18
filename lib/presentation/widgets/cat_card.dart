import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/cat_entity.dart';

class CatCard extends StatelessWidget {
  final CatEntity cat;
  final VoidCallback onTap;

  const CatCard({super.key, required this.cat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: cat.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => SizedBox(
                      height: 250,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      ),
                    ),
                errorWidget:
                    (context, url, error) =>
                        Center(child: Icon(Icons.error, color: Colors.red)),
              ),
              const SizedBox(height: 16),
              Text(
                cat.breed,
                style: GoogleFonts.montserratAlternates(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Origin: ${cat.origin}',
                style: GoogleFonts.montserratAlternates(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
