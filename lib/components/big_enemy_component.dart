import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:shape_defence/components/enemy_component.dart';
import 'package:shape_defence/components/player_component.dart';

class BigEnemyComponent extends EnemyComponent {
  BigEnemyComponent({ required BlueDropComponent player }): 
    super(player: player, speed: 120, health: 4) { 
    final sprite = SpriteComponent(sprite: Sprite(Flame.images.fromCache('images/Enemy/Big.png').clone()));
    transform.angle = - pi / 2;
    add(sprite);
    add(RectangleHitbox(size: sprite.size, anchor: Anchor.topLeft));
  }
}
