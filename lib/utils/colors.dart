import 'package:flutter/material.dart';
import '../models/player.dart';

Color getPositionColor(Position position) {
  switch (position) {
    case Position.goalkeeper:
      return Colors.orange;
    case Position.defender:
      return Colors.blue;
    case Position.midfielder:
      return Colors.green;
    case Position.forward:
      return Colors.red;
  }
}
