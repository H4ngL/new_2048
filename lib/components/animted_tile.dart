import 'package:flutter/material.dart';

import '../models/tile.dart';

class AnimatedTile extends AnimatedWidget {
  //We use Listenable.merge in order to update the animated widget when both of the controllers have change
  AnimatedTile(
      {super.key,
      required this.moveAnimation,
      required this.tile,
      required this.child,
      required this.size})
      : super(listenable: Listenable.merge([moveAnimation]));

  final Tile tile;
  final Widget child;
  final CurvedAnimation moveAnimation;
  final double size;

  late final double _top = tile.getTop(size);
  late final double _left = tile.getLeft(size);
  late final double _nextTop = tile.getNextTop(size) ?? _top;
  late final double _nextLeft = tile.getNextLeft(size) ?? _left;

  late final Animation<double> top = Tween<double>(
    begin: _top,
    end: _nextTop,
  ).animate(
    moveAnimation,
  );
  
  late final Animation<double> left = Tween<double>(
    begin: _left,
    end: _nextLeft,
  ).animate(
    moveAnimation,
  );

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top.value,
      left: left.value,
      child: child,
    );
  }
}
