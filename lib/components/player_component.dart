import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:shape_defense/components/shield_component.dart';
import 'package:shape_defense/game/shape_defense_game.dart';

class BlueDropComponent extends PositionComponent
    with HasGameRef<ShapeDefenseGame>, CollisionCallbacks {

  late SpriteComponent invHealth;
  late ShieldComponent shield;

  BlueDropComponent({
    super.position,
    double? angle,
  }) : super(
          anchor: Anchor.center,
          angle: angle ?? 0,
          size: Vector2(144, 144),
        ) {
    add(CircleHitbox(
        radius: 33, anchor: Anchor.center, position: Vector2(72, 72)));
    add(PolygonHitbox([
      Vector2(72, 6),
      Vector2(91, 33),
      Vector2(103, 60),
      Vector2(41, 60),
      Vector2(53, 33),
    ]));
    add(shield = ShieldComponent());
    add(SpriteComponent(
        sprite: Sprite(Flame.images.fromCache('Hero/Full.png').clone())));
    add(invHealth = SpriteComponent(
        sprite: Sprite(Flame.images.fromCache('Hero/InvHealth.png').clone())));
  }

  @override
  void render(Canvas canvas) {
    invHealth.setOpacity(
      1.0 - game.state.health / game.state.healthMax
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle = game.state.angle;
  }

  Vector2 calculateTailCoordinates() {
    // Calculate the offset based on the size of the component
    double tailOffset =
        size.y / 2; // This ensures the bullet originates from the top edge

    // Calculate the tail's tip position based on the current angle
    double tailX = position.x + cos(angle - pi / 2) * tailOffset;
    double tailY = position.y + sin(angle - pi / 2) * tailOffset;

    return Vector2(tailX, tailY);
  }
}

enum MovingState { right, left, still }
