import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../models/cat_model.dart';
import '../services/cat_service.dart';
import 'details_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/cat_card.dart';
import '../widgets/swipe_action_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _likeCount = 0;
  int _dislikeCount = 0;
  bool _isLoading = false;
  String? _errorMessage;
  final List<Cat> _cats = [];
  final CardSwiperController _cardSwiperController = CardSwiperController();

  @override
  void initState() {
    super.initState();
    _loadInitialCats();
  }

  Future<void> _loadInitialCats() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _cats.clear();
    });

    try {
      final cats = await Future.wait([
        CatService().fetchRandomCat(),
        CatService().fetchRandomCat(),
        CatService().fetchRandomCat(),
        CatService().fetchRandomCat(),
        CatService().fetchRandomCat(),
      ]);
      setState(() {
        _cats.addAll(cats);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Error while gaining cat data";
      });
    }
  }

  Future<void> _loadNewCat() async {
    if (_errorMessage != null) return;
    try {
      final cat = await CatService().fetchRandomCat();
      setState(() {
        _cats.add(cat);
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error while gaining cat data";
        _isLoading = false;
      });
    }
  }

  void _incrementLikeCount() {
    setState(() {
      _likeCount++;
    });
  }

  void _incrementDislikeCount() {
    setState(() {
      _dislikeCount++;
    });
  }

  void _navigateToDetailsScreen(Cat cat) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => DetailsScreen(cat: cat),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.easeInOut;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  void _retry() {
    setState(() {
      _errorMessage = null;
    });
    _loadInitialCats();
  }

  Widget _buildCard(
    BuildContext context,
    int index,
    int horizontalOffsetPercentage,
    int verticalOffsetPercentage,
  ) {
    return CatCard(
      cat: _cats[index],
      onTap: () => _navigateToDetailsScreen(_cats[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _errorMessage == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF2F2F2F),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF2F2F2F),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _errorMessage!,
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _retry, child: const Text('Retry')),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF2F2F2F),
      appBar: AppBar(
        title: Text(
          'Cat Tinder',
          style: GoogleFonts.montserratAlternates(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: Stack(
        children: [
          if (_cats.isNotEmpty)
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  controller: _cardSwiperController,
                  cardsCount: _cats.length,
                  cardBuilder: _buildCard,
                  onSwipe: (
                    int previousIndex,
                    int? currentIndex,
                    CardSwiperDirection direction,
                  ) {
                    if (direction == CardSwiperDirection.right) {
                      _incrementLikeCount();
                    } else if (direction == CardSwiperDirection.left) {
                      _incrementDislikeCount();
                    }
                    _loadNewCat();
                    return true;
                  },

                  onEnd: () {
                    setState(() {
                      _isLoading = true;
                    });
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
                      isDisabled: _isLoading,
                      controller: _cardSwiperController,
                    ),
                    SwipeActionButton(
                      isLike: true,
                      isDisabled: _isLoading,
                      controller: _cardSwiperController,
                    ),
                  ],
                ),
                Text(
                  'Dislikes: $_dislikeCount, Likes: $_likeCount',
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
