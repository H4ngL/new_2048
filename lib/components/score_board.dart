import 'package:flutter/material.dart';
import 'package:new_2048/const/colors.dart';

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //TODO : Add Real Score and Best Score
        Score(
          label: 'SCORE',
          score: '0',
        ),
        SizedBox(
          width: 8.0,
        ),
        Score(
          label: 'BEST',
          score: '0',
          padding: EdgeInsets.symmetric(horizontal: 23.0, vertical: 8.0),
        ),
      ],
    );
  }
}

class Score extends StatelessWidget {
  final String label;
  final String score;
  final EdgeInsets? padding;

  const Score({
    super.key,
    required this.label,
    required this.score,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: scoreColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: color2,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          Text(
            score,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
