import 'package:flutter/material.dart';

typedef PanePosition = ({int x, int y});

class GridViewport {
  final PanePosition origin;

  const GridViewport({
    required this.origin,
  });

  GridViewport moveAlignment(Alignment alignment) {
    return switch (alignment) {
      Alignment.topLeft => copyWith(
          origin: (
            x: origin.x - 1,
            y: origin.y - 1,
          ),
        ),
      Alignment.topCenter => copyWith(
          origin: (
            x: origin.x,
            y: origin.y - 1,
          ),
        ),
      Alignment.topRight => copyWith(
          origin: (
            x: origin.x + 1,
            y: origin.y - 1,
          ),
        ),
      Alignment.centerLeft => copyWith(
          origin: (
            x: origin.x - 1,
            y: origin.y,
          ),
        ),
      Alignment.center => copyWith(
          origin: (
            x: origin.x,
            y: origin.y,
          ),
        ),
      Alignment.centerRight => copyWith(
          origin: (
            x: origin.x + 1,
            y: origin.y,
          ),
        ),
      Alignment.bottomLeft => copyWith(
          origin: (
            x: origin.x - 1,
            y: origin.y + 1,
          ),
        ),
      Alignment.bottomCenter => copyWith(
          origin: (
            x: origin.x,
            y: origin.y + 1,
          ),
        ),
      Alignment.bottomRight => copyWith(
          origin: (
            x: origin.x + 1,
            y: origin.y + 1,
          ),
        ),
      _ => this,
    };
  }

  GridViewport copyWith({
    PanePosition? origin,
  }) {
    return GridViewport(
      origin: origin ?? this.origin,
    );
  }
}
