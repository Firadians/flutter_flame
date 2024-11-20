import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame_game/flappy_box_game.dart';

class Player extends SpriteComponent with CollisionCallbacks, HasGameRef {
  final double jumpStrength;
  double velocityY = 0; // Gravity effect

  Player({required this.jumpStrength});

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load the player sprite
    sprite = await gameRef.loadSprite('player.png');

    // Set size and position of the player
    size = Vector2(50, 50);
    position = Vector2(100, gameRef.size.y / 2); // Center vertically
    anchor = Anchor.center;

    // Add a collision hitbox
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply gravity
    velocityY += (gameRef as FlappyBoxGame).gravity * dt;
    position.y += velocityY * dt;

    // Check for game over if player goes off-screen
    if (position.y > gameRef.size.y || position.y < 0) {
      (gameRef as FlappyBoxGame).gameOver();
    }
  }

  void jump() {
    velocityY = jumpStrength; // Apply upward force
  }

  void reset() {
    position = Vector2(100, gameRef.size.y / 2); // Reset position
    velocityY = 0; // Reset velocity
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Pipe) {
      (gameRef as FlappyBoxGame).gameOver();
    }
    super.onCollision(intersectionPoints, other);
  }
}
