import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:shape_defence/components/enemy_component.dart';

class BigEnemyComponent extends EnemyComponent {
  BigEnemyComponent({required super.player, required super.position}):
    super(speed: 120, health: 4);

  @override
  Future<void> onLoad() async {
    final sprite = SpriteComponent(
        sprite: Sprite(Flame.images.fromCache('Enemy/Big.png').clone()),
        anchor: Anchor.topRight);
    add(sprite);
    add(RectangleHitbox(size: sprite.size, anchor: Anchor.topRight));
  }

  @override
  void update(double dt) {
    super.update(dt);
    final diff = position - player.position;
    transform.angle = atan2(diff.g, diff.r) - (2 * pi) / 360 * 135;
  }
}
