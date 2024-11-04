import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame_game/my_game.dart';

class Player extends SpriteComponent with CollisionCallbacks {
  @override
  void onLoad() {
    super.onLoad();
    // Set up the player (load sprite, size, position, etc.)
    // Example:
    // sprite = await Sprite.load('player.png');
    // size = Vector2(50, 50);

    add(RectangleHitbox()); // Add a hitbox for collision detection
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // When the player collides with another object, trigger game over
    final game = other.findGame() as FlappyBoxGame;
    game.gameOver();
  }
}
