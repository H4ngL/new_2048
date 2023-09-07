import '../models/tile.dart';

class Board {
  //board의 현재 점수
  int score;
  //best score
  final int best;
  //현재 보여지는 tile list
  List<List<Tile>> tiles;
  //게임 오버인지 아닌지
  final bool over;
  //전 board 저장
  final Board? undo;

  Board(this.score, this.best, this.tiles, {this.over = false, this.undo});

  //Create a model for a new game.
  Board.newGame(this.best, this.tiles)
      : score = 0,
        over = false,
        undo = null;

  //Create an immutable copy of the board
  Board copyWith(
          {int? score,
          int? best,
          List<List<Tile>>? tiles,
          bool? over,
          Board? undo}) =>
      Board(score ?? this.score, best ?? this.best, tiles ?? this.tiles,
          over: over ?? this.over, undo: undo ?? this.undo);

  bool get isSameBoard {
    if (undo == null) return false;
    for (int i = 0; i < tiles.length; i++) {
      for (int j = 0; j < tiles[i].length; j++) {
        if (tiles[i][j].value != undo!.tiles[i][j].value) return false;
      }
    }
    return true;
  }
}
