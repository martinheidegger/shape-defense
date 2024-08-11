import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:shape_defence/components/shield_component.dart';
import 'package:shape_defence/game/shape_defence_game.dart';

class BlueDropComponent extends PositionComponent
    with HasGameRef<ShapeDefenceGame>, CollisionCallbacks {
  final double radius;
  MovingState state = MovingState.still;
  double health = 100;
  double speed = 0.0;
  double maxAcceleration = 3.0;
  double maxSpeed = 3.0;
  
  final void Function() onGameOver;

  late SpriteComponent invHealth;
  late ShieldComponent shield;

  double healthDisplay() {
    // Normalized value 0.0 = no health, 1.0 = full health
    return 1.0 -health / 100.0;
  }

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
    add(CircleHitbox(
      radius: 33,
      anchor: Anchor.center,
      position: Vector2(72, 72)
    ));
    add(PolygonHitbox([
      Vector2(72, 6),
      Vector2(91, 33),
      Vector2(103, 60),
      Vector2(41, 60),
      Vector2(53, 33),
    ]));
    add(shield = ShieldComponent());
    add(SpriteComponent(sprite: Sprite(Flame.images.fromCache('Hero/Full.png').clone())));
    add(invHealth = SpriteComponent(sprite: Sprite(Flame.images.fromCache('Hero/InvHealth.png').clone())));
  }

  @override
  void render(Canvas canvas) {
    invHealth.setOpacity(healthDisplay());
  }

  @override
  void update(double dt) {
    super.update(dt);
    double targetSpeed;
    switch (state) {
      case MovingState.right:
        targetSpeed = maxSpeed;
        break;
      case MovingState.left:
        targetSpeed = -maxSpeed;
        break;
      case MovingState.still:
        targetSpeed = 0;
        break;
    }
    speed += (targetSpeed - speed) * dt * maxAcceleration;
    _rotate(dt * speed);
  }
  
  Vector2 calculateTailCoordinates() {
  // Calculate the offset based on the size of the component
  double tailOffset = size.y / 2; // This ensures the bullet originates from the top edge

  // Calculate the tail's tip position based on the current angle
  double tailX = position.x + cos(angle - pi / 2) * tailOffset;
  double tailY = position.y + sin(angle - pi / 2) * tailOffset;

  return Vector2(tailX, tailY);
}

  void _rotate(double deltaAngle) {
    angle += deltaAngle;
  }

  void reduceHealth(double health) {
    this.health = max(this.health - health, 0.0);
    if (this.health == 0.0) {
      onGameOver();
    }
  }
}

enum MovingState { right, left, still }
