import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shape_defense/components/big_enemy_component.dart';
import 'package:shape_defense/components/bullet_component.dart';
import 'package:shape_defense/components/pentagon_enemy_component.dart';
import 'package:shape_defense/components/player_component.dart';
import 'package:shape_defense/components/small_enemy_component.dart';
import 'package:shape_defense/components/tip_enemy_component.dart';
import 'package:shape_defense/game/shape_defense_game.dart';

class GamePlayRoute extends PositionComponent
    with KeyboardHandler, HasGameRef<ShapeDefenseGame> {
  late TextComponent scoreBoard;
  late TextComponent cheeringBoard;
  late BlueDropComponent playerComponent;
  late LogicalKeyboardKey? lastKeyDown;
  late SpawnComponent spawnBullets;
  late SpawnComponent spawnEnemies;

  late Random random;

  @override
  FutureOr<void> onLoad() {
    random = Random(0);
    lastKeyDown = null;
    size = game.camera.viewport.virtualSize;
    position = -size/2;
    add(scoreBoard = TextComponent(
      text: '',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 50.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ));
    add(cheeringBoard = TextComponent(
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 50.0,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    ));
    add(playerComponent = BlueDropComponent(position: size/2));
    add(spawnBullets = SpawnComponent(
        period: .15,
        selfPositioning: true,
        factory: (i) {
          final Vector2 position = playerComponent.calculateTailCoordinates();
          final Vector2 direction = position - playerComponent.position;

          return BulletComponent(position, direction);
        }));
    add(spawnEnemies = SpawnComponent(
        period: 1.7, selfPositioning: true, factory: (i) => addEnemy()));
  }

  // Function to get a random position on the edge of the screen
  Vector2 _getRandomEdgePosition() {
    final int edge = random.nextInt(4); // Randomly select one of four edges
    double x = 0;
    double y = 0;

    scoreBoard.size = Vector2(-size.x / 2, -size.y / 2);

    switch (edge) {
      case 0: // Bottom edge
        x = random.nextDouble() * size.x;
        y = size.y;
        break;
      case 1: // Horizontal edge
        x = random.nextDouble() * size.x;
        break;
      case 2: // Right edge
        x = size.x;
        y = random.nextDouble() * size.y;
      case 3: // Vertical edge
        x = 0;
        y = random.nextDouble() * size.y;
        break;
    }

    return Vector2(x, y);
  }

  addEnemy() {
    final position = _getRandomEdgePosition();
    switch (random.nextInt(4)) {
      case 0:
        return SmallEnemyComponent(player: playerComponent, position: position);
      case 1:
        return BigEnemyComponent(player: playerComponent, position: position);
      case 2:
        return TipEnemyComponent(player: playerComponent, position: position);
      default:
        return PentagonEnemyComponent(
            player: playerComponent, position: position);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    final score = game.state.score;
    scoreBoard.text = 'score: $score';
    game.state.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowLeft:
          game.state.movingState = MovingState.left;
          break;
        case LogicalKeyboardKey.arrowRight:
          game.state.movingState = MovingState.right;
          break;
        default:
          return false;
      }
      lastKeyDown = event.logicalKey;
      return true;
    }
    if (event is KeyUpEvent &&
        lastKeyDown != null &&
        event.logicalKey == lastKeyDown) {
      game.state.movingState = MovingState.still;
      return true;
    }
    return false;
  }

  replaceCheeringboard(TextComponent newBoard) {
    remove(cheeringBoard);
    cheeringBoard = newBoard;
    add(cheeringBoard);
  }
}
