import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:shape_defense/components/game_colors.dart';
import 'package:shape_defense/game/shape_defense_game.dart';

class GameOverRoute extends PositionComponent with HasGameRef<ShapeDefenseGame> {

  GameOverRoute();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Game Over text
    final textComponent = TextComponent(
      text: 'Game Over',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 100.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, 20), // Position near the top
    );

    add(textComponent);

    // Retry Button
    // Retry Button
    final retryButton = ButtonComponent(
      text: 'Retry',
      onPressed: () => game.onRestart(),
      size: Vector2(200, 80),
      color: GameColors.goodie,
      position: Vector2(size.x / 4, size.y - 80),
    );

    add(retryButton);
  }
}

class ButtonComponent extends PositionComponent with TapCallbacks {
  final Paint buttonPaint;
  final String text;
  final VoidCallback onPressed;

  ButtonComponent({
    required this.text,
    required this.onPressed,
    required Vector2 size,
    required Color color,
    Vector2? position,
  })  : buttonPaint = Paint()..color = color,
        super(
          position: position ?? Vector2.zero(),
          size: size,
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Draw the button rectangle
    canvas.drawRect(size.toRect(), buttonPaint);

    // Draw the button text
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final offset = Offset(
      (size.x - textPainter.width) / 2,
      (size.y - textPainter.height) / 2,
    );
    textPainter.paint(canvas, offset);
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (containsPoint(event.localPosition)) {
      onPressed();
    }
  }

  @override
  bool containsPoint(Vector2 point) {
    return point.x >= 0 &&
        point.x <= size.x &&
        point.y >= 0 &&
        point.y <= size.y;
  }
}
