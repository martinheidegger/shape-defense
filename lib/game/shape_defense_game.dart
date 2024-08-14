import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart' as game;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shape_defense/components/background_color_component.dart';
import 'package:shape_defense/components/game_colors.dart';
import 'package:shape_defense/data/game_state.dart';
import 'package:shape_defense/routes/game_over_route.dart';
import 'package:shape_defense/routes/game_play_route.dart';

class ShapeDefenseGame extends game.FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late LogicalKeyboardKey lastKeyDown;

  late final game.RouterComponent router;
  late RectangleComponent background;

  ShapeDefenseGame()
      : super(
            camera:
                CameraComponent.withFixedResolution(
                  width: 1200,
                  height: 800,
                  backdrop: BackgroundColorComponent(GameColors.background)
                ),
            );

  GameState state = GameState();

  @override
  Color backgroundColor() {
    return Colors.black;
  }

  @override
  Future<void> onLoad() async {
    await Flame.images.loadAllImages();
    world.add(
      router = game.RouterComponent(
        routes: {
          'game': game.Route(GamePlayRoute.new, maintainState: false),
          'game-over': game.Route(GameOverRoute.new),
        },
        initialRoute: 'game',
      ),
    );
  }

  onEnd() {
    router.pushReplacementNamed('game-over');
  }

  onRestart() {
    state = GameState();
    router.pushReplacementNamed('game');
  }
}
