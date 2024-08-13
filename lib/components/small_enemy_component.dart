import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:shape_defence/components/enemy_component.dart';

class SmallEnemyComponent extends EnemyComponent {
  SmallEnemyComponent({required super.player, required super.position})
      : super(speed: 20, health: 10);

  @override
  Future<void> onLoad() async {
    final sprite = SpriteComponent(
        sprite: Sprite(Flame.images.fromCache('Enemy/Small.png').clone()));
    add(sprite);
    add(RectangleHitbox(size: sprite.size, anchor: Anchor.topLeft));
  }
}
