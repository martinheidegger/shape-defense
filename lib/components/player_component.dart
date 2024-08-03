import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:shape_defence/components/bullet_component.dart';
import 'package:shape_defence/components/enemy_component.dart';
import 'package:shape_defence/components/game_colors.dart';
import 'package:shape_defence/game/shape_defence_game.dart';

class BlueDropComponent extends PositionComponent
    with HasGameRef<ShapeDefenceGame>, CollisionCallbacks {
  final double radius;
  MovingState state = MovingState.still;

  BlueDropComponent({
    required this.radius,
    Vector2? position,
    double? angle,
  }) : super(
          position: position ?? Vector2.zero(),
          anchor: Anchor.center,
          angle: angle ?? 0,
          size: Vector2(72, 72),
        ) {
    add(RectangleHitbox(anchor: Anchor.center, size: Vector2.all(72)));
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = GameColors.friend;
    final path = Path();
    path.moveTo(36.0005916,6.30594831);
    path.cubicTo(45.8728924, 20.3674323, 51, 30.2465808, 51,36);
    path.cubicTo(51, 40.1421356, 49.3210678, 43.8921356, 46.6066017, 46.60660170);
    path.cubicTo(43.8921356, 49.3210678, 40.1421356, 51, 36, 51);
    path.cubicTo(31.8578644, 51, 28.1078644, 49.3210678, 25.3933983, 46.6066017);
    path.cubicTo(22.6789322, 43.8921356, 21,40.1421356, 21, 36);
    path.cubicTo(21, 30.2462109, 26.127767,20.3661617, 36.0005916,6.30594831);
    path.close();

    canvas.drawPath(path, paint);
  }

  void shoot() {
    final Vector2 bulletDirection =
        Vector2(cos(angle + pi / 2), sin(angle + pi / 2));

    final Vector2 gunPosition = calculateTailCoordinates();

    final bullet = BulletComponent(gunPosition, bulletDirection);
    gameRef.add(bullet);
  }

  @override
  void update(double dt) {
    super.update(dt);

    switch (state) {
      case MovingState.right:
        _rotate(dt * 1.0);
        break;
      case MovingState.left:
        _rotate(dt * -1.0);
        break;
      case MovingState.still:
        // Do nothing
        break;
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is EnemyComponent) {
      other.removeFromParent();
    }
  }

  Vector2 calculateTailCoordinates() {
    double tailHeight = radius * 1.5;

    double tailX = position.x + cos(angle + pi / 2) * tailHeight;
    double tailY = position.y + sin(angle + pi / 2) * tailHeight;

    return Vector2(tailX, tailY);
  }

  void _rotate(double deltaAngle) {
    angle += deltaAngle;
  }
}

enum MovingState { right, left, still }
