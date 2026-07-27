# gesture_controlled_interface

A new Flutter project with Flutter gesture widgets.

## Getting Started

Gesture Implementation & UX Reflection
1. Gestures Implemented
For this interactive mobile interface, I implemented three core gesture patterns using Flutter’s GestureDetector and animation widgets:

Tap & Double Tap: Increments a numerical score counter (+1 for single tap, +10 bonus for double tap) while shifting the card’s background color.

Refined Long Press (Double-Tap + Hold Combo): Manages a favorite/like state. Long-pressing initialises a favorite action, while a multi-gesture sequence (Double-Tap followed by a Long Press) acts as an "Undo" mechanism to unfavorite an item.

Horizontal Swipe / Drag: Uses onHorizontalDragUpdate and onHorizontalDragEnd to track drag distance, allowing users to slide a card left or right to trigger "Delete" or "Archive" actions before smoothly snapping back into position.

2. User Experience Improvements
Each gesture was designed to make interaction feel natural, responsive, and predictable:

Immediate Tactile Feedback: By incorporating AnimatedScale during touch events (onTapDown), cards shrink slightly when pressed. This mimics physical resistance and provides instant feedback before an action completes.

Accidental Action Prevention: Destructive or reversing actions (unliking an item) often suffer from accidental triggers. By refining the "Undo Like" gesture to require a explicit double-tap followed by a long press, the interface prevents user error while keeping single actions effortless.

Direct Manipulation: Swiping left/right mirrors real-world physical gestures (like sorting physical cards), providing an intuitive workflow for common content actions without cluttering the UI with extra buttons.

3. Challenges & Resolutions
Challenge 1  Missing Files in File Tree: Initially, after running flutter create, the project structure did not appear cleanly in Visual Studio Code’s Explorer sidebar.

Resolution: I resolved this by ensuring the terminal command finished executing before opening the newly created root folder (gesture_controlled_interface) directly through File > Open Folder.

Challenge 2  Widget Test Mismatch: Updating the root widget from the boilerplate MyApp to GestureApp caused the auto-generated test/widget_test.dart file to throw a compilation error during build checks.

Resolution: I updated the test file to reference GestureApp(), ensuring all unit tests aligned with the main application entry point.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
