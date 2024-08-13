import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:shape_defence/components/bullet_component.dart';
import 'package:shape_defence/components/player_component.dart';
import 'package:shape_defence/components/shield_component.dart';
import 'package:shape_defence/game/shape_defence_game.dart';

abstract class EnemyComponent extends PositionComponent with CollisionCallbacks, HasGameRef<ShapeDefenceGame> {
  final double speed;
  final BlueDropComponent player;
  final double health;

  EnemyComponent({ this.speed = 100.0, this.health = 10, required this.player, required Vector2 position }) : super() {
    this.position = position;
  }

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(
      size: size,
      anchor: anchor, // Ensure anchor matches the component's anchor
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Move the rectangle towards the center
    final distance = (player.position - position);
    if (distance.length < 1.0) {
      removeFromParent();
      return;
    }
    final direction = distance.normalized();
    // Check if the rectangle is at or near the center to stop moving
    position += direction * speed * dt;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is ShieldPartComponent) {
      game.onShieldHit(other);
      removeFromParent();
    } else if (other == player) {
      player.reduceHealth(health);
      removeFromParent();
    } else if (other is BulletComponent) {
      removeFromParent();
      other.removeFromParent();
      game.score++;
    }
  }
}
