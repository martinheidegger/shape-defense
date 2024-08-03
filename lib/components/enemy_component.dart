import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:shape_defence/components/player_component.dart';
import 'package:shape_defence/components/game_colors.dart';

class EnemyComponent extends PositionComponent with CollisionCallbacks {
  final double speed;
  final Vector2 center;
  final Paint paint = Paint()..color = GameColors.enemy;

  EnemyComponent({
    required this.center,
    this.speed = 100.0,
  }) : super(
          size: Vector2(30, 20), // Width and height of the rectangle
          anchor: Anchor.center,
        ) {
    // Initialize the rectangle at a random edge position
    position = _getRandomEdgePosition();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Move the rectangle towards the center
    final direction = (center - position).normalized();
    position += direction * speed * dt;

    // Check if the rectangle is at or near the center to stop moving
    if ((center - position).length < 1.0) {
      position = center.clone();
    }
  }

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(anchor: Anchor.center));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), paint);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is BlueDropComponent) {
      removeFromParent();
    }
  }

  // Function to get a random position on the edge of the screen
  Vector2 _getRandomEdgePosition() {
    final random = Random();
    final double x;
    final double y;
    final int edge = random.nextInt(4); // Randomly select one of four edges

    switch (edge) {
      case 0: // Top edge
        x = random.nextDouble() * center.x * 2;
        y = 0;
        break;
      case 1: // Right edge
        x = center.x * 2;
        y = random.nextDouble() * center.y * 2;
        break;
      case 2: // Bottom edge
        x = random.nextDouble() * center.x * 2;
        y = center.y * 2;
        break;
      case 3: // Left edge
        x = 0;
        y = random.nextDouble() * center.y * 2;
        break;
      default:
        x = center.x;
        y = center.y;
        break;
    }

    return Vector2(x, y);
  }
}
