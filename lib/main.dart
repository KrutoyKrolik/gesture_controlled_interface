import 'package:flutter/material.dart';

void main() {
  runApp(const GestureApp());
}

class GestureApp extends StatelessWidget {
  const GestureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gesture Interface',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const GestureScreen(),
    );
  }
}

class GestureScreen extends StatefulWidget {
  const GestureScreen({super.key});

  @override
  State<GestureScreen> createState() => _GestureScreenState();
}

class _GestureScreenState extends State<GestureScreen> {
  // Step 2 State (Tap & Double Tap)
  int _tapCount = 0;
  Color _cardColor = Colors.indigo.shade100;

  // Step 3 Refinement State (Double Tap + Long Hold to Undo)
  bool _isLiked = false;
  bool _readyToUndo = false;
  double _cardScale = 1.0;

  // Step 4 State (Swipe / Drag)
  double _dragOffset = 0.0;
  String _swipeStatus = "Swipe the card left or right!";

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gesture Interface'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // GESTURE 1: TAP & DOUBLE TAP
            const Text(
              '1. Tap & Double Tap Zone',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _tapCount++;
                  _cardColor = Colors.indigo.shade200;
                });
              },
              onDoubleTap: () {
                setState(() {
                  _tapCount += 10;
                  _cardColor = Colors.amber.shade200;
                });
                _showSnackBar('Double Tap Bonus! +10 Points');
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 120,
                decoration: BoxDecoration(
                  color: _cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'Score: $_tapCount\n(Tap once or Double Tap!)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // GESTURE 2: REFINED LONG PRESS (DOUBLE TAP + LONG PRESS TO UNDO)
            const Text(
              '2. Refined Like / Undo Zone',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTapDown: (_) => setState(() => _cardScale = 0.95),
              onTapUp: (_) => setState(() => _cardScale = 1.0),
              onTapCancel: () => setState(() => _cardScale = 1.0),
              onDoubleTap: () {
                if (_isLiked) {
                  setState(() => _readyToUndo = true);
                  _showSnackBar('Double-tapped! Now long-press to confirm Undo');
                }
              },
              onLongPress: () {
                if (!_isLiked) {
                  // Standard Long Press to Like
                  setState(() {
                    _isLiked = true;
                    _cardScale = 1.0;
                  });
                  _showSnackBar('Item Favorited! ❤️');
                } else if (_readyToUndo) {
                  // Refined Combo: Double Tap + Long Press to Undo
                  setState(() {
                    _isLiked = false;
                    _readyToUndo = false;
                    _cardScale = 1.0;
                  });
                  _showSnackBar('Item Unfavorited 💔');
                } else {
                  // Alert user if they only long-pressed without double-tapping first
                  _showSnackBar('Double-tap FIRST, then long-press to undo!');
                }
              },
              child: AnimatedScale(
                scale: _cardScale,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: _isLiked 
                        ? (_readyToUndo ? Colors.orange.shade100 : Colors.pink.shade100) 
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isLiked 
                          ? (_readyToUndo ? Colors.orange : Colors.pink) 
                          : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked 
                            ? (_readyToUndo ? Colors.orange : Colors.pink) 
                            : Colors.grey.shade700,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          _isLiked
                              ? (_readyToUndo 
                                  ? 'Now Hold Down to Confirm Undo!' 
                                  : 'Liked! (Double-tap + Hold to Undo)')
                              : 'Press & Hold to Like',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: _isLiked 
                                ? (_readyToUndo ? Colors.orange.shade900 : Colors.pink.shade900) 
                                : Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // GESTURE 3: HORIZONTAL SWIPE
            const Text(
              '3. Horizontal Swipe Zone',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _dragOffset += details.delta.dx;
                });
              },
              onHorizontalDragEnd: (details) {
                if (_dragOffset > 100) {
                  setState(() => _swipeStatus = "Swiped Right! 👉 (Archived)");
                  _showSnackBar("Action: Archived");
                } else if (_dragOffset < -100) {
                  setState(() => _swipeStatus = "Swiped Left! 👈 (Deleted)");
                  _showSnackBar("Action: Deleted");
                }
                setState(() => _dragOffset = 0.0);
              },
              child: Transform.translate(
                offset: Offset(_dragOffset, 0),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        _swipeStatus,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
