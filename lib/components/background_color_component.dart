import 'dart:ui';

import 'package:flame/components.dart';

class BackgroundColorComponent extends RectangleComponent with HasGameRef {

  static Paint createPaint(Color color) {
    final p = Paint();
    p.color = color;
    return p;
  }

  BackgroundColorComponent(Color color) : super(paint: BackgroundColorComponent.createPaint(color));


  @override
  void onGameResize(Vector2 maxSize) {
    super.onGameResize(maxSize);
    size = game.camera.viewport.virtualSize;
  }
}