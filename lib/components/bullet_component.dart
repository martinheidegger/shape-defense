import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BulletComponent extends PositionComponent {
  final double speed = 300;
  final Vector2 direction;

  BulletComponent(Vector2 position, Vector2 direction)
      : direction = direction.normalized(), // Normalize the direction
        super(
          position: position,
          size: Vector2.all(10),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);
    position += direction * speed * dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(Offset.zero, 10, Paint()..color = Colors.blue);
  }
}
