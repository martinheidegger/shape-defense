import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:shape_defence/components/enemy_component.dart';
import 'package:shape_defence/components/player_component.dart';

class BigEnemyComponent extends EnemyComponent {
  BigEnemyComponent({ required BlueDropComponent player, required Vector2 position }): 
    super(player: player, speed: 120, health: 4, position: position) { 
    final sprite = SpriteComponent(sprite: Sprite(Flame.images.fromCache('images/Enemy/Big.png').clone()), anchor: Anchor.topLeft);
    add(sprite);
    add(RectangleHitbox(size: sprite.size, anchor: Anchor.topLeft));
  }

  @override
  void update(double dt) {
    super.update(dt);
    final diff = position - player.position;
    transform.angle = atan2(diff.g, diff.r) - (2 * pi) / 360 * 135;
  }
}
