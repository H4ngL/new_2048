import 'package:flutter/material.dart';
import 'package:new_2048/const/colors.dart';

class ButtonWidget extends StatelessWidget {
  final IconData? icon;
  final VoidCallback onPressed;

  const ButtonWidget({
    super.key,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return Container(
        decoration: BoxDecoration(
          color: scoreColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: IconButton(
          color: textColorWhite,
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 24.0,
          ),
        ),
      );
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
      ),
      onPressed: onPressed,
      child: const Text(
        'New Game',
      ),
    );
  }
}
