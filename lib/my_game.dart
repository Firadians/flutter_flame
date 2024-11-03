import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame with TapDetector {
  late Player player;

  @override
  Future<void> onLoad() async {
    // Set the background color
    camera.viewport = FixedResolutionViewport(resolution: Vector2(400, 600));
    add(ScreenHitbox()); // Allows tapping within the screen
    player = Player();
    add(player);
  }

  @override
  void onTap() {
    player.jump();
  }
}

class Player extends PositionComponent with HasGameRef<MyGame> {
  static const double _speed = 200; // Speed of the player's movement
  bool movingDown = true; // Direction of movement

  Player() {
    size = Vector2(50, 50);
    position = Vector2(175, 300); // Centered in the screen
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.blue;
    canvas.drawRect(size.toRect(), paint);
  }

  @override
  void update(double dt) {
    // Move up or down based on movingDown flag
    if (movingDown) {
      position.y += _speed * dt;
      if (position.y > 550) movingDown = false; // Bounce at the bottom
    } else {
      position.y -= _speed * dt;
      if (position.y < 0) movingDown = true; // Bounce at the top
    }
  }

  void jump() {
    movingDown = !movingDown; // Change direction on tap
  }
}
