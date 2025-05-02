import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/liked_cat_entity.dart';
import '../providers/liked_cat_provider.dart';
import 'details_screen.dart';

class LikedCatsScreen extends StatelessWidget {
  const LikedCatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final likedCatProvider = Provider.of<LikedCatProvider>(
      context,
      listen: false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      likedCatProvider.fetchLikedCats();
    });

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
          Expanded(
            child: Consumer<LikedCatProvider>(
              builder: (context, provider, _) {
                final likedCats = provider.likedCats;
                final allLikedCats = provider.allLikedCats;
                final filter = provider.filter;

                String message;
                if (allLikedCats.isEmpty) {
                  message =
                      'No liked cats yet! :((\nTry swiping right on those you really adore!';
                } else if (filter.isNotEmpty && likedCats.isEmpty) {
                  message =
                      'No cats match your filter :(\nPlease adjust your search criteria!';
                } else {
                  message = '';
                }

                if (message.isNotEmpty) {
                  return Center(
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 18,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: likedCats.length,
                  itemBuilder: (context, index) {
                    final LikedCatEntity likedCat = likedCats[index];
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
                        'Liked on: ${likedCat.likedDate.toLocal().toIso8601String().split('T').first}',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          provider.removeLikedCat(likedCat);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: const Duration(milliseconds: 300),
                            child: DetailsScreen(cat: likedCat.cat),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
