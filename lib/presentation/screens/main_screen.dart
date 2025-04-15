import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../data/models/cat_model.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/liked_cat.dart';
import '../providers/cat_provider.dart';
import '../providers/liked_cat_provider.dart';
import 'liked_cats_screen.dart';
import 'details_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/cat_card.dart';
import '../widgets/swipe_action_button.dart';
import 'package:page_transition/page_transition.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final CardSwiperController _cardSwiperController = CardSwiperController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CatProvider>(context, listen: false).loadInitialCats();
    });
  }

  Future<void> _showErrorDialog(String message) async {
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2F2F2F),
            title: Text(
              'Network Error',
              style: GoogleFonts.montserratAlternates(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            content: Text(
              message,
              style: GoogleFonts.montserratAlternates(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Provider.of<CatProvider>(context, listen: false).retry();
                },
                child: Text(
                  'Retry',
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 16,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _navigateToDetailsScreen(Cat cat) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        duration: const Duration(milliseconds: 300),
        child: DetailsScreen(cat: cat),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    int index,
    int horizontalOffsetPercentage,
    int verticalOffsetPercentage,
    Cat cat,
  ) {
    return CatCard(cat: cat, onTap: () => _navigateToDetailsScreen(cat));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CatProvider>(
      builder: (context, catProvider, child) {
        if (catProvider.isLoading && catProvider.errorMessage == null) {
          return Scaffold(
            backgroundColor: const Color(0xFF2F2F2F),
            body: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        if (catProvider.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showErrorDialog(catProvider.errorMessage!);
          });
        }

        return Scaffold(
          backgroundColor: const Color(0xFF2F2F2F),
          appBar: AppBar(
            title: Text(
              'Cat Tinder',
              style: GoogleFonts.montserratAlternates(
                fontWeight: FontWeight.bold,
              ),
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
          ),
          body: Stack(
            children: [
              if (catProvider.cats.isNotEmpty)
                Center(
                  child: Container(
                    height: 500,
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33FFFFFF),
                          blurRadius: 25,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CardSwiper(
                      allowedSwipeDirection: AllowedSwipeDirection.symmetric(
                        horizontal: true,
                        vertical: false,
                      ),
                      numberOfCardsDisplayed: 3,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      controller: _cardSwiperController,
                      cardsCount: catProvider.cats.length,
                      cardBuilder: (context, index, hOffset, vOffset) {
                        return _buildCard(
                          context,
                          index,
                          hOffset,
                          vOffset,
                          catProvider.cats[index],
                        );
                      },
                      onSwipe: (
                        int previousIndex,
                        int? currentIndex,
                        CardSwiperDirection direction,
                      ) {
                        if (direction == CardSwiperDirection.right) {
                          final likedCat = LikedCat(
                            cat: catProvider.cats[previousIndex],
                            likedDate: DateTime.now(),
                          );
                          Provider.of<LikedCatProvider>(
                            context,
                            listen: false,
                          ).addLikedCat(likedCat);
                        } else if (direction == CardSwiperDirection.left) {
                          catProvider.incrementDislikeCount();
                        }
                        catProvider.loadNewCat();
                        return true;
                      },
                      onEnd: () {
                        catProvider.loadInitialCats();
                      },
                    ),
                  ),
                ),
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
                      builder: (context, likedCatProvider, child) {
                        return Text(
                          'Dislikes: ${catProvider.dislikeCount}, Likes: ${likedCatProvider.likedCats.length}',
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
