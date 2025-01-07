import 'package:reversed_minesweeper/models/piece_data_model.dart';

abstract class GameEvent {}

class GameStartEvent extends GameEvent {}

class BombExplodedEvent extends GameEvent {
  BombExplodedEvent();
}

class ExplosionAnimationEndedEvent extends GameEvent {
  final int row;
  final int col;

  ExplosionAnimationEndedEvent({
    required this.row,
    required this.col,
  });
}

class PieceDroppedEvent extends GameEvent {
  final PieceData piece;
  final int startRow;
  final int startCol;
  final int targetRow;
  final int targetCol;
  PieceDroppedEvent(
      {required this.piece,
      required this.startRow,
      required this.startCol,
      required this.targetRow,
      required this.targetCol});
}

class CheckGameOverEvent extends GameEvent {}
