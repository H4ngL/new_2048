import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:new_2048/models/board.dart';
import 'package:new_2048/models/tile.dart';

import 'package:uuid/uuid.dart';

class BoardManager {
  late Board board;

  BoardManager() {
    var tiles = List<List<Tile>>.generate(
      4,
      (i) => List<Tile>.generate(
        4,
        (index) => Tile(const Uuid().v4(), 0, i * 4 + index),
        growable: false,
      ),
      growable: false,
    );

    board = Board.newGame(0, tiles);
    addRandom();
    addRandom();
  }

  // 보드를 초기화
  initBoard() {
    var tiles = List<List<Tile>>.generate(
      4,
      (i) => List<Tile>.generate(
        4,
        (index) => Tile(const Uuid().v4(), 0, i * 4 + index),
        growable: false,
      ),
      growable: false,
    );

    board = Board.newGame(0, tiles);
    addRandom();
    addRandom();
  }

  // 2 혹은 4를 리스트의 랜덤 위치에 추가
  addRandom() {
    if (isFull()) return;

    int rand = Random().nextBool() ? 2 : 4;
    int col = Random().nextInt(4);
    int row = Random().nextInt(4);

    while (board.tiles[col][row].value != 0) {
      col = Random().nextInt(4);
      row = Random().nextInt(4);
    }

    board.tiles[col][row] = Tile(const Uuid().v4(), rand, col * 4 + row);
  }

  // board에 타일이 있는지 확인
  bool isNotEmpty() {
    return board.tiles.any((row) => row.any((tile) => tile.value != 0));
  }

  bool isFull() {
    return board.tiles.every((row) => row.every((tile) => tile.value != 0));
  }

  // 왼쪽 단순 이동에 의한 tile의 nextIndex 수정
  Tile slideLeft(Tile tile) {
    int i = tile.index ~/ 4;
    int j = tile.index % 4;
    int? nextIndex;

    if (board.tiles[i][j].value != 0) {
      int k = j;
      while (k > 0 && (board.tiles[i][k - 1].value == 0)) {
        nextIndex = board.tiles[i][k - 1].index;
        k--;
      }
    }

    return tile.copyWith(nextIndex: nextIndex);
  }

  // 왼쪽 이동
  moveLeft() {
    List<List<Tile>> tiles = [];

    for (int i = 0; i < 4; i++) {
      List<Tile> row = [];
      for (int j = 0; j < 4; j++) {
        Tile tile = slideLeft(board.tiles[i][j]);
        row.add(tile);
      }
      tiles.add(row);
    }

    board = board.copyWith(tiles: tiles);
    //addRandom();

    // for (var i = 0; i < board.tiles.length; i++) {
    //   for (var j = 0; j < board.tiles[i].length; j++) {
    //     if (board.tiles[i][j].value == 0) {
    //       continue;
    //     } else {
    //       int k = j;
    //       while (k > 0 && board.tiles[i][k - 1].value == 0) {
    //         board.tiles[i][k - 1] = board.tiles[i][k].copyWith(
    //           index: board.tiles[i][k - 1].index,
    //         );
    //         board.tiles[i][k] = Tile(const Uuid().v4(), 0, i * 4 + k);
    //         k--;
    //       }
    //     }
    //   }
    // }

    // for (int i = 0; i < 4; i++) {
    //   for (int j = 0; j < 4; j++) {
    //     print(
    //         '${board.tiles[i][j].value}, ${board.tiles[i][j].index}, ${board.tiles[i][j].nextIndex}');
    //   }
    // }
    // print("\n");
  }

  // index를 nextIndex로 바꾸고 nextIndex를 null로 바꿈
  boardUpdate() {
    List<List<Tile>> tiles = [];

    for (int i = 0; i < 4; i++) {
      List<Tile> row = [];
      for (int j = 0; j < 4; j++) {
        Tile tile = board.tiles[i][j].copyWith(
          index: board.tiles[i][j].nextIndex ?? board.tiles[i][j].index,
          nextIndex: null,
        );
        row.add(tile);
      }
      tiles.add(row);
    }

    board = board.copyWith(tiles: tiles);
  }

  onKey(RawKeyEvent event) {
    SwipeDirection? direction;
    if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
      direction = SwipeDirection.right;
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
      direction = SwipeDirection.left;
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      direction = SwipeDirection.up;
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      direction = SwipeDirection.down;
    }

    // if (event is RawKeyUpEvent) {
    //   print(event.);
    //   return;
    // }

    if (direction == SwipeDirection.left) {
      moveLeft();
      //addRandom();
    }
  }
}
