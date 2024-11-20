import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(
    GameWidget(
      game: FlappyBoxGame(),
      overlayBuilderMap: {
        'GameOver': (context, FlappyBoxGame game) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'You Fail!',
                    style: TextStyle(fontSize: 40, color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      game.reset();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
      },
      initialActiveOverlays: const [], // Start with no overlays
    ),
  );
}

class FlappyBoxGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Player player;
  late Timer pipeTimer;
  final double gravity = 800; // Gravity strength
  final double jumpStrength = -300; // Jump force
  bool isGameOver = false;
  int score = 0; // Add score counter
  late TextComponent scoreText; // Component to display the score

  @override
  Future<void> onLoad() async {
    // Set up the player
    player = Player(this, jumpStrength: jumpStrength);
    add(player);

    // Set up pipe spawner timer
    pipeTimer = Timer(2, repeat: true, onTick: spawnPipe);
    pipeTimer.start();

    // Add the score text
    scoreText = TextComponent(
      text: 'Score: $score',
      position: Vector2(size.x / 2, 20),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),
      ),
    );

    add(scoreText);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isGameOver) {
      pipeTimer.update(dt);

      // Increase the score based on movement or time
      score += (150 * dt).toInt(); // Add based on steps or movement
      scoreText.text = 'Score: $score'; // Update the score text
    }
  }

  @override
  void onTap() {
    if (!isGameOver) {
      player.jump();
    }
  }

  @override
  void render(Canvas canvas) {
    // Render grey background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = Colors.grey,
    );

    super.render(canvas); // Render all other components
  }

  void spawnPipe() {
    final pipeGap = 150.0;
    final pipeWidth = 60.0;
    final topPipeHeight = Random().nextDouble() * (size.y - pipeGap - 100) + 50;

    // Top pipe
    add(Pipe(this, Vector2(pipeWidth, topPipeHeight), isTop: true));

    // Bottom pipe
    final bottomPipeY = topPipeHeight + pipeGap;
    final bottomPipeHeight = size.y - bottomPipeY;
    add(Pipe(this, Vector2(pipeWidth, bottomPipeHeight),
        isTop: false, yPos: bottomPipeY));
  }

  void gameOver() {
    if (!isGameOver) {
      isGameOver = true;
      overlays.add('GameOver'); // Show overlay
      Future.delayed(const Duration(milliseconds: 50), () {
        pauseEngine(); // Pause engine after adding overlay
      });
    }
  }

  void restartGame() {
    isGameOver = false;
    score = 0; // Reset score on restart
    scoreText.text = 'Score: $score'; // Reset score text
    children.whereType<Pipe>().forEach((pipe) => pipe.removeFromParent());
    player.reset();
    overlays.remove('GameOver'); // Remove the GameOver overlay
    resumeEngine(); // Resume the game
  }

  void reset() {
    isGameOver = false;
    score = 0; // Reset score when retrying
    scoreText.text = 'Score: $score'; // Reset score text
    player.reset();
    children.whereType<Pipe>().forEach((pipe) => pipe.removeFromParent());
    overlays.remove('GameOver'); // Remove overlay when retrying
    resumeEngine();
  }
}

class Player extends RectangleComponent with CollisionCallbacks {
  final double jumpStrength;
  final FlappyBoxGame gameRef; // Keep reference to game instance
  double velocityY = 0;

  Player(this.gameRef, {required this.jumpStrength}) {
    size = Vector2(40, 40);
    position = Vector2(50, 300); // Starting position
    anchor = Anchor.center;

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply gravity to the player
    velocityY += gameRef.gravity * dt; // Use gameRef.gravity for consistency
    position.y += velocityY * dt;

    // Check if player goes off the screen
    if (position.y > gameRef.size.y || position.y < 0) {
      gameRef.gameOver(); // End game if player goes off screen
    }
  }

  void jump() {
    velocityY = jumpStrength; // Set upward velocity for jump
  }

  void reset() {
    position = Vector2(50, 300);
    velocityY = 0;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Pipe) {
      gameRef.gameOver(); // Trigger game over on collision
    }
    super.onCollision(intersectionPoints, other);
  }
}

class Pipe extends PositionComponent with CollisionCallbacks {
  final FlappyBoxGame gameRef; // Keep reference to game instance
  final bool isTop;
  final double width;

  Pipe(this.gameRef, Vector2 size, {required this.isTop, double yPos = 0})
      : width = size.x {
    this.size = Vector2(width, size.y);
    position = Vector2(gameRef.size.x, yPos);
    anchor = isTop ? Anchor.bottomCenter : Anchor.topCenter;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move pipe to the left
    position.x -= 150 * dt;

    // Remove pipe if it goes off screen
    if (position.x + width < 0) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.green;
    canvas.drawRect(size.toRect(), paint);
  }
}
