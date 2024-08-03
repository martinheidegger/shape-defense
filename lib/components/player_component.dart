import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:shape_defence/components/bullet_component.dart';
import 'package:shape_defence/components/enemy_component.dart';
import 'package:shape_defence/components/game_colors.dart';
import 'package:shape_defence/game/shape_defence_game.dart';

class BlueDropComponent extends PositionComponent
    with HasGameRef<ShapeDefenceGame>, CollisionCallbacks {
  final double radius;
  MovingState state = MovingState.still;
  late Sprite full;
  late Sprite invHealth;
  int health = 100;
  final void Function() onGameOver;

  double healthDisplay() {
    // Normalized value 0.0 = no health, 1.0 = full health
    return health / 100.0;
  }

  @override
  bool debugMode = true;

  BlueDropComponent(
    this.onGameOver, {
    required this.radius,
    super.position,
    double? angle,
  }) : super(
          anchor: Anchor.center,
          angle: angle ?? 0,
          size: Vector2(144, 144),
        ) {
    add(RectangleHitbox(
        anchor: Anchor.center,
        size: Vector2(80, 100),
        position: Vector2(size.x / 2, (size.y / 2) - 10)));
    full = Sprite(Flame.images.fromCache('images/Hero/Full.png').clone());
    invHealth =
        Sprite(Flame.images.fromCache('images/Hero/InvHealth.png').clone());
  }

  @override
  void render(Canvas canvas) {
    full.render(canvas);
    Color color = Color(GameColors.background.value).withAlpha(
        max(min(0xff - (healthDisplay() * 0xff).round(), 0xff), 0x00));
    final paint = Paint();
    paint.color = color;
    invHealth.paint = paint;
    invHealth.render(canvas);
  }

  void shoot() {
    // Calculate the direction based on the current angle
    final Vector2 bulletDirection = Vector2(cos(angle), sin(angle));

    // Calculate the position to shoot from (tip of the tail)
    final Vector2 gunPosition = calculateTailCoordinates();

    // Create and add the bullet to the game
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
      health -= 10;
      if (health == 0) {
        onGameOver();
      }
    }
  }

  
  Vector2 calculateTailCoordinates() {
    double tailOffset = radius * 0.5; // Adjust the offset based on sprite design

    // Calculate the tail's tip position based on the current angle
    double tailX = position.x + cos(angle) * tailOffset;
    double tailY = position.y + sin(angle) * tailOffset;

    return Vector2(tailX, tailY);
  }

  void _rotate(double deltaAngle) {
    angle += deltaAngle;
  }
}

enum MovingState { right, left, still }
