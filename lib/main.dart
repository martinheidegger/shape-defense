import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shape_defense/game/shape_defense_game.dart';

void main() {
  runApp(const GameWidget.controlled(gameFactory: ShapeDefenseGame.new));
}
