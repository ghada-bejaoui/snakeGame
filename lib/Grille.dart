import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Grille extends CustomPainter {
  final List<Offset> snake;
  final Offset apple; // Position de la pomme


  Grille({required this.snake, required this.apple}); // Le constructeur prend la pomme en plus du serpent


  @override
  void paint(Canvas canvas, Size size) {
    int rows = 20;
    int columns = 20;

    double cellWidth = size.width / columns;
    double cellHeight = size.height / rows;

    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0;

    // Dessiner les lignes horizontales
    for (int i = 0; i <= rows; i++) {
      double y = i * cellHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Dessiner les lignes verticales
    for (int i = 0; i <= columns; i++) {
      double x = i * cellWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Dessiner le serpent
    final snakePaint = Paint()..color = Colors.green; // Couleur du serpent

    for (var segment in snake) {
      double left = segment.dx * cellWidth;
      double top = segment.dy * cellHeight;
      double right = left + cellWidth;
      double bottom = top + cellHeight;

      canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), snakePaint);
    }

    // Dessiner le apple
    final applePaint = Paint()..color = Colors.pink; // Couleur du serpent

    double left = apple.dx * cellWidth;
    double top = apple.dy * cellHeight;
    double right = left + cellWidth;
    double bottom = top + cellHeight;

    canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), applePaint);
  }

  @override
  bool shouldRepaint(Grille oldDelegate) => false;
}
