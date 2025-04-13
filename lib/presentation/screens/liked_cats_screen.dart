import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../presentation/providers/liked_cat_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class LikedCatsScreen extends StatelessWidget {
  const LikedCatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final likedCatProvider = Provider.of<LikedCatProvider>(context);
    final likedCats = likedCatProvider.likedCats;
    final allLikedCats = likedCatProvider.allLikedCats;
    final currentFilter = likedCatProvider.filter;

    String message;
    if (allLikedCats.isEmpty) {
      message =
          'No liked cats yet! :((\nTry swiping right on those you really adore!';
    } else if (currentFilter.isNotEmpty) {
      message =
          'No cats match your filter :(\nPlease adjust your search criteria!';
    } else {
      message = 'No liked cats found.';
    }

    return Scaffold(
      backgroundColor: const Color(0xFF2F2F2F),
      appBar: AppBar(
        title: Text(
          'Liked Cats',
          style: GoogleFonts.montserratAlternates(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              cursorColor: Colors.white,
              style: GoogleFonts.montserratAlternates(
                fontSize: 16,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                labelText: 'Filter by breed',
                labelStyle: GoogleFonts.montserratAlternates(
                  fontSize: 16,
                  color: Colors.white,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE6E6E6)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              onChanged: (value) {
                likedCatProvider.setFilter(value);
              },
            ),
          ),
          if (likedCats.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 18,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: likedCats.length,
                itemBuilder: (context, index) {
                  final likedCat = likedCats[index];
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: likedCat.cat.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => const SizedBox(
                            width: 50,
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) =>
                              const Icon(Icons.error, color: Colors.red),
                    ),
                    title: Text(
                      likedCat.cat.breed,
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      'Liked on: ${likedCat.likedDate.toLocal().toString().split(' ')[0]}',
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        likedCatProvider.removeLikedCat(likedCat);
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
