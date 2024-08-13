import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:shape_defence/components/bullet_component.dart';
import 'package:shape_defence/components/enemy_component.dart';

class PentagonPartComponent extends SpriteComponent with CollisionCallbacks {
  PentagonPartComponent({
    required String sprite,
    required List<Vector2> hitShape,
    required Vector2 hitPosition,
  }) : super(
          sprite: Sprite(Flame.images.fromCache(sprite).clone()),
          anchor: Anchor.center,
        ) {
    add(PolygonHitbox(hitShape, anchor: Anchor.topLeft));
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    final theParent = parent;
    if (other is BulletComponent) {
      other.removeFromParent();
      removeFromParent();
    } else if (theParent is PentagonEnemyComponent) {
      theParent.onCollisionStart(intersectionPoints, other);
    }
  }
}

class PentagonEnemyComponent extends EnemyComponent {
  late SpriteComponent a;
  late SpriteComponent b;
  late SpriteComponent c;
  late SpriteComponent d;
  late SpriteComponent e;

  PentagonEnemyComponent({required super.player, required super.position})
      : super(speed: 120, health: 15);

  @override
  Future<void> onLoad() async {
    final center = Vector2(48, 49);
    final outer = [
      Vector2(48, 0),
      Vector2(93.66, 33.86),
      Vector2(76.22, 88.64),
      Vector2(19.78, 88.64),
      Vector2(2.34, 33.86),
    ];
    final inner = [
      Vector2(48, 12.44),
      Vector2(81.96, 37.64),
      Vector2(68.9, 78.64),
      Vector2(27.1, 78.64),
      Vector2(14.04, 37.64)
    ];
    add(a = PentagonPartComponent(
      sprite: 'Enemy/Pentagon/A.png',
      hitShape: [
        outer[0].clone(),
        outer[1].clone(),
        inner[1].clone(),
        inner[0].clone()
      ],
      hitPosition: Vector2(0, -(center.clone()).g),
    ));
    add(b = PentagonPartComponent(
      sprite: 'Enemy/Pentagon/B.png',
      hitShape: [
        outer[1].clone(),
        outer[2].clone(),
        inner[2].clone(),
        inner[1].clone()
      ],
      hitPosition: Vector2(0, -14.78),
    ));
    add(c = PentagonPartComponent(
      sprite: 'Enemy/Pentagon/C.png',
      hitShape: [
        outer[2].clone(),
        outer[3].clone(),
        inner[3].clone(),
        inner[2].clone()
      ],
      hitPosition: Vector2(-57.44 / 2, -0),
    ));
    add(d = PentagonPartComponent(
      sprite: 'Enemy/Pentagon/D.png',
      hitShape: [
        outer[3].clone(),
        outer[4].clone(),
        inner[4].clone(),
        inner[3].clone()
      ],
      hitPosition: Vector2(-98 / 2, -16.96),
    ));
    add(
      e = PentagonPartComponent(
          sprite: 'Enemy/Pentagon/E.png',
          hitShape: [
            outer[0].clone(),
            inner[0].clone(),
            inner[4].clone(),
            outer[4].clone()
          ],
          hitPosition: -(center.clone())),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    transform.angle += (2 * pi) / 360 * (dt * 10);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    int count = a.isMounted ? 1 : 0;
    count += b.isMounted ? 1 : 0;
    count += c.isMounted ? 1 : 0;
    count += d.isMounted ? 1 : 0;
    count += e.isMounted ? 1 : 0;
    if (count > 0) {
      super.onCollisionStart(intersectionPoints, other);
    }
  }
}
