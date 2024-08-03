import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shape_defence/game/shape_defence_game.dart';

void main() {
  runApp(const GameWidget.controlled(gameFactory: ShapeDefenceGame.new));
}
