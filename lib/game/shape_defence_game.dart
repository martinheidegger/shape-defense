import 'dart:async';

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

  @override
  Color backgroundColor() {
    return GameColors.background;
  }

  @override
  Future<void> onLoad() async {
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
      Flame.images.load("images/Shield/F.png")
    ]);

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
    final enemy =
        EnemyComponent(center: Vector2(size.x / 2, size.y / 2), speed: 100.0);

    add(playerComponent);
    add(enemy);

    bullerTimer = Stream.periodic(const Duration(milliseconds: 500), (timer) {
      playerComponent.shoot();
    });
    enemyTimer = Stream.periodic(const Duration(milliseconds: 2500), (timer) {
      final enemy =
          EnemyComponent(center: Vector2(size.x / 2, size.y / 2), speed: 100.0);
      add(enemy);
    });
    enemyTimeSub = bullerTimer.listen((event) {});
    bulletTimeSub = enemyTimer.listen((event) {});
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
