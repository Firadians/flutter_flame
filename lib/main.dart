import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'flappy_box_game.dart';
import 'game_over_widget.dart'; // Ensure GameOverWidget is correctly imported

void main() {
  runApp(GameApp());
}

class GameApp extends StatelessWidget {
  final FlappyBoxGame game = FlappyBoxGame();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GameWidget<FlappyBoxGame>(
          game: game,
          // overlayBuilderMap needs to accept (BuildContext, FlappyBoxGame)
          overlayBuilderMap: {
            'GameOver': (BuildContext context, FlappyBoxGame game) {
              return GameOverWidget(
                onRestart: game
                    .restartGame, // Correctly pass the game's restart method
              );
            },
          },
          initialActiveOverlays: const [], // No overlays active initially
        ),
      ),
    );
  }
}
