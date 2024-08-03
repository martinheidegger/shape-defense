import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:shape_defence/components/player_component.dart';

class EnemyComponent extends SpriteComponent with CollisionCallbacks {
  final double speed;
  final BlueDropComponent player;

  EnemyComponent({ this.speed = 100.0, required this.player }) : super(
    sprite: Sprite(Flame.images.fromCache('images/Enemy/Small.png').clone()),
    anchor: Anchor.center
  ) {
    add(RectangleHitbox(size: size, anchor: Anchor.center));
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Move the rectangle towards the center
    final distance = (player.position - position);
    if (distance.length < 1.0) {
      return;
    }
    final direction = distance.normalized();
    // Check if the rectangle is at or near the center to stop moving
    position += direction * speed * dt;
  }

  @override
  bool debugMode = true;

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other == player) {
      player.reduceHealth(50);
      removeFromParent();
    }
  }
}
