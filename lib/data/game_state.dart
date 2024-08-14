import 'dart:math';

import 'package:shape_defense/components/player_component.dart';
import 'package:shape_defense/components/shield_component.dart';
import 'package:shape_defense/data/shield.dart';

class GameState {
  int score = 0;
  double health = 100;
  MovingState movingState = MovingState.still;

  double speed = 0.0;
  double angle = 0.0;
  double maxAcceleration = 3.0;
  double maxSpeed = 3.0;
  double rotation = 0.0;

  final int healthMax = 100;
  Shield? shield = Shield();

  addScore(int score) {
    this.score += score;
  }

  get targetSpeed {
    switch (movingState) {
      case MovingState.right:
        return maxSpeed;
      case MovingState.left:
        return -maxSpeed;
      case MovingState.still:
        return 0;
    }
  }

  onEnemyHit(double reduce) {
    health = max(health - reduce, 0.0);
  }

  get isGameOver {
    return health == 0;
  }

  update (double dt) {
    speed += (targetSpeed - speed) * dt * maxAcceleration;
    angle += dt * speed;
  }

  onShieldHit(ShieldPartComponent shieldPart) {
    if (shield == null) return;
    shieldPart.onHit(shield!);
    if (!shield?.isActive()) {
      shield = null;
    }
  }
}