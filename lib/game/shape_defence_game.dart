import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shape_defence/components/enemy_component.dart';
import 'package:shape_defence/components/game_colors.dart';
import 'package:shape_defence/components/player_component.dart';
import 'package:shape_defence/scenarios/game_over_component.dart';

class ShapeDefenceGame extends FlameGame
    with KeyboardEvents, HasCollisionDetection {
  late Stream bullerTimer;
  late Stream enemyTimer;
  late BlueDropComponent playerComponent;

  late StreamSubscription bulletTimeSub;
  late StreamSubscription enemyTimeSub;
  late Random random;
  late TextComponent scoreBoard;
  late TextComponent cheeringBoard;

  int score = 0;

  @override
  Color backgroundColor() {
    return GameColors.background;
  }

  @override
  Future<void> onLoad() async {
    random = Random(0);
    Flame.images.prefix = "";
    await Future.wait([
      Flame.images.load("images/Hero/Full.png"),
      Flame.images.load("images/Hero/InvHealth.png"),
      Flame.images.load("images/Shield/BG.png"),
      Flame.images.load("images/Shield/A.png"),
      Flame.images.load("images/Shield/B.png"),
      Flame.images.load("images/Shield/C.png"),
      Flame.images.load("images/Shield/D.png"),
      Flame.images.load("images/Shield/E.png"),
      Flame.images.load("images/Shield/F.png"),
      Flame.images.load("images/Enemy/Small.png"),
    ]);
    scoreBoard = TextComponent(
      text: 'score: $score',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 50.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
    cheeringBoard = TextComponent(
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 50.0,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
    add(scoreBoard);
    add(cheeringBoard);
    playerComponent = BlueDropComponent(
      () {
        enemyTimeSub.cancel();
        bulletTimeSub.cancel();
        removeAll(children);
        add(GameOverComponent(
            position: Vector2(size.x / 2, size.y / 2),
            onExit: () {
              SystemNavigator.pop();
            },
            onRetry: () {}));
      },
      radius: 80.0,
      position: Vector2(size.x / 2, size.y / 2),
    );

    add(playerComponent);

    bullerTimer = Stream.periodic(const Duration(milliseconds: 500), (timer) {
      playerComponent.shoot();
    });
    enemyTimer = Stream.periodic(const Duration(milliseconds: 2500), (timer) {
      addEnemy();
    });
    enemyTimeSub = bullerTimer.listen((event) {});
    bulletTimeSub = enemyTimer.listen((event) {});
  }

  // Function to get a random position on the edge of the screen
  Vector2 _getRandomEdgePosition() {
    final int edge = random.nextInt(4); // Randomly select one of four edges
    final size = camera.viewport.virtualSize;
    double x = 0;
    double y = 0;

    switch (edge) {
      case 0: // Top edge
        x = random.nextDouble() * size.r;
        break;
      case 1: // Right edge
        x = size.r;
        y = random.nextDouble() * size.g;
        break;
      case 2: // Bottom edge
        x = random.nextDouble() * size.r;
        y = size.g;
        break;
      case 3: // Left edge
        y = random.nextDouble() * size.g;
        break;
    }

    return Vector2(x, y);
  }

  addEnemy()
  {
    final enemy = EnemyComponent(speed: 100.0, player: playerComponent);
    enemy.position = _getRandomEdgePosition();
    add(enemy);
  }

  @override
  void update(double dt) {
    super.update(dt);
    remove(scoreBoard);

    scoreBoard = TextComponent(
      text: 'score: $score',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 50.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
    if (playerComponent.health < 20 && playerComponent.health != 0) {
      cheeringBoard = TextComponent(
        text: 'NEVER GIVE UP!!!!',
        position: Vector2(size.x / 2, 0),
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 50.0,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      );
      add(cheeringBoard);
    } else if (playerComponent.health == 0) {
      remove(cheeringBoard);
      cheeringBoard = TextComponent(
        text: 'YOU ARE AWESOME OIDA',
        position: Vector2(size.x / 2, 0),
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 50.0,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ); 
      add(cheeringBoard);
    } else {
      if (score == 10) {
        remove(cheeringBoard);
        cheeringBoard = TextComponent(
          text: 'COMMMMMMBBOOOOOO',
          position: Vector2(size.x / 2, 0),
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 50.0,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        );
      } else if(score == 15) {
        cheeringBoard = TextComponent(
          text: 'RAMPAGE!!!!!',
          position: Vector2(size.x / 2, 0),
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 50.0,
              fontWeight: FontWeight.bold,
              color: Colors.cyan,
            ),
          ),
        );
      } else if(score == 20) {
        cheeringBoard = TextComponent(
          text: 'HUMILIATION!!!!!',
          position: Vector2(size.x / 2, 0),
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 50.0,
              fontWeight: FontWeight.bold,
              color: Colors.cyan,
            ),
          ),
        );
        add(scoreBoard);
      }
    }
    add(scoreBoard);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowLeft:
          playerComponent.state = MovingState.left; // Rotate left
          break;
        case LogicalKeyboardKey.arrowRight:
          playerComponent.state = MovingState.right; // Rotate right
          break;
      }
    }
    return KeyEventResult.handled;
  }
}
