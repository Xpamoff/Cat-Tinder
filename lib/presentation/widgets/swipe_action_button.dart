import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class SwipeActionButton extends StatelessWidget {
  final bool isLike;
  final bool isDisabled;
  final CardSwiperController controller;

  const SwipeActionButton({
    super.key,
    required this.isLike,
    required this.isDisabled,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final icon = isLike ? Icons.thumb_up : Icons.thumb_down;

    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed:
            isDisabled
                ? null
                : () {
                  if (isLike) {
                    controller.swipe(CardSwiperDirection.right);
                  } else {
                    controller.swipe(CardSwiperDirection.left);
                  }
                },
      ),
    );
  }
}
