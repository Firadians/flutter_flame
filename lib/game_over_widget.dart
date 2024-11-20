import 'package:flutter/material.dart';

class GameOverWidget extends StatelessWidget {
  final VoidCallback onRestart;

  const GameOverWidget({Key? key, required this.onRestart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Game Over',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
              shadows: [
                Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset(3, 3)),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              textStyle: TextStyle(fontSize: 20),
            ),
            onPressed: onRestart,
            child: Text('Restart'),
          ),
        ],
      ),
    );
  }
}
