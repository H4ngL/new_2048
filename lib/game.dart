import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:logger/logger.dart';
import 'package:new_2048/components/button.dart';
import 'package:new_2048/components/empty_board.dart';
import 'package:new_2048/components/score_board.dart';
import 'package:new_2048/components/tile_board.dart';
import 'package:new_2048/const/colors.dart';
import 'package:new_2048/utilities/board.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  late final manager = BoardManager();
  final logger = Logger();

  late final AnimationController moveController = AnimationController(
    duration: const Duration(milliseconds: 150),
    vsync: this,
  );

  late final CurvedAnimation moveAnimation = CurvedAnimation(
    parent: moveController,
    curve: Curves.easeInOut,
  );

  late final AnimationController scaleController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

  late final CurvedAnimation scaleAnimation = CurvedAnimation(
    parent: scaleController,
    curve: Curves.easeInOut,
  );

  @override
  void dispose() {
    moveAnimation.dispose();
    scaleAnimation.dispose();
    moveController.dispose();
    scaleController.dispose();
    super.dispose();
  }

  void _onKey(event) {
    if (moveController.isAnimating) return;
    if (event is RawKeyUpEvent) {
      setState(() {
        manager.onKey(event);
        moveController.forward(from: 0.0).whenComplete(() => _afterMove());
      });
    }
  }

  void _onSwipe(direction) {
    if (moveController.isAnimating) return;
    setState(() {
      manager.onSwipe(direction);
      moveController.forward(from: 0.0).whenComplete(() => _afterMove());
    });
  }

  void _afterMove() {
    manager.afterMove();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        _onKey(event);
      },
      child: SwipeDetector(
        onSwipe: (direction, offset) {
          //_onSwipe(direction);
        },
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '2048',
                      style: TextStyle(
                        fontSize: 70.0,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const ScoreBoard(),
                        const SizedBox(
                          height: 32.0,
                        ),
                        ButtonWidget(
                          icon: Icons.refresh,
                          onPressed: () {
                            setState(
                              () {
                                manager.initBoard();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32.0,
              ),
              Stack(
                children: [
                  const EmptyBoardWidget(),
                  TileBoardWidget(
                    board: manager,
                    moveAnimation: moveAnimation,
                    scaleAnimation: scaleAnimation,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
