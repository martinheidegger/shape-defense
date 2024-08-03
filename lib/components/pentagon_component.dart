import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:shape_defence/components/bullet_component.dart';
import 'package:shape_defence/components/enemy_component.dart';
import 'package:shape_defence/components/game_colors.dart';
import 'package:shape_defence/components/player_component.dart';

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
    debugMode = false;
    final center = Vector2(48, 49);
    final points = [
        Vector2(48, 0),
        Vector2(93.66, 33.86),
        Vector2(76.22, 88.64),
        Vector2(19.78, 88.64),
        Vector2(2.34,  33.86),
    ];
    final p = Paint();
    p.color = GameColors.goodie;
    add(hitA = PolygonHitbox(
      [points[0].clone(), points[1].clone(), center.clone()],
      position: Vector2(0, -center.g),
    ));
    add(hitB = PolygonHitbox(
      [points[1].clone(), points[2].clone(), center.clone()],
      position: Vector2(0, -14.78),
    ));
    add(hitC = PolygonHitbox(
      [points[2].clone(), points[3].clone(), center.clone()],
      position: Vector2(-57.44/2, -0)
    ));
    add(hitD = PolygonHitbox(
      [points[3].clone(), points[4].clone(), center.clone()],
      position: Vector2(-98/2, -16.96),
    ));
    add(hitE = PolygonHitbox(
      [points[0].clone(), center.clone(), points[4].clone()],
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
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
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
  }
}
