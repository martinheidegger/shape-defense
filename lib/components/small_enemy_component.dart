import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:shape_defence/components/enemy_component.dart';
import 'package:shape_defence/components/player_component.dart';

class SmallEnemyComponent extends EnemyComponent {
  SmallEnemyComponent({ required BlueDropComponent player }): 
    super(player: player, speed: 20, health: 10) { 
    final sprite = SpriteComponent(sprite: Sprite(Flame.images.fromCache('images/Enemy/Small.png').clone()));
    add(sprite);
    add(RectangleHitbox(size: sprite.size, anchor: Anchor.topLeft));
  }
}
