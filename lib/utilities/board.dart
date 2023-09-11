import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:logger/logger.dart';

import 'package:uuid/uuid.dart';

import 'package:new_2048/components/leader_board.dart';
import 'package:new_2048/const/colors.dart';
import 'package:new_2048/firebase/firestore.dart';
import 'package:new_2048/models/board.dart';
import 'package:new_2048/models/tile.dart';

class BoardManager {
  late Board board;
  FirestoreManager fs = FirestoreManager();
  final logger = Logger();

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
    calcscore();
  }

  int worldBest = 0;

  Future<void> initializeBest() async {
    int best = await fs.getBest();
    board = board.copyWith(best: best);
  }

  // 보드를 초기화
  initBoard() async {
    var tiles = List<List<Tile>>.generate(
      4,
      (i) => List<Tile>.generate(
        4,
        (index) => Tile(const Uuid().v4(), 0, i * 4 + index),
        growable: false,
      ),
      growable: false,
    );

    int best = board.best > board.score ? board.best : board.score;

    board = Board.newGame(0, tiles);
    board = board.copyWith(best: best);
    fs.writeBest(best);

    addRandom();
    addRandom();
    calcscore();
  }

  // board가 꽉 찼는지 확인
  bool isFull() {
    return board.tiles.every((row) => row.every((tile) => tile.value != 0));
  }

  // 2 혹은 4를 리스트의 랜덤 위치에 추가
  addRandom() {
    if (isFull()) return;

    List<Tile> emptyTiles = [];

    for (var row in board.tiles) {
      for (var tile in row) {
        if (tile.value == 0) {
          emptyTiles.add(tile);
        }
      }
    }

    int rand = Random().nextBool() ? 2 : 4;
    int index = Random().nextInt(emptyTiles.length);
    int row = emptyTiles[index].index ~/ 4;
    int col = emptyTiles[index].index % 4;

    board.tiles[row][col] = board.tiles[row][col].copyWith(value: rand);
  }

  // 점수 계산
  calcscore() async {
    int score = 0;
    for (var row in board.tiles) {
      for (var tile in row) {
        score += tile.value;
      }
    }
    board.score = score;
  }

  // 움직일 수 있는지 확인
  bool isMovable() {
    if (!isFull()) {
      return true;
    } else {
      // 주변에 같은 숫자가 있는지 확인
      for (var i = 0; i < board.tiles.length; i++) {
        for (var j = 0; j < board.tiles[i].length - 1; j++) {
          if (board.tiles[i][j].value == board.tiles[i][j + 1].value) {
            return true;
          }
        }
      }

      for (var i = 0; i < board.tiles.length; i++) {
        for (var j = 0; j < board.tiles[i].length - 1; j++) {
          if (board.tiles[j][i].value == board.tiles[j + 1][i].value) {
            return true;
          }
        }
      }

      return false;
    }
  }

  // 게임 오버 확인
  bool isOver() {
    if (isFull() && !isMovable()) {
      return true;
    }
    return false;
  }

  // 왼순 단순 이동에 의한 tile list의 nextIndex 수정
  List<Tile> slideLeft(List<Tile> tiles, int leftIndex) {
    List<Tile> newTiles = [];

    int recentValue = 0;
    int nextIndex = 0;
    bool firstIndex = true;

    for (int i = 0; i < 4; i++) {
      if (tiles[i].value != 0) {
        // 첫 번째로 value를 소지한 타일이라면
        if (firstIndex) {
          newTiles.add(tiles[i].copyWith(nextIndex: leftIndex));
          firstIndex = false;
          recentValue = tiles[i].value;
          nextIndex = leftIndex;
        } else {
          // merge가 가능하다면
          if (recentValue == tiles[i].value) {
            newTiles.add(tiles[i].copyWith(nextIndex: nextIndex));
            recentValue = 0;
          } else {
            newTiles.add(tiles[i].copyWith(nextIndex: nextIndex + 1));
            recentValue = tiles[i].value;
            nextIndex++;
          }
        }
      } else {
        newTiles.add(tiles[i].copyWith());
      }
    }

    return newTiles;
  }

  // 오른쪽 단순 이동에 의한 tile list의 nextIndex 수정
  List<Tile> slideRight(List<Tile> tiles, int rightIndex) {
    List<Tile> newTiles = [];

    int recentValue = 0;
    int nextIndex = 0;
    bool firstIndex = true;

    for (int i = 3; i >= 0; i--) {
      if (tiles[i].value != 0) {
        // 첫 번째로 value를 소지한 타일이라면
        if (firstIndex) {
          newTiles.add(tiles[i].copyWith(nextIndex: rightIndex));
          firstIndex = false;
          recentValue = tiles[i].value;
          nextIndex = rightIndex;
        } else {
          // merge가 가능하다면
          if (recentValue == tiles[i].value) {
            newTiles.add(tiles[i].copyWith(nextIndex: nextIndex));
            recentValue = 0;
          } else {
            newTiles.add(tiles[i].copyWith(nextIndex: nextIndex - 1));
            recentValue = tiles[i].value;
            nextIndex--;
          }
        }
      } else {
        newTiles.add(tiles[i].copyWith());
      }
    }

    return newTiles;
  }

  // 위쪽 단순 이동에 의한 tile list의 nextIndex 수정
  List<Tile> slideUp(List<Tile> tiles, upIndex) {
    List<Tile> newTiles = [];

    int recentValue = 0;
    int nextIndex = 0;
    bool firstIndex = true;

    for (int i = 0; i < 4; i++) {
      if (tiles[i].value != 0) {
        // 첫 번째로 value를 소지한 타일이라면
        if (firstIndex) {
          newTiles.add(tiles[i].copyWith(nextIndex: upIndex));
          firstIndex = false;
          recentValue = tiles[i].value;
          nextIndex = upIndex;
        } else {
          // merge가 가능하다면
          if (recentValue == tiles[i].value) {
            newTiles.add(tiles[i].copyWith(nextIndex: nextIndex));
            recentValue = 0;
          } else {
            newTiles.add(tiles[i].copyWith(nextIndex: nextIndex + 4));
            recentValue = tiles[i].value;
            nextIndex += 4;
          }
        }
      } else {
        newTiles.add(tiles[i].copyWith());
      }
    }

    return newTiles;
  }

  // 아래쪽 단순 이동에 의한 tile list의 nextIndex 수정
  List<Tile> slideDown(List<Tile> tiles, downIndex) {
    List<Tile> newTiles = [];

    int recentValue = 0;
    int nextIndex = 0;
    bool firstIndex = true;

    for (int i = 3; i >= 0; i--) {
      if (tiles[i].value != 0) {
        // 첫 번째로 value를 소지한 타일이라면
        if (firstIndex) {
          newTiles.add(tiles[i].copyWith(nextIndex: downIndex));
          firstIndex = false;
          recentValue = tiles[i].value;
          nextIndex = downIndex;
        } else {
          // merge가 가능하다면
          if (recentValue == tiles[i].value) {
            newTiles.add(tiles[i].copyWith(nextIndex: nextIndex));
            recentValue = 0;
          } else {
            newTiles.add(tiles[i].copyWith(nextIndex: nextIndex - 4));
            recentValue = tiles[i].value;
            nextIndex -= 4;
          }
        }
      } else {
        newTiles.add(tiles[i].copyWith());
      }
    }

    return newTiles;
  }

  // 왼쪽 이동
  moveLeft() {
    List<List<Tile>> tiles = [];

    for (int i = 0; i < 4; i++) {
      tiles.add(slideLeft(board.tiles[i], i * 4));
    }

    board = board.copyWith(tiles: tiles);
  }

  // 오른쪽 이동
  moveRight() {
    List<List<Tile>> tiles = [];

    for (int i = 0; i < 4; i++) {
      tiles.add(slideRight(board.tiles[i], i * 4 + 3));
    }

    board = board.copyWith(tiles: tiles);
  }

  // 위쪽 이동
  moveUp() {
    List<List<Tile>> tiles = [];

    for (int i = 0; i < 4; i++) {
      tiles.add(slideUp(board.tiles.map((e) => e[i]).toList(), i));
    }

    board = board.copyWith(tiles: tiles);
  }

  // 아래쪽 이동
  moveDown() {
    List<List<Tile>> tiles = [];

    for (int i = 0; i < 4; i++) {
      tiles.add(slideDown(board.tiles.map((e) => e[i]).toList(), i + 12));
    }

    board = board.copyWith(tiles: tiles);
  }

  // board 업데이트
  boardUpdate() {
    var tiles = List<List<Tile>>.generate(
      4,
      (i) => List<Tile>.generate(
        4,
        (index) => Tile(const Uuid().v4(), 0, i * 4 + index),
        growable: false,
      ),
      growable: false,
    );

    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board.tiles[i][j].value != 0 &&
            board.tiles[i][j].nextIndex != null) {
          int row = (board.tiles[i][j].nextIndex ?? 0) ~/ 4;
          int col = (board.tiles[i][j].nextIndex ?? 0) % 4;

          if (tiles[row][col].value != 0) {
            tiles[row][col] = tiles[row][col].copyWith(
              value: tiles[row][col].value * 2,
              merged: true,
            );
          } else {
            tiles[row][col] = board.tiles[i][j].copyWith(
              index: board.tiles[i][j].nextIndex ?? board.tiles[i][j].index,
              nextIndex: null,
            );
          }
        }
      }
    }

    board = board.copyWith(tiles: tiles);
  }

  // addRandom 여부 확인
  afterMove() {
    boardUpdate();

    // 전 보드(undo)와 비교하여 움직였다면 addRandom
    if (!board.isSameBoard) {
      addRandom();
    }
    board = board.copyWith(undo: board);
    calcscore();

    if (isOver()) {
      board = board.copyWith(over: true);
    }
  }

  // 키보드 입력
  onKey(RawKeyEvent event) {
    SwipeDirection? direction;
    if (event.logicalKey.keyLabel == "Arrow Right") {
      direction = SwipeDirection.right;
    } else if (event.logicalKey.keyLabel == "Arrow Left") {
      direction = SwipeDirection.left;
    } else if (event.logicalKey.keyLabel == "Arrow Up") {
      direction = SwipeDirection.up;
    } else if (event.logicalKey.keyLabel == "Arrow Down") {
      direction = SwipeDirection.down;
    }

    if (direction == SwipeDirection.left) {
      moveLeft();
    } else if (direction == SwipeDirection.right) {
      moveRight();
    } else if (direction == SwipeDirection.up) {
      moveUp();
    } else if (direction == SwipeDirection.down) {
      moveDown();
    }
  }

  // 스와이프 입력
  onSwipe(direction) {
    if (direction == SwipeDirection.left) {
      moveLeft();
    } else if (direction == SwipeDirection.right) {
      moveRight();
    } else if (direction == SwipeDirection.up) {
      moveUp();
    } else if (direction == SwipeDirection.down) {
      moveDown();
    }
  }

  void showLeaderboardDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Leader Board',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LeaderBoardWidget(top10: fs.top10),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('close', style: TextStyle(color: textColor)),
            ),
          ],
        );
      },
    );
  }
}
