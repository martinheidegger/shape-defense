import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:shape_defence/components/game_colors.dart';
import 'package:shape_defence/game/shape_defence_game.dart';

class BulletComponent extends PositionComponent
    with HasGameRef<ShapeDefenceGame>, CollisionCallbacks {
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

    if (position.x > game.size.x || position.y > game.size.y) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(Offset.zero, 10, Paint()..color = GameColors.friend);
  }

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(anchor: Anchor.center));
  }
}
