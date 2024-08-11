import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:shape_defence/components/bullet_component.dart';
import 'package:shape_defence/components/enemy_component.dart';

class PentagonEnemyComponent extends EnemyComponent {
  late SpriteComponent a;
  late PolygonHitbox hitA;
  late SpriteComponent b;
  late PolygonHitbox hitB;
  late SpriteComponent c;
  late PolygonHitbox hitC;
  late SpriteComponent d;
  late PolygonHitbox hitD;
  late SpriteComponent e;
  late PolygonHitbox hitE;
  bool vulnerable = false;

  PentagonEnemyComponent({ required super.player, required super.position }): 
    super(speed: 120, health: 15) { 
    a = SpriteComponent(
      sprite: Sprite(Flame.images.fromCache('Enemy/Pentagon/A.png').clone()),
      anchor: Anchor.center,
    );
    b = SpriteComponent(
      sprite: Sprite(Flame.images.fromCache('Enemy/Pentagon/B.png').clone()),
      anchor: Anchor.center,
    );
    c = SpriteComponent(
      sprite: Sprite(Flame.images.fromCache('Enemy/Pentagon/C.png').clone()),
      anchor: Anchor.center,
    );
    d = SpriteComponent(
      sprite: Sprite(Flame.images.fromCache('Enemy/Pentagon/D.png').clone()),
      anchor: Anchor.center,
    );
    e = SpriteComponent(
      sprite: Sprite(Flame.images.fromCache('Enemy/Pentagon/E.png').clone()),
      anchor: Anchor.center,
    );
    add(a);
    add(b);
    add(c);
    add(d);
    add(e);
  }

  @override
  Future<void> onLoad() async {
    final center = Vector2(48, 49);
    final outer = [
        Vector2(48, 0),
        Vector2(93.66, 33.86),
        Vector2(76.22, 88.64),
        Vector2(19.78, 88.64),
        Vector2(2.34,  33.86),
    ];
    final inner = [
        Vector2(48, 12.44),
        Vector2(81.96, 37.64),
        Vector2(68.9, 78.64),
        Vector2(27.1, 78.64),
        Vector2(7.02, 37.64)
    ];
    add(hitA = PolygonHitbox(
      [outer[0].clone(), outer[1].clone(), inner[1].clone(), inner[0].clone()],
      position: Vector2(0, -center.g),
    ));
    add(hitB = PolygonHitbox(
      [outer[1].clone(), outer[2].clone(), inner[2].clone(), inner[1].clone()],
      position: Vector2(0, -14.78),
    ));
    add(hitC = PolygonHitbox(
      [outer[2].clone(), outer[3].clone(), inner[3].clone(), inner[2].clone()],
      position: Vector2(-57.44/2, -0)
    ));
    add(hitD = PolygonHitbox(
      [outer[3].clone(), outer[4].clone(), inner[4].clone(), inner[3].clone()],
      position: Vector2(-98/2, -16.96),
    ));
    add(hitE = PolygonHitbox(
      [outer[0].clone(), inner[0].clone(), inner[4].clone(), outer[4].clone()],
      position: -center.clone()
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    transform.angle += (2 * pi) / 360 * (dt * 10);
  }

  @override
  isVulnerable() {
    return vulnerable;
  }

  @override
  void onHit(PositionComponent other) {
    if (other is BulletComponent) {
      if (hitA.isColliding && a.isMounted) {
        a.removeFromParent();
      }
      if (hitB.isColliding && b.isMounted) {
        b.removeFromParent();
      }
      if (hitC.isColliding && c.isMounted) {
        c.removeFromParent();
      }
      if (hitD.isColliding && d.isMounted) {
        d.removeFromParent();
      }
      if (hitE.isColliding && e.isMounted) {
        e.removeFromParent();
      }
    }
    int count = a.isMounted ? 1 : 0;
    count += b.isMounted ? 1 : 0;
    count += c.isMounted ? 1 : 0;
    count += d.isMounted ? 1 : 0;
    count += e.isMounted ? 1 : 0;
    vulnerable = count < 2;
    super.onHit(other);
  }
}
