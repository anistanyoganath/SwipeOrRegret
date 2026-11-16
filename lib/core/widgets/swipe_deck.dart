import 'package:flutter/material.dart';
import 'swipe_card.dart';

class SwipeDeck<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(T item, VoidCallback swipeLeft, VoidCallback swipeRight) cardBuilder;
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
  GlobalKey<SwipeCardState> _activeCardKey = GlobalKey<SwipeCardState>();

  void _handleSwipe(bool isRight) {
    if (currentIndex >= widget.items.length) return;

    final currentItem = widget.items[currentIndex];
    widget.onSwipe(currentItem, isRight);

    if (!mounted) return;
    setState(() {
      currentIndex++;
      _activeCardKey = GlobalKey<SwipeCardState>();
      locked = false;
    });
  }

  void _swipeLeftProgrammatically() {
    if (locked) return;
    locked = true;
    _activeCardKey.currentState?.swipeLeft();
  }

  void _swipeRightProgrammatically() {
    if (locked) return;
    locked = true;
    _activeCardKey.currentState?.swipeRight();
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
                      child: widget.cardBuilder(
                        widget.items[currentIndex + i],
                        () {},
                        () {},
                      ),
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
              key: _activeCardKey,
              child: widget.cardBuilder(
                widget.items[currentIndex],
                _swipeLeftProgrammatically,
                _swipeRightProgrammatically,
              ),
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
                _activeCardKey = GlobalKey<SwipeCardState>();
              });
            },
            child: const Text("Play Again"),
          ),
        ],
      ),
    );
  }
}
