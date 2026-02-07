import 'package:flutter/material.dart';
import 'swipe_card.dart';

class SwipeDeck<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(T item) cardBuilder;
  final Function(T item, bool isRight) onSwipe;

  const SwipeDeck({
    super.key,
    required this.items,
    required this.cardBuilder,
    required this.onSwipe,
  });

  @override
  State<SwipeDeck<T>> createState() => _SwipeDeckState<T>();
}

class _SwipeDeckState<T> extends State<SwipeDeck<T>> {
  int currentIndex = 0;
  bool locked = false;

  void _handleSwipe(bool isRight) {
    if (locked || currentIndex >= widget.items.length) return;
    locked = true;

    final currentItem = widget.items[currentIndex];
    widget.onSwipe(currentItem, isRight);

    // Update state after animation
    Future.delayed(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      setState(() {
        currentIndex++;
        locked = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentIndex >= widget.items.length) {
      return _buildGameOver();
    }

    // Build the next 2 cards for preview
    final nextCards = <Widget>[];

    // Add preview cards (max 2)
    for (int i = 1; i <= 2; i++) {
      if (currentIndex + i < widget.items.length) {
        nextCards.add(
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: Offset(0, i * 10),
                child: Transform.scale(
                  scale: 1 - i * 0.05,
                  child: Opacity(
                    opacity: 0.95,
                    child: IgnorePointer(
                      child: widget.cardBuilder(widget.items[currentIndex + i]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

    return Stack(
      children: [
        // Preview cards
        ...nextCards,

        // Current interactive card
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: SwipeCard(
              key: ValueKey(currentIndex), // Important: key changes with index
              child: widget.cardBuilder(widget.items[currentIndex]),
              onSwipeLeft: () => _handleSwipe(false),
              onSwipeRight: () => _handleSwipe(true),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameOver() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Game Over",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                currentIndex = 0;
                locked = false;
              });
            },
            child: const Text("Play Again"),
          ),
        ],
      ),
    );
  }
}
