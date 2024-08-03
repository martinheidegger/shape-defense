import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:shape_defence/components/bullet_component.dart';
import 'package:shape_defence/game/shape_defence_game.dart';

class BlueDropComponent extends PositionComponent
    with HasGameRef<ShapeDefenceGame> {
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
        );

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.blue;
    final path = Path();

    // Draw circle part of the drop
    path.addOval(Rect.fromCircle(center: Offset(0, -radius / 2), radius: radius));

    // Draw pointy tail part
    path.moveTo(-radius / 2, 0);
    path.lineTo(0, radius);
    path.lineTo(radius / 2, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  void shoot() {
    final Vector2 bulletDirection = Vector2(cos(angle + pi / 2), sin(angle + pi / 2));

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

  Vector2 calculateTailCoordinates() {
    double tailHeight = radius * 1.5;

    // Calculate the tail's tip position based on the current angle
    double tailX = position.x + cos(angle + pi / 2) * tailHeight;
    double tailY = position.y + sin(angle + pi / 2) * tailHeight;

    return Vector2(tailX, tailY);
  }

  void _rotate(double deltaAngle) {
    angle += deltaAngle;
  }
}

enum MovingState { right, left, still }
