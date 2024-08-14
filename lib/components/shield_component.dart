import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:shape_defense/game/shape_defense_game.dart';
import 'package:shape_defense/data/shield.dart';

List<Vector2> clone(List<Vector2> list) {
  return list.map((e) => e.clone()).toList();
}

class ShieldComponent extends PositionComponent
    with HasGameRef<ShapeDefenseGame> {
  late ShieldPartComponent a;
  late ShieldPartComponent b;
  late ShieldPartComponent c;
  late ShieldPartComponent d;
  late ShieldPartComponent e;
  late ShieldPartComponent f;
  late SpriteComponent bg;

  ShieldComponent() {
    final hexA = Vector2(72, 6);
    final hexB = Vector2(131.14, 39.5);
    final hexC = Vector2(131.14, 104.5);
    final hexD = Vector2(72, 138);
    final hexE = Vector2(12.86, 138);
    final hexF = Vector2(12.86, 39.5);
    final hexCenter = Vector2(72, 72);
    bg = SpriteComponent(
        sprite: Sprite(Flame.images.fromCache('Shield/BG.png').clone()));
    a = ShieldPartComponent((shield) {
      shield.a = 0.0;
    }, image: 'Shield/A.png', hitArea: clone([hexCenter, hexA, hexB]));
    b = ShieldPartComponent((shield) {
      shield.b = 0.0;
    }, image: 'Shield/B.png', hitArea: clone([hexCenter, hexB, hexC]));
    c = ShieldPartComponent((shield) {
      shield.c = 0.0;
    }, image: 'Shield/C.png', hitArea: clone([hexCenter, hexC, hexD]));
    d = ShieldPartComponent((shield) {
      shield.d = 0.0;
    }, image: 'Shield/D.png', hitArea: clone([hexCenter, hexD, hexE]));
    e = ShieldPartComponent((shield) {
      shield.e = 0.0;
    }, image: 'Shield/E.png', hitArea: clone([hexCenter, hexE, hexF]));
    f = ShieldPartComponent((shield) {
      shield.f = 0.0;
    }, image: 'Shield/F.png', hitArea: clone([hexCenter, hexF, hexA]));
  }

  @override
  void update(double dt) {
    super.update(dt);
    final shield = game.state.shield;
    toggle(bg, shield != null ? 1.0 : 0.0);
    toggle(a, shield != null ? shield.a : 0.0);
    toggle(b, shield != null ? shield.b : 0.0);
    toggle(c, shield != null ? shield.c : 0.0);
    toggle(d, shield != null ? shield.d : 0.0);
    toggle(e, shield != null ? shield.e : 0.0);
    toggle(f, shield != null ? shield.f : 0.0);
  }

  toggle(SpriteComponent component, double value) {
    if (value > 0.0) {
      if (!component.isMounted) {
        add(component);
      }
      component.setAlpha((value * 255).toInt());
    } else {
      if (component.isMounted) {
        remove(component);
      }
    }
  }
}

class ShieldPartComponent extends SpriteComponent with CollisionCallbacks {
  late PolygonHitbox hit;
  final void Function(Shield shield) onHit;

  ShieldPartComponent(
    this.onHit, {
    required String image,
    required List<Vector2> hitArea,
  }) : super(
          sprite: Sprite(Flame.images.fromCache(image).clone()),
          anchor: const Anchor(0.0, 0.0),
        ) {
    add(hit = PolygonHitbox(
      hitArea,
      anchor: const Anchor(0.0, 0.0),
    ));
  }
}
