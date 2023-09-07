import 'dart:math';

import 'package:flutter/material.dart';
import 'package:new_2048/components/animted_tile.dart';
import 'package:new_2048/const/colors.dart';
//import 'package:new_2048/utilities/board.dart';
//import 'package:new_2048/models/board.dart';
import 'package:new_2048/utilities/board.dart';

class TileBoardWidget extends StatelessWidget {
  final BoardManager board;
  final CurvedAnimation moveAnimation;
  final CurvedAnimation scaleAnimation;

  const TileBoardWidget({
    super.key,
    required this.board,
    required this.moveAnimation,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final size = max(
        290.0,
        min((MediaQuery.of(context).size.shortestSide * 0.90).floorToDouble(),
            460.0));

    final sizePerTile = (size / 4).floorToDouble();
    final tileSize = sizePerTile - 12.0 - (12.0 / 4);
    final boardSize = sizePerTile * 4;

    return SizedBox(
      width: boardSize,
      height: boardSize,
      child: Stack(
        children: List.generate(
          16,
          (i) {
            var tile = board.board.tiles[(i / 4).floor()][i % 4];

            if (tile.value != 0) {
              return AnimatedTile(
                key: ValueKey(tile.id),
                tile: tile,
                moveAnimation: moveAnimation,
                scaleAnimation: scaleAnimation,
                size: tileSize,
                child: Container(
                  width: tileSize,
                  height: tileSize,
                  decoration: BoxDecoration(
                      color: tileColors[tile.value],
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                    child: Text(
                      '${tile.value}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: tile.value < 8 ? textColor : textColorWhite),
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
