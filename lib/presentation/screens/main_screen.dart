import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../domain/entities/cat_entity.dart';
import '../providers/cat_provider.dart';
import '../providers/liked_cat_provider.dart';
import 'liked_cats_screen.dart';
import 'details_screen.dart';
import '../widgets/cat_card.dart';
import '../widgets/swipe_action_button.dart';

class MainScreen extends StatelessWidget {
  final CardSwiperController _cardSwiperController = CardSwiperController();

  MainScreen({super.key});

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 10),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Cat Tinder',
        style: GoogleFonts.montserratAlternates(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 4,
      actions: [
        IconButton(
          icon: const Icon(Icons.bookmarks),
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.sharedAxisScale,
                duration: const Duration(milliseconds: 300),
                child: const LikedCatsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, CatEntity cat) {
    return CatCard(
      cat: cat,
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 300),
            child: DetailsScreen(cat: cat),
          ),
        );
      },
    );
  }

  Widget _buildSwiper(BuildContext context, CatProvider catProvider) {
    return Container(
      height: 500,
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color(0x33FFFFFF), blurRadius: 25, spreadRadius: 2),
        ],
      ),
      child: CardSwiper(
        allowedSwipeDirection: AllowedSwipeDirection.symmetric(
          horizontal: true,
          vertical: false,
        ),
        numberOfCardsDisplayed: 3,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        controller: _cardSwiperController,
        cardsCount: catProvider.cats.length,
        cardBuilder: (context, index, hOffset, vOffset) {
          final cat = catProvider.cats[index];
          return _buildCard(context, cat);
        },
        onSwipe: (
          int previousIndex,
          int? currentIndex,
          CardSwiperDirection direction,
        ) {
          if (direction == CardSwiperDirection.right) {
            catProvider.likeCat(previousIndex);
          } else if (direction == CardSwiperDirection.left) {
            catProvider.dislikeCat(previousIndex);
          }
          catProvider.loadNextCat();
          return true;
        },
        onEnd: () async {
          catProvider.loadAdditionalCats();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CatProvider>(
      builder: (context, catProvider, _) {
        if (catProvider.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showErrorSnackBar(context, catProvider.errorMessage!);
          });
        }

        return Scaffold(
          backgroundColor: const Color(0xFF2F2F2F),
          appBar: _buildAppBar(context),
          body: Stack(
            children: [
              if (catProvider.isLoading)
                const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              if (!catProvider.isLoading && catProvider.cats.isNotEmpty)
                Center(child: _buildSwiper(context, catProvider)),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SwipeActionButton(
                          isLike: false,
                          isDisabled: catProvider.isLoading,
                          controller: _cardSwiperController,
                        ),
                        SwipeActionButton(
                          isLike: true,
                          isDisabled: catProvider.isLoading,
                          controller: _cardSwiperController,
                        ),
                      ],
                    ),
                    Consumer<LikedCatProvider>(
                      builder: (context, likedCatProvider, _) {
                        return Text(
                          'Dislikes: ${catProvider.dislikeCount}, Likes: ${catProvider.likeCount}',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
